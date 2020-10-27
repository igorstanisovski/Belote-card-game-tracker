import 'game_started.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  final String documentID;
  const History(this.documentID);
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Историја на партии"),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('users').document(widget.documentID).collection("games").orderBy('date',descending: true).snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return new Text("There is no games");
              return new ListView(children: getExpenseItems(snapshot));
            })
    );
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((doc) => new CustomListItem(
              player1: doc["playerOne"],
              player2: doc["playerTwo"],
              player3: doc["playerThree"],
              player4: doc["playerFour"],
              maxScore: doc["maxScore"],
              documentID: widget.documentID,
              teamOneWins: doc["teamOneWins"],
              teamTwoWins: doc["teamTwoWins"],
              teamOneRim: doc["teamOneRim"],
              teamTwoRim: doc["teamTwoRim"],
              miniGames: doc["miniGames"],
              dealer: doc["dealer"],
              typeOfGame: doc["typeOfGame"],
              savePreviousWinsTeamOne: doc['savePreviousWinsTeamOne'],
              savePreviousWinsTeamTwo: doc['savePreviousWinsTeamTwo'],
              gameID: doc.documentID
            ))
        .toList();
  }
}

class CustomListItem extends StatelessWidget {
  final String player1, player2, player3, player4;
  final num maxScore;
  final DateTime date;
  final String documentID;
  final String gameID;
  final int teamOneWins,teamTwoWins;
  final int teamOneRim,teamTwoRim;
  final String typeOfGame;
  final List miniGames;
  final int dealer;
  final int savePreviousWinsTeamOne, savePreviousWinsTeamTwo;

  const CustomListItem(
      {this.player1,
      this.player2,
      this.player3,
      this.player4,
      this.maxScore,
      this.date,
      this.documentID,
      this.teamOneWins,
      this.teamTwoWins,
      this.teamOneRim,
      this.teamTwoRim,
      this.typeOfGame,
      this.miniGames,
      this.dealer,
      this.savePreviousWinsTeamOne,
      this.savePreviousWinsTeamTwo,
      this.gameID});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade300,
      ),
      child: Container(
        child: InkWell(
          onTap: () => {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => GameStarted(documentID,player1,player2,player3,player4, maxScore,gameID,typeOfGame,true
            )))
          },
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  color: Colors.red.shade900,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Тип на игра - ' + typeOfGame, style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                  ],
                ),
              ),
              typeOfGame == 'Една партија'? Text('Резултатот е изразен во поени') : Row(),
              typeOfGame == 'Едно римско'? Text('Резултатот е изразен во добиени мали партии') : Row(),
              typeOfGame == 'Две римски'? Text('Резултатот е изразен во добиени римски') : Row(),
              typeOfGame == 'Три римски'? Text('Резултатот е изразен во добиени римски'): Row(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            player1,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                          typeOfGame == 'Една партија'?
                            Text(
                            miniGames.elementAt(0)['teamOneScore'].toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 37),) : Row(),
                          typeOfGame == 'Едно римско'? Text(
                            teamOneWins.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 37),) : Row(),
                          typeOfGame == 'Две римски'? Text(
                            teamOneRim.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 37),) : Row(),
                          typeOfGame == 'Три римски'? Text(
                            teamOneRim.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 37),): Row(),
                          Text(
                            player2,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      )),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          player3,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                        typeOfGame == 'Една партија'?
                        Text(
                          miniGames.elementAt(0)['teamTwoScore'].toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 37),) : Row(),
                        typeOfGame == 'Едно римско'? Text(
                          teamTwoWins.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 37),) : Row(),
                        typeOfGame == 'Две римски'? Text(
                          teamTwoRim.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 37),) : Row(),
                        typeOfGame == 'Три римски'? Text(
                          teamTwoRim.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 37),): Row(),
                        Text(
                          player4,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          )
        ),
      ),
    );
  }
}
