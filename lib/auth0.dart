import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/about_us.dart';
import 'screens/history.dart';
import 'screens/instructions.dart';
import 'screens/player_statisctics.dart';
import 'screens/new_game.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

final FlutterAppAuth appAuth = FlutterAppAuth();
final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

const AUTH0_DOMAIN = 'dev-xdxk2r2v.eu.auth0.com';
const AUTH0_CLIENT_ID = 'w3MiYmTWGx1Hsq8Et7a3VT6hB6s02t8i';

const AUTH0_REDIRECT_URI = 'com.belotetracker://login-callback';
const AUTH0_ISSUER = 'https://$AUTH0_DOMAIN';
final firestoreInstance = Firestore.instance;

Future<String> addUser(String id, String name) async{
  var documentID = '';
  var document = await firestoreInstance.collection("users").where('auth0_id', isEqualTo: id).limit(1).getDocuments();
  final key = encrypt.Key.fromLength(32);
  final iv = encrypt.IV.fromLength(8);
  final encrypter = encrypt.Encrypter(encrypt.Salsa20(key));
  final encrypted = encrypter.encrypt(name, iv: iv);
  if(document.documents.isEmpty){
    await firestoreInstance.collection('users').add({
      'auth0_id': id,
      'name': encrypted.base64
    }).then((value) => documentID = value.documentID);
  }
  else {
    documentID = document.documents.elementAt(0).documentID;
  }
  return documentID;

}



class Auth0 extends StatefulWidget {
  @override
  _Auth0State createState() => _Auth0State();
}

class _Auth0State extends State<Auth0> {
  bool isBusy = false;
  bool isLoggedIn = false;
  String errorMessage;
  String name;
  String picture;
  String id;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Belote tracker',
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Писуљче за бељот'),
          actions: [
            isLoggedIn?
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(this.name, style: TextStyle(fontSize: 12),)
              ],
            )    :
            Row() ,
            isLoggedIn?
            IconButton(icon: Icon(Icons.logout,color: Colors.white,), onPressed: () { logoutAction(); }) :
            Row(),
          ],
        ),
        body: Center(
          child: isBusy?
          CircularProgressIndicator() : isLoggedIn?
          Profile(logoutAction,name,picture,id) : Login(loginAction,errorMessage),
        ),
      ),
    );
  }

  Map<String,dynamic> parseIdToken(String idToken) {
    final parts = idToken.split(r'.');
    assert(parts.length == 3);

    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  Future<Map> getUserDetails(String accessToken) async {
    final url = 'https://$AUTH0_DOMAIN/userinfo';
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  Future<void> loginAction() async {
    setState(() {
      isBusy = true;
      errorMessage = '';
    });

    try {
      final AuthorizationTokenResponse result =
      await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          AUTH0_CLIENT_ID,
          AUTH0_REDIRECT_URI,
          issuer: 'https://$AUTH0_DOMAIN',
          scopes: ['openid', 'profile', 'offline_access'],
          promptValues: ['login']
        ),
      );

      final idToken = parseIdToken(result.idToken);
      final profile = await getUserDetails(result.accessToken);

      await secureStorage.write(
          key: 'refresh_token', value: result.refreshToken);

      setState(() {
        isBusy = false;
        isLoggedIn = true;
        name = idToken['name'];
        id = idToken['sub'];
        picture = profile['picture'];
      });
    } catch (e, s) {
      print('login error: $e - stack: $s');

      setState(() {
        isBusy = false;
        isLoggedIn = false;
        errorMessage = e.toString();
      });
    }
  }

  void logoutAction() async {
    await secureStorage.delete(key: 'refresh_token');
    setState(() {
      isLoggedIn = false;
      isBusy = false;
    });
  }

  void initAction() async {
    final storedRefreshToken = await secureStorage.read(key: 'refresh_token');
    if (storedRefreshToken == null) return;

    setState(() {
      isBusy = true;
    });

    try {
      final response = await appAuth.token(TokenRequest(
        AUTH0_CLIENT_ID,
        AUTH0_REDIRECT_URI,
        issuer: AUTH0_ISSUER,
        refreshToken: storedRefreshToken,
      ));

      final idToken = parseIdToken(response.idToken);
      final profile = await getUserDetails(response.accessToken);

      secureStorage.write(key: 'refresh_token', value: response.refreshToken);

      setState(() {
        isBusy = false;
        isLoggedIn = true;
        name = idToken['name'];
        id = idToken['sub'];
        picture = profile['picture'];
      });
    } catch (e, s) {
      print('error on refresh token: $e - stack: $s');
      logoutAction();
    }
  }

  @override
  void initState() {
    initAction();
    super.initState();
  }
}

class Profile extends StatefulWidget {
  final logoutAction;
  final String name;
  final String picture;
  final String id;

  Profile(this.logoutAction, this.name, this.picture,this.id);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String documentID = '';
  @override
  void initState() {
    super.initState();
    addUser(widget.id, widget.name).then((value) => setState(() {
      this.documentID = value;
    }));
  }
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 5),
              child: RaisedButton(
                child: Text("Нова партија",style: TextStyle(fontSize: 23, color: Colors.white),),
                onPressed: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewGame(documentID))),
                },
                color: Colors.blue,
                textColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              ),
            ),
            Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 5),
              child: RaisedButton(
                child: Text("Сите партии",style: TextStyle(fontSize: 23, color: Colors.white),),
                onPressed: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => History(documentID)))
                },
                color: Colors.blue,
                textColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              ),
            ),
            Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 5),
              child: RaisedButton(
                child: Text("Статистика",style: TextStyle(fontSize: 23, color: Colors.white),),
                onPressed: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerStatistics(this.documentID)))
                },
                color: Colors.blue,
                textColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              ),
            ),
//            Container(
//              width: double.infinity,
//              height: 40,
//              margin: EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 5),
//              child: RaisedButton(
//                child: Text("Инструкции",style: TextStyle(fontSize: 23, color: Colors.white),),
//                onPressed: () => {
//                  Navigator.push(context, MaterialPageRoute(builder: (context) => Instructions()))
//                },
//                color: Colors.blue,
//                textColor: Colors.black,
//                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
//              ),
//            ),
//            Container(
//              width: double.infinity,
//              height: 40,
//              margin: EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 5),
//              child: RaisedButton(
//                child: Text("За нас",style: TextStyle(fontSize: 23, color: Colors.white),),
//                onPressed: () => {
//                  Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUs()))
//                },
//                color: Colors.blue,
//                textColor: Colors.black,
//                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
//              ),
//            ),
          ],
        )
    );
  }
}

class Login extends StatelessWidget {
  final loginAction;
  final String loginError;

  const Login(this.loginAction, this.loginError);

  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset('assets/images/belote.jpg'),
        Text('Добредојдовте во писуљчето!', style: TextStyle(fontSize: 20),),
        Padding(padding: EdgeInsets.all(5)),
        Text('Најавете се и започнете со игра!',style: TextStyle(fontSize: 20),),
        Padding(padding: EdgeInsets.all(5)),
        RaisedButton(
          color: Colors.blue.shade100,
          onPressed: () {
            loginAction();
          },
          child: SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.login),
                Text('Најави се', style: TextStyle(fontSize: 15),)
              ],
            ),
          ),
        ),
        //Text(loginError ?? ''),
      ],
    );
  }
}


