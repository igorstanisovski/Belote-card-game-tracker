import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'player.dart';

class PlayerStatistics extends StatefulWidget {
  final String documentID;
  const PlayerStatistics(this.documentID);
  @override
  _PlayerStatisticsState createState() => _PlayerStatisticsState();
}

class _PlayerStatisticsState extends State<PlayerStatistics> {
  final firestoreInstance = Firestore.instance;
  var players = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Статистика"),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('users').document(widget.documentID).collection("players").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return new Text("There is no players");
              return new ListView(children: getExpenseItems(snapshot));
            })
    );
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((doc) => new CustomListItem(
      playerName: doc['name'],
      roundsTaken: doc['taken'].toInt(),
      roundsThrown: doc['thrown'].toInt(),
      playerID: doc.documentID,
      wins: doc['wins'].toInt(),
      losses: doc['losses'].toInt()
    ))
        .toList();
  }
}

class CustomListItem extends StatelessWidget {
  final String playerName;
  final int roundsTaken, roundsThrown, wins ,losses;
  final String playerID;

  const CustomListItem(
      {this.playerName,
      this.roundsTaken,
      this.roundsThrown,
      this.playerID,
      this.wins,
      this.losses});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade300,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Player(this.playerID,this.playerName,this.wins,this.losses,this.roundsTaken,this.roundsThrown)));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(this.playerName, style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),)
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text('Земени: ' + roundsTaken.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      Text('Шитнати: ' + roundsThrown.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
                    ],
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}