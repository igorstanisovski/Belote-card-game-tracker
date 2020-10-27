import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'game_started.dart';

class NewGame extends StatefulWidget {
  final String documentID;

  const NewGame(this.documentID);
  @override
  _NewGameState createState() => _NewGameState();
}

class _NewGameState extends State<NewGame> {
  final player1Controller = TextEditingController();
  final player2Controller = TextEditingController();
  final player3Controller = TextEditingController();
  final player4Controller = TextEditingController();
  num score = 1001;
  var playerList = new List(4);
  bool _validatePlayer1 = false;
  bool _validatePlayer2 = false;
  bool _validatePlayer3 = false;
  bool _validatePlayer4 = false;
  bool _validatePlayers = true;
  String matches = '';
  List<String> matchesList = [];

  @override
  void initState() {
      if(matchesList.isNotEmpty){
        matchesList.clear();
      }
      matchesList.add('Една партија');
      matchesList.add('Едно римско');
      matchesList.add('Две римски');
      matchesList.add('Три римски');
      matches = matchesList[0];
    super.initState();
  }
  @override
  void dispose() {
    player1Controller.dispose();
    player2Controller.dispose();
    player3Controller.dispose();
    player4Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(title: Text("Нова партија")),
          body: SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 100),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text("Нова партија",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),) ,
                        ),
                        Container(
                            margin: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Flexible(
                                  child: new TextFormField(
                                    controller: player1Controller,
                                    decoration: InputDecoration(
                                      labelText: 'Играч 1',
                                      errorText: _validatePlayer1 ?  ('Внеси играч') : null,
                                      fillColor: Colors.grey,
                                      border: new OutlineInputBorder(
                                          borderRadius: new BorderRadius.circular(25.0),
                                          borderSide: new BorderSide()
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 55, child: Text("  Тим 1")),
                                new Flexible(
                                  child: new TextFormField(
                                    controller: player2Controller,
                                    decoration: InputDecoration(
                                      labelText: 'Партнер',
                                      errorText: _validatePlayer2 ? ('Внеси играч') : null,
                                      fillColor: Colors.grey,
                                      border: new OutlineInputBorder(
                                          borderRadius: new BorderRadius.circular(25.0),
                                          borderSide: new BorderSide()
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                        Container(
                          child: Text("VS", style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold
                          ),),),
                        Container(
                            margin: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Flexible(
                                  child: new TextFormField(
                                    controller: player3Controller,
                                    decoration: InputDecoration(
                                      labelText: 'Играч 2',
                                      errorText: _validatePlayer3 ?  'Внеси играч' : null,
                                      fillColor: Colors.grey,
                                      border: new OutlineInputBorder(
                                          borderRadius: new BorderRadius.circular(25.0),
                                          borderSide: new BorderSide()
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 55, child: Text("  Тим 2")),
                                new Flexible(
                                  child: new TextFormField(
                                    controller: player4Controller,
                                    decoration: InputDecoration(
                                      labelText: 'Партнер',
                                      errorText: _validatePlayer4 ? ('Внеси играч') : null,
                                      fillColor: Colors.grey,
                                      border: new OutlineInputBorder(
                                          borderRadius: new BorderRadius.circular(25.0),
                                          borderSide: new BorderSide()
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      'До колку поени?',
                                      style: TextStyle(
                                          fontSize: 20
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: new DropdownButton<int>(
                                      value: score,
                                      items: <int>[501, 1001].map((int value) {
                                        return new DropdownMenuItem<int>(
                                          value: value,
                                          child: new Text(value.toString(), style: TextStyle(fontSize: 20),),
                                        );
                                      }).toList(),
                                      onChanged: (num score) {
                                        setState(() {
                                          this.score = score;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      'Колку парти?',
                                      style: TextStyle(
                                          fontSize: 20
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: new DropdownButton<String>(
                                      value: matches,
                                      items: matchesList.map((String value) {
                                        return new DropdownMenuItem<String>(
                                          value: value,
                                          child: new Text(value, style: TextStyle(fontSize: 20),),
                                        );
                                      }).toList(),
                                      onChanged: (String value) {
                                        setState(() {
                                          this.matches = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ),
          floatingActionButton: new FloatingActionButton.extended(
            onPressed: ()  {
              setState(() {
                _validatePlayers = true;
                player1Controller.text.isEmpty ? _validatePlayer1 = true : _validatePlayer1 = false; playerList[0]=(player1Controller.text);
                player2Controller.text.isEmpty ? _validatePlayer2 = true : _validatePlayer2 = false; playerList[1]=(player2Controller.text);
                player3Controller.text.isEmpty ? _validatePlayer3 = true : _validatePlayer3 = false; playerList[2]=(player3Controller.text);
                player4Controller.text.isEmpty ? _validatePlayer4 = true : _validatePlayer4 = false; playerList[3]=(player4Controller.text);
                var distinctPlayers = playerList.toSet().toList();
                if(distinctPlayers.length < playerList.length){
                  _validatePlayers = false;
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                      AlertDialog(title: Text("Не смеј да има играчи со исто име!", textAlign: TextAlign.center,))
                  );
                }
              });
              if(!_validatePlayer1 && !_validatePlayer2 && !_validatePlayer3 && !_validatePlayer4 && _validatePlayers){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    GameStarted(
                        widget.documentID,
                        player1Controller.text,
                        player2Controller.text,
                        player3Controller.text,
                        player4Controller.text,
                        score,
                        null,
                        matches,
                        true
                    )));
              }
            },
            backgroundColor: Colors.green,
            label: Text('Старт', style: TextStyle(fontSize: 17),),
            icon: Icon(Icons.play_arrow),
          ),
        )
    );
  }
}
