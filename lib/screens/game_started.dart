import 'dart:convert';
import 'minigames.dart';
import 'new_round.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numerus/numerus.dart';

String globalGameID;

void updateTeamOneWins(String player1, String player2, String player3, String player4, String documentID) async {
  final documents1 = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: player1).getDocuments();
  final player1ID = documents1.documents.first.documentID;
  Firestore.instance.collection('users').document(documentID).collection("players").document(player1ID).updateData({
    "wins": FieldValue.increment(-1),
  });
  final documents2 = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: player2).getDocuments();
  final player2ID = documents2.documents.first.documentID;
  Firestore.instance.collection('users').document(documentID).collection("players").document(player2ID).updateData({
    "wins": FieldValue.increment(-1),
  });
  final documents3 = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: player3).getDocuments();
  final player3ID = documents3.documents.first.documentID;
  Firestore.instance.collection('users').document(documentID).collection("players").document(player3ID).updateData({
    "losses": FieldValue.increment(-1),
  });
  final documents4 = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: player4).getDocuments();
  final player4ID = documents4.documents.first.documentID;
  Firestore.instance.collection('users').document(documentID).collection("players").document(player4ID).updateData({
    "losses": FieldValue.increment(-1),
  });
}

void updateTeamTwoWins(String player1, String player2, String player3, String player4, String documentID) async {
  final documents1 = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: player1).getDocuments();
  final player1ID = documents1.documents.first.documentID;
  Firestore.instance.collection('users').document(documentID).collection("players").document(player1ID).updateData({
    "losses": FieldValue.increment(-1),
  });
  final documents2 = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: player2).getDocuments();
  final player2ID = documents2.documents.first.documentID;
  Firestore.instance.collection('users').document(documentID).collection("players").document(player2ID).updateData({
    "losses": FieldValue.increment(-1),
  });
  final documents3 = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: player3).getDocuments();
  final player3ID = documents3.documents.first.documentID;
  Firestore.instance.collection('users').document(documentID).collection("players").document(player3ID).updateData({
    "wins": FieldValue.increment(-1),
  });
  final documents4 = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: player4).getDocuments();
  final player4ID = documents4.documents.first.documentID;
  Firestore.instance.collection('users').document(documentID).collection("players").document(player4ID).updateData({
    "wins": FieldValue.increment(-1),
  });
}

void updateGame(var miniGames, var miniGamesId,var rounds,var team1Score, var team2Score, var gameID,
    var player1, var player2, var player3, var player4, var maxPoints, var matches, var teamOneWins, var teamTwoWins,
    var teamOneRim,var teamTwoRim, var dealer, var savePreviousWinsTeamOne, var savePreviousWinsTeamTwo, var documentID) async {
  if(miniGames.length == 0){
    var tempOutput = new List.from(miniGames);
    tempOutput.add({
      'id': miniGamesId,
      'rounds' : rounds,
      'teamOneScore': team1Score,
      'teamTwoScore': team2Score
    });
    miniGames = new List.from(tempOutput);
  }
  else {
    for (int i = 0; i < miniGames.length; i++) {
      if(miniGames[i]['id'] == miniGamesId){
        miniGames[i]['rounds'] = rounds;
        miniGames[i]['teamOneScore'] = team1Score;
        miniGames[i]['teamTwoScore'] = team2Score;
        break;
      }
      if(i == miniGames.length - 1){
        var tempOutput = new List.from(miniGames);
        tempOutput.add({
          'id': miniGamesId,
          'rounds' : rounds,
          'teamOneScore': team1Score,
          'teamTwoScore': team2Score
        });
        miniGames = new List.from(tempOutput);
      }
    }
  }
  if(gameID == null){
    await Firestore.instance.collection('users').document(documentID).collection("games").add({
      'playerOne': player1,
      'playerTwo': player2,
      'playerThree': player3,
      'playerFour': player4,
      'miniGames': miniGames,
      'maxScore': maxPoints,
      'date': DateTime.now(),
      'typeOfGame': matches,
      'teamOneWins': teamOneWins,
      'teamTwoWins': teamTwoWins,
      'teamOneRim': teamOneRim,
      'teamTwoRim': teamTwoRim,
      'dealer': dealer,
      'savePreviousWinsTeamOne': savePreviousWinsTeamOne,
      'savePreviousWinsTeamTwo': savePreviousWinsTeamTwo
    }).then((value) => globalGameID=value.documentID);
  }
  else {
    await Firestore.instance.collection('users').document(documentID).collection("games").document(gameID).updateData({
      'miniGames': miniGames,
      'date': DateTime.now(),
      'teamOneWins': teamOneWins,
      'teamTwoWins': teamTwoWins,
      'teamOneRim': teamOneRim,
      'teamTwoRim': teamTwoRim,
      'savePreviousWinsTeamOne': savePreviousWinsTeamOne,
      'savePreviousWinsTeamTwo': savePreviousWinsTeamTwo,
      'dealer': dealer,
    });
  }
}

class GameStarted extends StatefulWidget {
  final String documentID;
  final String player1, player2, player3, player4;
  final num maxPoints;
  final String gameID;
  final String matches;
  final bool newGame;
  const GameStarted(
      this.documentID,this.player1, this.player2, this.player3, this.player4, this.maxPoints, this.gameID,this.matches,this.newGame);

  @override
  _GameStartedState createState() => _GameStartedState();
}

class _GameStartedState extends State<GameStarted> {
  num team1Score = 0;
  num team2Score = 0;
  int teamOneRim = 0;
  int teamTwoRim= 0;
  int teamOneWins = 0;
  int teamTwoWins = 0;
  int savePreviousWinsTeamOne = 0;
  int savePreviousWinsTeamTwo = 0;
  var rounds = [];
  var miniGamesId = 0;
  var miniGames = [];
  int dealer = 1;
  final firestoreInstance = Firestore.instance;
  bool fabVisible = true;
  var playerOne,playerTwo,playerThree,playerFour;
  @override
  void initState() {
    firestoreInstance.collection('users').document(widget.documentID).collection('players').where('name', isEqualTo: widget.player1).getDocuments().then((doc) => {
      if(doc.documents.isEmpty){
        playerOne = {
          'name': widget.player1,
          'taken': 0,
          'thrown': 0,
          'wins': 0,
          'losses': 0
        },
        firestoreInstance.collection('users').document(widget.documentID).collection('players').add(playerOne)
      }
      else {
        playerOne = doc.documents.elementAt(0).data,
      }
    });
    firestoreInstance.collection('users').document(widget.documentID).collection('players').where('name', isEqualTo: widget.player2).getDocuments().then((doc) => {
      if(doc.documents.isEmpty){
        playerTwo = {
          'name': widget.player2,
          'taken': 0,
          'thrown': 0,
          'wins': 0,
          'losses': 0
        },
        firestoreInstance.collection('users').document(widget.documentID).collection('players').add(playerTwo)
      }
      else {
        playerTwo = doc.documents.elementAt(0).data,
      }
    });
    firestoreInstance.collection('users').document(widget.documentID).collection('players').where('name', isEqualTo: widget.player3).getDocuments().then((doc) => {
      if(doc.documents.isEmpty){
        playerThree = {
          'name': widget.player3,
          'taken': 0,
          'thrown': 0,
          'wins': 0,
          'losses': 0
        },
        firestoreInstance.collection('users').document(widget.documentID).collection('players').add(playerThree)
      }
      else {
        playerThree = doc.documents.elementAt(0).data,
      }
    });
    firestoreInstance.collection('users').document(widget.documentID).collection('players').where('name', isEqualTo: widget.player4).getDocuments().then((doc) => {
      if(doc.documents.isEmpty){
        playerFour = {
          'name': widget.player4,
          'taken': 0,
          'thrown': 0,
          'wins': 0,
          'losses': 0
        },
        firestoreInstance.collection('users').document(widget.documentID).collection('players').add(playerFour)
      }
      else {
        playerFour = doc.documents.elementAt(0).data,
      }
    });

    if(widget.gameID != null){
      firestoreInstance.collection('users').document(widget.documentID).collection("games").document(widget.gameID).get().then((doc) => {
        setState(() {
            dealer = doc['dealer'];
            miniGames = doc['miniGames'];
            teamOneWins = doc['teamOneWins'];
            teamTwoWins = doc['teamTwoWins'];
            teamOneRim = doc['teamOneRim'];
            teamTwoRim = doc['teamTwoRim'];
            savePreviousWinsTeamOne = doc['savePreviousWinsTeamOne'];
            savePreviousWinsTeamTwo = doc['savePreviousWinsTeamTwo'];
            if(widget.newGame){
              miniGamesId = miniGames[miniGames.length - 1]['id'];
              team1Score = miniGames[miniGames.length - 1]['teamOneScore'];
              team2Score = miniGames[miniGames.length - 1]['teamTwoScore'];
              rounds = miniGames[miniGames.length - 1]['rounds'];
              if(team1Score >= widget.maxPoints || team2Score >= widget.maxPoints){
                fabVisible = false;
              }
            }
            else {
              miniGamesId = miniGames[miniGames.length - 1]['id'] + 1;
              team1Score = 0;
              team2Score = 0;
              rounds = [];
            }

        })
      });
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                title: Text(
                  'Предупредување',
                  textAlign: TextAlign.center,
                ),
                content:  Text(
                  'Дали сакаш да излезиш?',
                  textAlign: TextAlign.center,
                ) ,
                actions: [
                  FlatButton(
                      child:  Text('Да'),
                      onPressed: ()  {
                        updateGame(miniGames, miniGamesId, rounds, team1Score, team2Score, widget.gameID, widget.player1, widget.player2, widget.player3, widget.player4,
                            widget.maxPoints, widget.matches, teamOneWins, teamTwoWins, teamOneRim, teamTwoRim, dealer, savePreviousWinsTeamOne,
                            savePreviousWinsTeamTwo, widget.documentID);
                        Navigator.of(context).popUntil((route) =>
                          route.isFirst);
                        Navigator.of(c).pop();
                  }),
                  FlatButton(
                    child:  Text('Не'),
                    onPressed: () => {
                      Navigator.pop(c, false),
                    },
                  ),
                ],
              ),
            ),
        child: Scaffold(
          appBar: new AppBar(
            title: Text('Игра - ' + widget.matches),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.lightbulb_outline,
                  color: Colors.white,
                ),
                onPressed: () {
                  showDialog(context: context, builder: (BuildContext c) => new AlertDialog(
                    title:  Text('Резултат', textAlign: TextAlign.center,),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        (widget.matches == 'Две римски' || widget.matches == 'Три римски' || widget.matches == 'Едно римско')?
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text('Тим 1', style: TextStyle(fontWeight: FontWeight.bold),),
                                    Text('Мали партии', style: TextStyle(fontSize: 12.0),),
                                    Text(teamOneWins.toString()),
                                    Text('Римски', style: TextStyle(fontSize: 12.0),),
                                    Text(teamOneRim.toRomanNumeralString().toString()),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Тим 2', style: TextStyle(fontWeight: FontWeight.bold),),
                                    Text('Мали партии', style: TextStyle(fontSize: 12.0),),
                                    Text(teamTwoWins.toString()),
                                    Text('Римски', style: TextStyle(fontSize: 12.0),),
                                    Text(teamTwoRim.toRomanNumeralString().toString()),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FlatButton(
                                  child:  Text('Види ги партиите', style: TextStyle(color: Colors.blue),),
                                  onPressed: () => {
                                    widget.gameID != null ?{ Navigator.push(context, MaterialPageRoute(builder: (c) => MiniGames(widget.gameID,widget.documentID))),
                                  Navigator.of(c).pop() } : null,

                                  },
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                (((widget.matches == 'Едно римско') && (teamOneRim + teamTwoRim) < 1 && (team1Score>=widget.maxPoints || team2Score>=widget.maxPoints))
                                    || ((widget.matches == 'Две римски') && (teamOneRim < 2 &&  teamTwoRim < 2) && (team1Score>=widget.maxPoints || team2Score>=widget.maxPoints))
                                    || ((widget.matches == 'Три римски') && (teamOneRim < 3 && teamTwoRim < 2)  && (team1Score>=widget.maxPoints || team2Score>=widget.maxPoints)))?
                                FlatButton(child: Text('Нова партија', style: TextStyle(color: Colors.blue),), onPressed: () {
                                  startNewGame();
                                  Navigator.pop(c);
                                },) : Column(),
                              ],
                            )
                          ],
                        ):
                        Row(),
                      ],
                    ),
                  ));
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.casino,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    this.dealer++;
                    if(this.dealer >= 5){
                      this.dealer = 1;
                    }
                  });
                },
              ),
            ],
          ),
          body: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 20, top: 20),
                      color: Colors.lightBlueAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          //ovde
                          Column(
                            children: <Widget>[
                              Row(children: <Widget>[
                                Text(
                                  widget.player1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 25),
                                ),
                                this.dealer == 1? Icon(
                                    Icons.casino
                                ) : Text(' '),
                              ],),
                              Text(
                                team1Score.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 45),
                              ),
                              Row(children: <Widget>[
                                Text(
                                  widget.player2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 25),
                                ),
                                this.dealer == 2? Icon(
                                    Icons.casino
                                ) : Text(' '),
                              ],),
                            ],
                          ),
                          //ovde
                          Column(
                            children: <Widget>[
                              Row(children: <Widget>[
                                Text(
                                  widget.player3,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 25),
                                ),
                                this.dealer == 3? Icon(
                                    Icons.casino
                                ) : Text(' '),
                              ],),
                              Text(
                                team2Score.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 45),
                              ),
                              Row(children: <Widget>[
                                Text(
                                  widget.player4,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 25),
                                ),
                                this.dealer == 4? Icon(
                                    Icons.casino
                                ) : Text(' '),
                              ],),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: new Flexible(
                        child: ListView.builder(
                          itemCount: rounds.length,
                            itemBuilder: (BuildContext context, int index) {
                              return new Container(
                                  margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                                  height: 80,
                                  decoration: new BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius:new BorderRadius.circular(4)
                                  ),
                                  child: new InkWell(
                                    onTap: () {
                                      showDialog(context: context, builder: (BuildContext c) => new AlertDialog(
                                        title:  Text('Рунда ' + (index+1).toString(), textAlign: TextAlign.center,),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                FlatButton(
                                                  child:  Text('Избриши', style: TextStyle(color: Colors.blue),) ,
                                                  onPressed: () {
                                                    setState(() {
                                                      if(team1Score >= widget.maxPoints && team1Score > team2Score){
                                                        fabVisible = true;
                                                        if(teamOneWins == 0 && teamTwoWins== 0){
                                                          teamOneRim--;
                                                          teamOneWins = savePreviousWinsTeamOne - 1;
                                                          teamTwoWins = savePreviousWinsTeamTwo;
                                                        }
                                                        else {
                                                          teamOneWins--;
                                                        }
                                                      }
                                                      if(team2Score >= widget.maxPoints && team2Score > team1Score){
                                                        fabVisible = true;
                                                        if(teamOneWins == 0 && teamTwoWins== 0){
                                                          teamTwoRim--;
                                                          teamOneWins = savePreviousWinsTeamOne;
                                                          teamTwoWins = savePreviousWinsTeamTwo - 1;
                                                        }
                                                        else {
                                                          teamTwoWins--;
                                                        }
                                                      }
                                                      team1Score -= rounds.elementAt(index)['teamOneTotalPoints'];
                                                      team2Score -= rounds.elementAt(index)['teamTwoTotalPoints'];
                                                      rounds.removeAt(index);
                                                      //Navigator.pop(context,true);
                                                      Navigator.pop(c);
                                                    });
                                                  },
                                                ),
                                                FlatButton(
                                                  child:  Text('Уреди',style: TextStyle(color: Colors.blue)) ,
                                                  onPressed: () async {
                                                    Navigator.of(c, rootNavigator: true).pop('dialog');
                                                    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => NewRound(widget.documentID,widget.player1,widget.player2,widget.player3,widget.player4,
                                                        rounds.elementAt(index)['teamOnePoints'],rounds.elementAt(index)['teamTwoPoints'],
                                                        rounds.elementAt(index)['playerWhoTook'],rounds.elementAt(index)['teamOneDeclarations'],rounds.elementAt(index)['teamTwoDeclarations'],
                                                        rounds.elementAt(index)['BR'],rounds.elementAt(index)['capot'],
                                                        rounds.elementAt(index)['teamOne20Declaration'],rounds.elementAt(index)['teamOne50Declaration'],rounds.elementAt(index)['teamOne100Declaration'],
                                                        rounds.elementAt(index)['teamOne150Declaration'],rounds.elementAt(index)['teamOne200Declaration'],
                                                        rounds.elementAt(index)['teamTwo20Declaration'],rounds.elementAt(index)['teamTwo50Declaration'],rounds.elementAt(index)['teamTwo100Declaration'],
                                                        rounds.elementAt(index)['teamTwo150Declaration'],rounds.elementAt(index)['teamTwo200Declaration'],
                                                        rounds.elementAt(index)['teamOneTotalPoints'],rounds.elementAt(index)['teamTwoTotalPoints'])));
                                                    setState(() {
                                                      if(result != null) {
                                                        if(this.team1Score >= widget.maxPoints && this.team1Score > this.team2Score){
                                                          updateTeamOneWins(widget.player1, widget.player2, widget.player3, widget.player4, widget.documentID);
                                                        }
                                                        else if(this.team2Score >= widget.maxPoints && this.team2Score > this.team1Score){
                                                          updateTeamTwoWins(widget.player1, widget.player2, widget.player3, widget.player4, widget.documentID);
                                                        }
                                                        Map<String, dynamic> res = jsonDecode(result);
                                                        team1Score -= rounds.elementAt(index)['teamOneTotalPoints'];
                                                        team2Score -= rounds.elementAt(index)['teamTwoTotalPoints'];
                                                        var temp = new List.from(rounds);
                                                        temp.removeAt(index);
                                                        temp.insert(index, res);
                                                        rounds = new List.from(temp);
                                                        team1Score += rounds.elementAt(index)['teamOneTotalPoints'];
                                                        team2Score += rounds.elementAt(index)['teamTwoTotalPoints'];
                                                        endOfGameAlerts();
                                                      }
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ));
                                    },
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            rounds.elementAt(index)['teamOneTotalPoints'].toString(),
                                            textAlign: TextAlign.end,
                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                        ),
                                        Expanded(
                                          child: Text((index+1).toString(),textAlign: TextAlign.center,),
                                        ),
                                        Expanded(
                                          child: Text(
                                            rounds.elementAt(index)['teamTwoTotalPoints'].toString(),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                        )
                                      ],
                                    ),
                                  )
                              );
                            }
                      ),
                      ),
                    ),
                  ],
                ),
          ),
          floatingActionButton: Visibility(
            visible: fabVisible,
            child: new FloatingActionButton(
              onPressed: ()  {
                _waitForResult(context);
              },
              backgroundColor: Colors.green,
              child: Icon(Icons.library_add),
            ),
          )
        ));
  }
  void _waitForResult(BuildContext context) async{
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => NewRound(widget.documentID,widget.player1,widget.player2,widget.player3,widget.player4,
        0,0,'',0,0,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0)));

    setState(() {
      if(result != null){
        Map<String, dynamic> res = jsonDecode(result);
        team1Score += res['teamOneTotalPoints'];
        team2Score += res['teamTwoTotalPoints'];
        var tempOutput = new List.from(rounds);
        tempOutput.add(res);
        rounds = new List.from(tempOutput);
        dealer++;
        endOfGameAlerts();
      }
    });
  }

  void updatePlayers(String userID, String player1, String player2 , String player3, String player4) async {
    final documents1 = await Firestore.instance.collection('users').document(userID).collection('players').where("name", isEqualTo: player1).getDocuments();
    final player1ID = documents1.documents.first.documentID;
    Firestore.instance.collection('users').document(userID).collection("players").document(player1ID).updateData({
      "wins": FieldValue.increment(1),
    });

    final documents2 = await Firestore.instance.collection('users').document(userID).collection('players').where("name", isEqualTo: player2).getDocuments();
    final player2ID = documents2.documents.first.documentID;

    Firestore.instance.collection('users').document(userID).collection("players").document(player2ID).updateData({
      "wins": FieldValue.increment(1),
    });

    final documents3 = await Firestore.instance.collection('users').document(userID).collection('players').where("name", isEqualTo: player3).getDocuments();
    final player3ID = documents3.documents.first.documentID;

    Firestore.instance.collection('users').document(userID).collection("players").document(player3ID).updateData({
      "losses": FieldValue.increment(1),
    });

    final documents4 = await Firestore.instance.collection('users').document(userID).collection('players').where("name", isEqualTo: player4).getDocuments();
    final player4ID = documents4.documents.first.documentID;

    Firestore.instance.collection('users').document(userID).collection("players").document(player4ID).updateData({
      "losses": FieldValue.increment(1),
    });


  }

  void endOfGameAlerts() {
    fabVisible = true;
    if(team1Score >= widget.maxPoints && team2Score >= widget.maxPoints){
      if(team1Score > team2Score){
        setState(() {
          this.teamOneWins = this.teamOneWins + 1;
          if(this.teamOneWins == 2){
            this.teamOneRim++;
            this.savePreviousWinsTeamOne = this.teamOneWins;
            this.savePreviousWinsTeamTwo = this.teamTwoWins;
            this.teamOneWins = 0;
            this.teamTwoWins = 0;
          }
          updatePlayers(widget.documentID, widget.player1, widget.player2, widget.player3, widget.player4);
        });
        showDialog(context: context,builder: (BuildContext c) => new AlertDialog(
            title: Text('Победи Тим 1!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                (widget.matches == 'Две римски' || widget.matches == 'Три римски' || widget.matches == 'Едно римско')?
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text('Тим 1', style: TextStyle(fontWeight: FontWeight.bold),),
                            Text('Мали партии', style: TextStyle(fontSize: 12.0),),
                            Text(teamOneWins.toString()),
                            Text('Римски', style: TextStyle(fontSize: 12.0),),
                            Text(teamOneRim.toRomanNumeralString().toString()),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Тим 2', style: TextStyle(fontWeight: FontWeight.bold),),
                            Text('Мали партии', style: TextStyle(fontSize: 12.0),),
                            Text(teamTwoWins.toString()),
                            Text('Римски', style: TextStyle(fontSize: 12.0),),
                            Text(teamTwoRim.toRomanNumeralString().toString()),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        (((widget.matches == 'Едно римско') && (teamOneRim + teamTwoRim) < 1 && (team1Score>=widget.maxPoints || team2Score>=widget.maxPoints))
                            || ((widget.matches == 'Две римски') && (teamOneRim < 2 &&  teamTwoRim < 2) && (team1Score>=widget.maxPoints || team2Score>=widget.maxPoints))
                            || ((widget.matches == 'Три римски') && (teamOneRim < 3 && teamTwoRim < 2)  && (team1Score>=widget.maxPoints || team2Score>=widget.maxPoints)))?
                        FlatButton(child: Text('Нова партија', style: TextStyle(color: Colors.blue),), onPressed: () { startNewGame(); Navigator.of(c).pop(); },) : Column(),
                      ],
                    )
                  ],
                ):
                Row(),
              ],
            )

        ));
        fabVisible = false;
      }
      else if(team2Score > team1Score){
        setState(() {
          this.teamTwoWins++;
          if(this.teamTwoWins == 2){
            this.teamTwoRim++;
            this.savePreviousWinsTeamOne = this.teamOneWins;
            this.savePreviousWinsTeamTwo = this.teamTwoWins;
            this.teamOneWins = 0;
            this.teamTwoWins = 0;
          }
          updatePlayers(widget.documentID, widget.player4, widget.player3, widget.player1, widget.player2);
        });
        showDialog(context: context,builder: (BuildContext c) => new AlertDialog(
            title:  Text('Победи Тим 2!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                (widget.matches == 'Две римски' || widget.matches == 'Три римски' || widget.matches == 'Едно римско')?
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text('Тим 1', style: TextStyle(fontWeight: FontWeight.bold),) ,
                            Text('Мали партии', style: TextStyle(fontSize: 12.0),),
                            Text(teamOneWins.toString()),
                            Text('Римски', style: TextStyle(fontSize: 12.0),),
                            Text(teamOneRim.toRomanNumeralString().toString()),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Тим 2', style: TextStyle(fontWeight: FontWeight.bold),),
                            Text('Мали партии', style: TextStyle(fontSize: 12.0),),
                            Text(teamTwoWins.toString()),
                            Text('Римски', style: TextStyle(fontSize: 12.0),),
                            Text(teamTwoRim.toRomanNumeralString().toString()),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        (((widget.matches == 'Едно римско') && (teamOneRim + teamTwoRim) < 1 && (team1Score>=widget.maxPoints || team2Score>=widget.maxPoints))
                            || ((widget.matches == 'Две римски') && (teamOneRim < 2 &&  teamTwoRim < 2) && (team1Score>=widget.maxPoints || team2Score>=widget.maxPoints))
                            || ((widget.matches == 'Три римски') && (teamOneRim < 3 && teamTwoRim < 2)  && (team1Score>=widget.maxPoints || team2Score>=widget.maxPoints)))?
                        FlatButton(child:  Text('Нова партија', style: TextStyle(color: Colors.blue),), onPressed:() { startNewGame(); Navigator.of(c).pop(); } ) : Column(),
                      ],
                    )
                  ],
                ):
                Row(),
              ],
            )

        ));
        fabVisible = false;
      }
      else {
        AlertDialog alert = new AlertDialog(
          title: Text('Решавачка рунда!'),
        );
        showDialog(context: context,builder: (BuildContext c) => alert);
        fabVisible = false;
      }
    }
    else if(team1Score >= widget.maxPoints){
      setState(() {
        this.teamOneWins = this.teamOneWins + 1;
        if(this.teamOneWins == 2){
          this.teamOneRim++;
          this.savePreviousWinsTeamOne = this.teamOneWins;
          this.savePreviousWinsTeamTwo = this.teamTwoWins;
          this.teamOneWins = 0;
          this.teamTwoWins = 0;
        }
        updatePlayers(widget.documentID, widget.player1, widget.player2, widget.player3, widget.player4);
      });
      showDialog(context: context,builder: (BuildContext c) => new AlertDialog(
          title:  Text('Победи Тим 1!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              (widget.matches == 'Две римски' || widget.matches == 'Три римски' || widget.matches == 'Едно римско')?
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text('Тим 1', style: TextStyle(fontWeight: FontWeight.bold),) ,
                          Text('Мали партии', style: TextStyle(fontSize: 12.0),),
                          Text(teamOneWins.toString()),
                          Text('Римски', style: TextStyle(fontSize: 12.0),),
                          Text(teamOneRim.toRomanNumeralString().toString()),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Тим 2', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('Мали партии', style: TextStyle(fontSize: 12.0),),
                          Text(teamTwoWins.toString()),
                          Text('Римски', style: TextStyle(fontSize: 12.0),),
                          Text(teamTwoRim.toRomanNumeralString().toString()),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      (((widget.matches == 'Едно римско') && (teamOneRim + teamTwoRim) < 1 && (team1Score>=widget.maxPoints || team2Score>=widget.maxPoints))
                          || ((widget.matches == 'Две римски') && (teamOneRim < 2 &&  teamTwoRim < 2) && (team1Score>=widget.maxPoints || team2Score>=widget.maxPoints))
                          || ((widget.matches == 'Три римски') && (teamOneRim < 3 && teamTwoRim < 2)  && (team1Score>=widget.maxPoints || team2Score>=widget.maxPoints)))?
                      FlatButton(child: Text('Нова партија', style: TextStyle(color: Colors.blue),), onPressed: () { startNewGame(); Navigator.of(c).pop(); },) : Column(),
                    ],
                  )
                ],
              ):
              Row(),
            ],
          )

      ));
      fabVisible = false;
    }
    else if(team2Score >= widget.maxPoints){
      setState(() {
        this.teamTwoWins++;
        if(this.teamTwoWins == 2){
          this.teamTwoRim++;
          this.savePreviousWinsTeamOne = this.teamOneWins;
          this.savePreviousWinsTeamTwo = this.teamTwoWins;
          this.teamOneWins = 0;
          this.teamTwoWins = 0;
        }
        updatePlayers(widget.documentID, widget.player4, widget.player3, widget.player2, widget.player1);
      });
      showDialog(context: context,builder: (BuildContext c) => new AlertDialog(
          title: Text('Победи Тим 2!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              (widget.matches == 'Две римски' || widget.matches == 'Три римски' || widget.matches == 'Едно римско')?
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text('Тим 1', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('Мали партии', style: TextStyle(fontSize: 12.0),),
                          Text(teamOneWins.toString()),
                          Text('Римски', style: TextStyle(fontSize: 12.0),),
                          Text(teamOneRim.toRomanNumeralString().toString()),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Тим 2', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('Мали партии', style: TextStyle(fontSize: 12.0),),
                          Text(teamTwoWins.toString()),
                          Text('Римски', style: TextStyle(fontSize: 12.0),),
                          Text(teamTwoRim.toRomanNumeralString().toString()),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      (((widget.matches == 'Едно римско') && (teamOneRim + teamTwoRim) < 1 && (team1Score>=widget.maxPoints || team2Score>=widget.maxPoints))
                          || ((widget.matches == 'Две римски') && (teamOneRim < 2 &&  teamTwoRim < 2) && (team1Score>=widget.maxPoints || team2Score>=widget.maxPoints))
                          || ((widget.matches == 'Три римски') && (teamOneRim < 3 && teamTwoRim < 2)  && (team1Score>=widget.maxPoints || team2Score>=widget.maxPoints)))?
                      FlatButton(child: Text('Нова партија', style: TextStyle(color: Colors.blue),), onPressed:() { startNewGame(); Navigator.of(c).pop(); },) : Column(),
                    ],
                  )
                ],
              ):
              Row(),
            ],
          )

      ));
      fabVisible = false;
    }
  }

  void startNewGame() async {
    var id = widget.gameID;
    if(miniGames.length != 0) {
      for(int i = 0; i < miniGames.length;i++){
        if(i == this.miniGamesId){
          miniGames[i]['rounds'] = this.rounds;
          miniGames[i]['teamOneScore'] = this.team1Score;
          miniGames[i]['teamTwoScore'] = this.team2Score;
          break;
        }
        if(i == miniGames.length - 1){
          var tempOutput = new List.from(miniGames);
          tempOutput.add({
            'id': this.miniGamesId,
            'rounds': this.rounds,
            'teamOneScore': this.team1Score,
            'teamTwoScore': this.team2Score
          });
          miniGames = new List.from(tempOutput);
        }
      }
    }
    else {
      var tempOutput = new List.from(miniGames);
      tempOutput.add({
        'id': this.miniGamesId,
        'rounds': this.rounds,
        'teamOneScore': this.team1Score,
        'teamTwoScore': this.team2Score
      });
      miniGames = new List.from(tempOutput);
    }


    if(widget.gameID == null){
      DocumentReference doc = await firestoreInstance.collection('users').document(widget.documentID).collection("games").add({
        'playerOne': widget.player1,
        'playerTwo': widget.player2,
        'playerThree': widget.player3,
        'playerFour': widget.player4,
        'miniGames': this.miniGames,
        'maxScore': widget.maxPoints,
        'date': DateTime.now(),
        'typeOfGame': widget.matches,
        'teamOneWins': this.teamOneWins,
        'teamTwoWins': this.teamTwoWins,
        'teamOneRim': this.teamOneRim,
        'teamTwoRim': this.teamTwoRim,
        'dealer': this.dealer,
      });
      if(id == null) {
        id = doc.documentID;
      }
    }
    firestoreInstance.collection('users').document(widget.documentID).collection("games").document(id).updateData({
      'teamOneWins': this.teamOneWins,
      'teamTwoWins': this.teamTwoWins,
      'teamOneRim': this.teamOneRim,
      'teamTwoRim': this.teamTwoRim,
      'miniGames': this.miniGames,
      'date': DateTime.now(),
    });


    Navigator.push(context, MaterialPageRoute(builder: (context) =>
        GameStarted(
            widget.documentID,
            widget.player1,
            widget.player2,
            widget.player3,
            widget.player4,
            widget.maxPoints,
            id,
            widget.matches,
            false
        )));
  }
}
