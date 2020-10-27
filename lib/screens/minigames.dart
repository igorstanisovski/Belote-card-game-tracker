import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MiniGames extends StatefulWidget {
  final String gameID;
  final String documentID;

  const MiniGames(this.gameID,this.documentID);
  @override
  _MiniGamesState createState() => _MiniGamesState();
}

class _MiniGamesState extends State<MiniGames> {
  final firestoreInstance = Firestore.instance;
  var miniGames = [];
  var player1,player2,player3,player4;
  @override
  void initState() {
    firestoreInstance.collection('users').document(widget.documentID).collection('games').document(widget.gameID).get().then((value) => {
      setState(() {
        miniGames = value['miniGames'];
        player1 = value['playerOne'];
        player2 = value['playerTwo'];
        player3 = value['playerThree'];
        player4 = value['playerFour'];
      })
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text('Мали партии'),),
      body: new ListView.builder(
          itemCount: miniGames.length,
          itemBuilder: (BuildContext context, int index) {
            return new Container(
              height: 110,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(5),
              decoration: new BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10)
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(child: Text(player1,style: TextStyle(fontSize: 22 ),),padding: EdgeInsets.all(3),),
                      Container(child: Text(
                          miniGames[index]['teamOneScore'].toString(),
                          style: TextStyle(
                              fontSize: 27 ,
                              fontWeight: FontWeight.bold,
                              color: miniGames[index]['teamOneScore'] > miniGames[index]['teamTwoScore']? Colors.green.shade700 : Colors.red.shade700)),
                        padding: EdgeInsets.all(3),),
                      Container(child: Text(player2, style: TextStyle(fontSize: 22 )),padding: EdgeInsets.all(3),)
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text((index+1).toString(), style: TextStyle(fontSize: 20),),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(child: Text(player3, style: TextStyle(fontSize: 22 )),padding: EdgeInsets.all(3),),
                      Container(child: Text(
                          miniGames[index]['teamTwoScore'].toString(),
                          style: TextStyle(
                            fontSize: 27 ,
                            fontWeight: FontWeight.bold,
                            color: miniGames[index]['teamOneScore'] < miniGames[index]['teamTwoScore']? Colors.green.shade700 : Colors.red.shade700)),
                        padding: EdgeInsets.all(3),),
                      Container(child: Text(player4, style: TextStyle(fontSize: 22 )),padding: EdgeInsets.all(3),)
                    ],
                  ),
                ],
              ),
            );
          }
      )
    );
  }
}

