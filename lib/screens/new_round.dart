import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateUser (name , player1,player2,player3,player4 , teamOneTotalPoints, teamTwoTotalPoints, documentID, playerWhoTookPrev,
    int teamOneTotalPointsPrevious, int teamTwoTotalPointsPrevious) async {
  String oldPlayer = '';
  if(playerWhoTookPrev=='player0'){
    oldPlayer = player1;
  }
  else if(playerWhoTookPrev=='player1'){
    oldPlayer = player2;
  }
  else if(playerWhoTookPrev=='player2'){
    oldPlayer = player3;
  }
  else if(playerWhoTookPrev=='player3'){
    oldPlayer = player4;
  }
  if(oldPlayer.isEmpty){
    final documents = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: name).getDocuments();
    final player = documents.documents.first.data;
    final id = documents.documents.first.documentID;
    if(player['name'] == player1 || player['name'] == player2){
      if(teamOneTotalPoints < teamTwoTotalPoints){
        Firestore.instance.collection('users').document(documentID).collection("players").document(id).updateData({
          "taken": FieldValue.increment(1),
          "thrown": FieldValue.increment(1)
        });
      }
      else {
        Firestore.instance.collection('users').document(documentID).collection("players").document(id).updateData({
          "taken": FieldValue.increment(1),
        });
      }
    }
    if(player['name'] == player3 || player['name'] == player4){
      if(teamOneTotalPoints > teamTwoTotalPoints){
        Firestore.instance.collection('users').document(documentID).collection("players").document(id).updateData({
          "taken": FieldValue.increment(1),
          "thrown": FieldValue.increment(1)
        });
      }
      else {
        Firestore.instance.collection('users').document(documentID).collection("players").document(id).updateData({
          "taken": FieldValue.increment(1.0),
        });
      }
    }
  }
  else if(oldPlayer == name){
    final documents = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: oldPlayer).getDocuments();
    final id = documents.documents.first.documentID;
    if((teamOneTotalPoints > teamTwoTotalPoints) && (teamOneTotalPointsPrevious < teamTwoTotalPointsPrevious)) {
      if(playerWhoTookPrev == 'player0' || playerWhoTookPrev =='player1'){
        //prethodnata ja shitna, ova ja izvade
        Firestore.instance.collection('users').document(documentID).collection("players").document(id).updateData({
          "thrown": FieldValue.increment(-1)
        });
      }
      else if(playerWhoTookPrev =='player2' || playerWhoTookPrev=='player3'){
        //prethodnata ja izvade, ova ja shitna
        Firestore.instance.collection('users').document(documentID).collection("players").document(id).updateData({
          "thrown": FieldValue.increment(1)
        });
      }
    }
    else if((teamOneTotalPoints < teamTwoTotalPoints) && (teamOneTotalPointsPrevious > teamTwoTotalPointsPrevious)) {
      if(playerWhoTookPrev == 'player0' || playerWhoTookPrev =='player1'){
        //prethodnata ja izvade, ova ja shitna
        Firestore.instance.collection('users').document(documentID).collection("players").document(id).updateData({
          "thrown": FieldValue.increment(1)
        });
      }
      else if(playerWhoTookPrev =='player2' || playerWhoTookPrev=='player3'){
        //prethodnata ja shitna, ova ja izvade
        Firestore.instance.collection('users').document(documentID).collection("players").document(id).updateData({
          "thrown": FieldValue.increment(-1)
        });
      }
    }
  }
  else if(oldPlayer != name) {
    if((teamOneTotalPoints > teamTwoTotalPoints) && (teamOneTotalPointsPrevious > teamTwoTotalPointsPrevious)) {
      if(playerWhoTookPrev == 'player0' || playerWhoTookPrev == 'player1'){
        final documents = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: oldPlayer).getDocuments();
        final id = documents.documents.first.documentID;
        await Firestore.instance.collection('users').document(documentID).collection("players").document(id).updateData({
          "taken": FieldValue.increment(-1)
        });
        if(name == player1 || name==player2){
          final documents1 = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: name).getDocuments();
          final id1 = documents1.documents.first.documentID;
          await Firestore.instance.collection('users').document(documentID).collection("players").document(id1).updateData({
            "taken": FieldValue.increment(1)
          });
        }
        else {
          final documents1 = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: name).getDocuments();
          final id1 = documents1.documents.first.documentID;
          await Firestore.instance.collection('users').document(documentID).collection("players").document(id1).updateData({
            "taken": FieldValue.increment(1),
            "thrown": FieldValue.increment(1)
          });
        }
      }
      else if(playerWhoTookPrev == 'player2' || playerWhoTookPrev == 'player3'){
        final documents = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: oldPlayer).getDocuments();
        final id = documents.documents.first.documentID;
         await Firestore.instance.collection('users').document(documentID).collection("players").document(id).updateData({
          "taken": FieldValue.increment(-1),
          "thrown": FieldValue.increment(-1)
        });
       if(name== player1 || name==player2){
         final documents1 = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: name).getDocuments();
         final id1 = documents1.documents.first.documentID;
         await Firestore.instance.collection('users').document(documentID).collection("players").document(id1).updateData({
           "taken": FieldValue.increment(1),
         });
       }
       else {
         final documents1 = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: name).getDocuments();
         final id1 = documents1.documents.first.documentID;
         await Firestore.instance.collection('users').document(documentID).collection("players").document(id1).updateData({
           "taken": FieldValue.increment(1),
           "thrown": FieldValue.increment(1)
         });
       }
      }
    }
    else if((teamOneTotalPoints > teamTwoTotalPoints) && (teamOneTotalPointsPrevious < teamTwoTotalPointsPrevious)) {
      if(playerWhoTookPrev == 'player0' || playerWhoTookPrev=='player1'){
        final documents = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: oldPlayer).getDocuments();
        final id = documents.documents.first.documentID;
        await Firestore.instance.collection('users').document(documentID).collection("players").document(id).updateData({
          "taken": FieldValue.increment(-1),
          "thrown": FieldValue.increment(-1)
        });
        if(name == player1 || name == player2){
          final documents1 = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: name).getDocuments();
          final id1 = documents1.documents.first.documentID;
          await Firestore.instance.collection('users').document(documentID).collection("players").document(id1).updateData({
            "taken": FieldValue.increment(1),
          });
        }
        else {
          final documents1 = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: name).getDocuments();
          final id1 = documents1.documents.first.documentID;
          await Firestore.instance.collection('users').document(documentID).collection("players").document(id1).updateData({
            "taken": FieldValue.increment(1),
            "thrown": FieldValue.increment(1)
          });
        }

      }
      else {
        final documents = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: oldPlayer).getDocuments();
        final id = documents.documents.first.documentID;
        await Firestore.instance.collection('users').document(documentID).collection("players").document(id).updateData({
          "taken": FieldValue.increment(-1),
        });
        if(name == player1 || name==player2){
          final documents1 = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: name).getDocuments();
          final id1 = documents1.documents.first.documentID;
          await Firestore.instance.collection('users').document(documentID).collection("players").document(id1).updateData({
            "taken": FieldValue.increment(1),
          });
        }
        else {
          final documents1 = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: name).getDocuments();
          final id1 = documents1.documents.first.documentID;
          await Firestore.instance.collection('users').document(documentID).collection("players").document(id1).updateData({
            "taken": FieldValue.increment(1),
            "thrown": FieldValue.increment(1),
          });
        }
      }
    }
    else if((teamOneTotalPoints < teamTwoTotalPoints) && (teamOneTotalPointsPrevious < teamTwoTotalPointsPrevious)){
      if(playerWhoTookPrev == 'player0' || playerWhoTookPrev=='player1'){
        final documents = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: oldPlayer).getDocuments();
        final id = documents.documents.first.documentID;
        await Firestore.instance.collection('users').document(documentID).collection("players").document(id).updateData({
          "taken": FieldValue.increment(-1),
          "thrown": FieldValue.increment(-1)
        });
        if(name == player1 || name == player2){
          final documents = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: name).getDocuments();
          final id = documents.documents.first.documentID;
          await Firestore.instance.collection('users').document(documentID).collection("players").document(id).updateData({
            "taken": FieldValue.increment(1),
            "thrown": FieldValue.increment(1)
          });
        }
        else {
          final documents = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: name).getDocuments();
          final id = documents.documents.first.documentID;
          await Firestore.instance.collection('users').document(documentID).collection("players").document(id).updateData({
            "taken": FieldValue.increment(1),
          });
        }
      }
      else {
        final documents = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: oldPlayer).getDocuments();
        final id = documents.documents.first.documentID;
        await Firestore.instance.collection('users').document(documentID).collection("players").document(id).updateData({
          "taken": FieldValue.increment(-1),
        });
        if(name==player1 || name==player2){
          final documents = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: name).getDocuments();
          final id = documents.documents.first.documentID;
          await Firestore.instance.collection('users').document(documentID).collection("players").document(id).updateData({
            "taken": FieldValue.increment(1),
            "thrown": FieldValue.increment(1)
          });
        }
        else {
          final documents = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: name).getDocuments();
          final id = documents.documents.first.documentID;
          await Firestore.instance.collection('users').document(documentID).collection("players").document(id).updateData({
            "taken": FieldValue.increment(1),
          });
        }
      }
    }
    else if((teamOneTotalPoints < teamTwoTotalPoints) && (teamOneTotalPointsPrevious > teamTwoTotalPointsPrevious)) {
      if(playerWhoTookPrev == 'player0' || playerWhoTookPrev == 'player1'){
        final documents = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: oldPlayer).getDocuments();
        final id = documents.documents.first.documentID;
        await Firestore.instance.collection('users').document(documentID).collection("players").document(id).updateData({
          "taken": FieldValue.increment(-1),
        });
        if(name==player1 || name==player2){
          final documents = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: name).getDocuments();
          final id = documents.documents.first.documentID;
          await Firestore.instance.collection('users').document(documentID).collection("players").document(id).updateData({
            "taken": FieldValue.increment(1),
            "thrown": FieldValue.increment(1)
          });
        }
        else {
          final documents = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: name).getDocuments();
          final id = documents.documents.first.documentID;
          await Firestore.instance.collection('users').document(documentID).collection("players").document(id).updateData({
            "taken": FieldValue.increment(1),
          });
        }
      }
      else {
        final documents = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: oldPlayer).getDocuments();
        final id = documents.documents.first.documentID;
        await Firestore.instance.collection('users').document(documentID).collection("players").document(id).updateData({
          "taken": FieldValue.increment(-1),
          "thrown": FieldValue.increment(-1)
        });
        if(name==player1 || name==player2){
          final documents = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: name).getDocuments();
          final id = documents.documents.first.documentID;
          await Firestore.instance.collection('users').document(documentID).collection("players").document(id).updateData({
            "taken": FieldValue.increment(1),
            "thrown": FieldValue.increment(1)
          });
        }
        else {
          final documents = await Firestore.instance.collection('users').document(documentID).collection('players').where("name", isEqualTo: name).getDocuments();
          final id = documents.documents.first.documentID;
          await Firestore.instance.collection('users').document(documentID).collection("players").document(id).updateData({
            "taken": FieldValue.increment(1),
          });
        }
      }
    }
  }
}

class NewRound extends StatefulWidget {
  final String documentID;
  final String player1, player2, player3, player4;
  final String playerWhoTookUpdate;
  final int teamOneDeclarationUpdate, teamTwoDeclationUpdate;
  final int teamOnePointsUpdate, teamTwoPointsUpdate;
  final int whoHasBR,whoIsCapot;
  final int teamOne20DeclarationUpdate,teamOne50DeclarationUpdate,teamOne100DeclarationUpdate,teamOne150DeclarationUpdate,teamOne200DeclarationUpdate;
  final int teamTwo20DeclarationUpdate,teamTwo50DeclarationUpdate,teamTwo100DeclarationUpdate,teamTwo150DeclarationUpdate,teamTwo200DeclarationUpdate;
  final int teamOneTotalPointsPrevious, teamTwoTotalPointsPrevious;
  NewRound(this.documentID,this.player1,this.player2,this.player3,this.player4,this.teamOnePointsUpdate,this.teamTwoPointsUpdate,
      this.playerWhoTookUpdate,this.teamOneDeclarationUpdate, this.teamTwoDeclationUpdate, this.whoHasBR,this.whoIsCapot,
      this.teamOne20DeclarationUpdate,this.teamOne50DeclarationUpdate,this.teamOne100DeclarationUpdate,this.teamOne150DeclarationUpdate,this.teamOne200DeclarationUpdate,
      this.teamTwo20DeclarationUpdate,this.teamTwo50DeclarationUpdate,this.teamTwo100DeclarationUpdate,this.teamTwo150DeclarationUpdate,this.teamTwo200DeclarationUpdate,this.teamOneTotalPointsPrevious,this.teamTwoTotalPointsPrevious);

  @override
  _NewRoundState createState() => _NewRoundState();
}

class _NewRoundState extends State<NewRound> {
  int maxPointsOfRound = 162;
  int teamOneTotalPoints = 0;
  int teamTwoTotalPoints = 0;

  List<RadioModel> TeamOnePlayers = new List<RadioModel>();
  List<RadioModel> TeamTwoPlayers = new List<RadioModel>();

  var teamOnePoints = TextEditingController();
  var teamTwoPoints = TextEditingController();
  final validateTeamOnePoints = false;
  final validateTeamTwoPoints = false;

  num teamOneDeclaration = 0;
  num teamTwoDeclaration = 0;

  num teamOne20Declarations = 0;
  num teamOne50Declarations = 0;
  num teamOne100Declarations = 0;
  num teamOne150Declarations = 0;
  num teamOne200Declarations = 0;

  num teamTwo20Declarations = 0;
  num teamTwo50Declarations = 0;
  num teamTwo100Declarations = 0;
  num teamTwo150Declarations = 0;
  num teamTwo200Declarations = 0;

  int _groupValue = -1;
  int capot = -1;
  bool maxLengthTextFieldTeamOne = false;
  bool maxLengthTextFieldTeamTwo = false;

  String playerWhoTook = '';

  final firestoreInstance = Firestore.instance;
  @override
  void initState() {
    super.initState();
    TeamOnePlayers.add(RadioModel(false, widget.player1));
    TeamOnePlayers.add(RadioModel(false, widget.player2));
    TeamTwoPlayers.add(RadioModel(false, widget.player3));
    TeamTwoPlayers.add(RadioModel(false, widget.player4));
    _groupValue = widget.whoHasBR;
    capot = widget.whoIsCapot;
    teamOneDeclaration = widget.teamOneDeclarationUpdate;
    teamTwoDeclaration = widget.teamTwoDeclationUpdate;
    playerWhoTook = widget.playerWhoTookUpdate;
    this.teamOne20Declarations = widget.teamOne20DeclarationUpdate;
    this.teamOne50Declarations = widget.teamOne50DeclarationUpdate;
    this.teamOne100Declarations = widget.teamOne100DeclarationUpdate;
    this.teamOne150Declarations = widget.teamOne150DeclarationUpdate;
    this.teamOne200Declarations = widget.teamOne200DeclarationUpdate;

    this.teamTwo20Declarations = widget.teamTwo20DeclarationUpdate;
    this.teamTwo50Declarations = widget.teamTwo50DeclarationUpdate;
    this.teamTwo100Declarations = widget.teamTwo100DeclarationUpdate;
    this.teamTwo150Declarations = widget.teamTwo150DeclarationUpdate;
    this.teamTwo200Declarations = widget.teamTwo200DeclarationUpdate;

    if(widget.teamOnePointsUpdate != 0){
      teamOnePoints.text = widget.teamOnePointsUpdate.toString();
    }
    if(widget.teamTwoPointsUpdate != 0){
      teamTwoPoints.text = widget.teamTwoPointsUpdate.toString();
    }
    if(playerWhoTook == 'player0'){
      TeamOnePlayers[0].isSelected = true;
    }
    else if(playerWhoTook == 'player1'){
      TeamOnePlayers[1].isSelected = true;
    }
    else if(playerWhoTook == 'player2'){
      TeamTwoPlayers[0].isSelected = true;
    }
    else if(playerWhoTook == 'player3') {
      TeamTwoPlayers[1].isSelected = true;
    }
    calculateTotalScore();
  }
  @override
  Widget build(BuildContext context) {
    final bool showFloatingButton = MediaQuery.of(context).viewInsets.bottom==0.0;
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: new AppBar(title: Text('Нова рунда'),),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Кој ја зеде?',textAlign: TextAlign.center,style: TextStyle(fontSize: 24),)
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        height: 130,
                        width: MediaQuery.of(context).size.width / 2,
                        child: ListView.builder(
                            itemCount: TeamOnePlayers.length,
                            itemBuilder: (BuildContext context, int index) {
                              return new InkWell(
                                onTap: () {
                                  setState(() {
                                    TeamOnePlayers.forEach((element) => { element.isSelected = false});
                                    TeamTwoPlayers.forEach((element) => { element.isSelected = false});
                                    TeamOnePlayers[index].isSelected = true;
                                    playerWhoTook = 'player' + index.toString();
                                    calculateTotalScore();
                                  });
                                },
                                child: RadioItem(TeamOnePlayers[index]),
                              );
                            }),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        height: 130,
                        width: MediaQuery.of(context).size.width / 2,
                        child: ListView.builder(
                            itemCount: TeamOnePlayers.length,
                            itemBuilder: (BuildContext context, int index) {
                              return new InkWell(
                                onTap: () {
                                  setState(() {
                                    TeamTwoPlayers.forEach((element) => { element.isSelected = false});
                                    TeamOnePlayers.forEach((element) => { element.isSelected = false});
                                    TeamTwoPlayers[index].isSelected = true;
                                    playerWhoTook = 'player' + (index+2).toString();
                                    calculateTotalScore();
                                  });
                                },
                                child: RadioItem(TeamTwoPlayers[index]),
                              );
                            }),
                      )
                    ],
                  ),
                ],
              ),
              Container(
                child: Text('Поени', style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),),
              ),
              Row(
                children: <Widget>[
                  new Flexible(
                    child: new TextFormField(
                      autofocus: false,
                      maxLength: maxLengthTextFieldTeamOne ? 2 : 3,
                      keyboardType: TextInputType.number,
                      controller: teamOnePoints,
                      decoration: InputDecoration(
                        labelText: 'Тим 1',
                        errorText: validateTeamOnePoints ? 'Внеси поени' : null,
                        fillColor: Colors.grey,
                        counterText: '',
                      ),
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      onChanged: (val) => updateOtherTeamScore(val,true),

                    ),
                  ),
                  Spacer(),
                  new Flexible(
                    child: new TextFormField(
                      autofocus: false,
                      maxLength: maxLengthTextFieldTeamTwo ? 2 : 3,
                      keyboardType: TextInputType.number,
                      controller: teamTwoPoints,
                      decoration: InputDecoration(
                        labelText: 'Тим 2',
                        errorText: validateTeamTwoPoints ? 'Внеси поени' : null,
                        fillColor: Colors.grey,
                        counterText: '',
                      ),
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      onChanged: (val) => updateOtherTeamScore(val,false),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton(
                      child: Text(teamOneDeclaration.toString()),
                      onPressed: () {
                        AlertDialog alert = new AlertDialog(
                          title: Text('Тим 1 - Вадено', textAlign: TextAlign.center,),
                          content: StatefulBuilder(
                            builder: (BuildContext context, StateSetter setState) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          margin: EdgeInsets.all(2),
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 1, color: Colors.blue.shade700),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child:Text('20', style: TextStyle(fontSize: 23),),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          margin: EdgeInsets.all(2),
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 1, color: Colors.blue.shade700),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: new DropdownButton<int>(
                                              value: teamOne20Declarations,
                                              items: <int>[0, 1, 2, 3, 4].map((int value) {
                                                return new DropdownMenuItem<int>(
                                                  value: value,
                                                  child: new Text(value.toString(), style: TextStyle(fontSize: 23),),
                                                );
                                              }).toList(),
                                              onChanged: (num score) {
                                                setState(() {
                                                  this.teamOne20Declarations = score;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          margin: EdgeInsets.all(2),
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 1, color: Colors.blue.shade700),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child:Text('50', style: TextStyle(fontSize: 23),),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          margin: EdgeInsets.all(2),
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 1, color: Colors.blue.shade700),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: new DropdownButton<int>(
                                              value: teamOne50Declarations,
                                              items: <int>[0, 1, 2, 3, 4].map((int value) {
                                                return new DropdownMenuItem<int>(
                                                  value: value,
                                                  child: new Text(value.toString(), style: TextStyle(fontSize: 23),),
                                                );
                                              }).toList(),
                                              onChanged: (num score) {
                                                setState(() {
                                                  this.teamOne50Declarations = score;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          margin: EdgeInsets.all(2),
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 1, color: Colors.blue.shade700),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child:Text('100', style: TextStyle(fontSize: 23),),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          margin: EdgeInsets.all(2),
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 1, color: Colors.blue.shade700),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: new DropdownButton<int>(
                                              value: teamOne100Declarations,
                                              items: <int>[0, 1, 2, 3, 4].map((int value) {
                                                return new DropdownMenuItem<int>(
                                                  value: value,
                                                  child: new Text(value.toString(), style: TextStyle(fontSize: 23),),
                                                );
                                              }).toList(),
                                              onChanged: (num score) {
                                                setState(() {
                                                  this.teamOne100Declarations = score;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          margin: EdgeInsets.all(2),
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 1, color: Colors.blue.shade700),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child:Text('150', style: TextStyle(fontSize: 23),),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          margin: EdgeInsets.all(2),
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 1, color: Colors.blue.shade700),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: new DropdownButton<int>(
                                              value: teamOne150Declarations,
                                              items: <int>[0, 1].map((int value) {
                                                return new DropdownMenuItem<int>(
                                                  value: value,
                                                  child: new Text(value.toString(), style: TextStyle(fontSize: 23),),
                                                );
                                              }).toList(),
                                              onChanged: (num score) {
                                                setState(() {
                                                  this.teamOne150Declarations = score;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          margin: EdgeInsets.all(2),
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 1, color: Colors.blue.shade700),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child:Text('200', style: TextStyle(fontSize: 23),),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          margin: EdgeInsets.all(2),
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 1, color: Colors.blue.shade700),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: new DropdownButton<int>(
                                              value: teamOne200Declarations,
                                              items: <int>[0, 1].map((int value) {
                                                return new DropdownMenuItem<int>(
                                                  value: value,
                                                  child: new Text(value.toString(), style: TextStyle(fontSize: 23),),
                                                );
                                              }).toList(),
                                              onChanged: (num score) {
                                                setState(() {
                                                  this.teamOne200Declarations = score;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Назад'),
                              onPressed: () => Navigator.pop(context),
                            ),
                            FlatButton(
                              child: Text('Зачувај'),
                              onPressed: () => {
                                setState(() {
                                  teamOneDeclaration = 20*teamOne20Declarations + 50 * teamOne50Declarations + 100 * teamOne100Declarations
                                      + 150* teamOne150Declarations + 200 * teamOne200Declarations;
                                  calculateTotalScore();
                                }),
                                Navigator.of(context, rootNavigator: true).pop('dialog')
                              },
                            ),
                          ],
                        );
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => alert,
                        );
                      },
                    ),
                    Text('Вадено', style: TextStyle(fontSize: 20),),
                    RaisedButton(
                      child: Text(teamTwoDeclaration.toString()),
                      onPressed: () {
                        AlertDialog alert = new AlertDialog(
                          title: Text('Тим 2 - Вадено', textAlign: TextAlign.center,),
                          content: StatefulBuilder(
                            builder: (BuildContext context, StateSetter setState) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          margin: EdgeInsets.all(2),
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 1, color: Colors.blue.shade700),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child:Text('20', style: TextStyle(fontSize: 23),),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          margin: EdgeInsets.all(2),
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 1, color: Colors.blue.shade700),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: new DropdownButton<int>(
                                              value: teamTwo20Declarations,
                                              items: <int>[0, 1, 2, 3, 4].map((int value) {
                                                return new DropdownMenuItem<int>(
                                                  value: value,
                                                  child: new Text(value.toString(), style: TextStyle(fontSize: 23),),
                                                );
                                              }).toList(),
                                              onChanged: (num score) {
                                                setState(() {
                                                  this.teamTwo20Declarations = score;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          margin: EdgeInsets.all(2),
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 1, color: Colors.blue.shade700),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child:Text('50', style: TextStyle(fontSize: 23),),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          margin: EdgeInsets.all(2),
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 1, color: Colors.blue.shade700),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: new DropdownButton<int>(
                                              value: teamTwo50Declarations,
                                              items: <int>[0, 1, 2, 3, 4].map((int value) {
                                                return new DropdownMenuItem<int>(
                                                  value: value,
                                                  child: new Text(value.toString(), style: TextStyle(fontSize: 23),),
                                                );
                                              }).toList(),
                                              onChanged: (num score) {
                                                setState(() {
                                                  this.teamTwo50Declarations = score;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          margin: EdgeInsets.all(2),
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 1, color: Colors.blue.shade700),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child:Text('100', style: TextStyle(fontSize: 23),),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          margin: EdgeInsets.all(2),
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 1, color: Colors.blue.shade700),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: new DropdownButton<int>(
                                              value: teamTwo100Declarations,
                                              items: <int>[0, 1, 2, 3, 4].map((int value) {
                                                return new DropdownMenuItem<int>(
                                                  value: value,
                                                  child: new Text(value.toString(), style: TextStyle(fontSize: 23),),
                                                );
                                              }).toList(),
                                              onChanged: (num score) {
                                                setState(() {
                                                  this.teamTwo100Declarations = score;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          margin: EdgeInsets.all(2),
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 1, color: Colors.blue.shade700),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child:Text('150', style: TextStyle(fontSize: 23),),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          margin: EdgeInsets.all(2),
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 1, color: Colors.blue.shade700),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: new DropdownButton<int>(
                                              value: teamTwo150Declarations,
                                              items: <int>[0, 1].map((int value) {
                                                return new DropdownMenuItem<int>(
                                                  value: value,
                                                  child: new Text(value.toString(), style: TextStyle(fontSize: 23),),
                                                );
                                              }).toList(),
                                              onChanged: (num score) {
                                                setState(() {
                                                  this.teamTwo150Declarations = score;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          margin: EdgeInsets.all(2),
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 1, color: Colors.blue.shade700),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child:Text('200', style: TextStyle(fontSize: 23),),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          margin: EdgeInsets.all(2),
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 1, color: Colors.blue.shade700),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: new DropdownButton<int>(
                                              value: teamTwo200Declarations,
                                              items: <int>[0, 1].map((int value) {
                                                return new DropdownMenuItem<int>(
                                                  value: value,
                                                  child: new Text(value.toString(), style: TextStyle(fontSize: 23),),
                                                );
                                              }).toList(),
                                              onChanged: (num score) {
                                                setState(() {
                                                  this.teamTwo200Declarations = score;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Назад'),
                              onPressed: () => Navigator.pop(context),
                            ),
                            FlatButton(
                              child: Text('Зачувај'),
                              onPressed: () => {
                                setState(() {
                                  teamTwoDeclaration = 20*teamTwo20Declarations + 50 * teamTwo50Declarations + 100 * teamTwo100Declarations
                                      + 150* teamTwo150Declarations + 200 * teamTwo200Declarations;
                                  calculateTotalScore();
                                }),
                                Navigator.of(context, rootNavigator: true).pop('dialog')
                              },
                            ),
                          ],
                        );
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => alert,
                        );
                      },
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onDoubleTap: () {
                      setState(() {
                        _groupValue = -1;
                        calculateTotalScore();
                      });
                    },
                    child: Radio(
                      value: 1,
                      groupValue: _groupValue,
                      onChanged: (val) {
                        setState(() {
                          _groupValue = val;
                          calculateTotalScore();
                        });
                      },
                    ),
                  ),
                  Text('Бељот ромбељот', style: TextStyle(fontSize: 20),),
                  GestureDetector(
                    onDoubleTap: () {
                      setState(() {
                        _groupValue = -1;
                        calculateTotalScore();
                      });
                    },
                    child: Radio(
                      value: 2,
                      groupValue: _groupValue,
                      onChanged: (val) {
                        setState(() {
                          _groupValue = val;
                          calculateTotalScore();
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onDoubleTap: () {
                      setState(() {
                        capot = -1;
                        calculateTotalScore();
                      });
                    },
                    child: Radio(
                      value: 1,
                      groupValue: capot,
                      onChanged: (val) {
                        setState(() {
                          capot = val;
                          calculateTotalScore();
                        });
                      },
                    ),
                  ),
                  Text('Чаљо', style: TextStyle(fontSize: 20),),
                  GestureDetector(
                    onDoubleTap: () {
                      setState(() {
                        capot = -1;
                        calculateTotalScore();
                      });
                    },
                    child: Radio(
                      value: 2,
                      groupValue: capot,
                      onChanged: (val) {
                        setState(() {
                          capot = val;
                          calculateTotalScore();
                        });
                      },
                    ),
                  ),
                ],
              ),
              Divider(
                  color: Colors.black
              ),
              Container(
                child: Text(
                  'Вкупно поени',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 50, right: 50, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(teamOneTotalPoints.toString(), style: TextStyle(fontSize: 23),),
                    Text(teamTwoTotalPoints.toString(), style: TextStyle(fontSize: 23),),
                  ],
                ),
              ),
            ],
          ),
        )
      ),
      floatingActionButton: showFloatingButton? FloatingActionButton.extended(
        onPressed: () async {
          if(playerWhoTook.isEmpty){
            AlertDialog alert = new AlertDialog(
              title: Text('Селектирај кој ја зеде!'),
            );
            showDialog(
              context: context,
              builder: (BuildContext c) => alert
            );
          }
          else if((teamOneTotalPoints + teamTwoTotalPoints) < 162){
            AlertDialog alert = new AlertDialog(
              title: Text('Неправилно внесени поени!'),
            );
            showDialog(
                context: context,
                builder: (BuildContext c) => alert
            );
          }
          else if(teamOneTotalPoints < 0 || teamTwoTotalPoints < 0) {
            AlertDialog alert = new AlertDialog(
              title: Text('Неправилно внесени поени!'),
            );
            showDialog(
                context: context,
                builder: (BuildContext c) => alert,
            );
          }
          else {
            var res = '''
            { "teamOneTotalPoints" : $teamOneTotalPoints,
             "teamTwoTotalPoints" : $teamTwoTotalPoints,
             "playerWhoTook" : "$playerWhoTook", 
             "teamOneDeclarations": $teamOneDeclaration,
             "teamTwoDeclarations": $teamTwoDeclaration,
             "teamOnePoints": ${teamOnePoints.text},
             "teamTwoPoints": ${teamTwoPoints.text},
             "capot" : $capot,
             "BR" : $_groupValue,
             "teamOne20Declaration": $teamOne20Declarations,
             "teamOne50Declaration": $teamOne50Declarations,
             "teamOne100Declaration": $teamOne100Declarations,
             "teamOne150Declaration": $teamOne150Declarations,
             "teamOne200Declaration": $teamOne200Declarations,
             "teamTwo20Declaration": $teamTwo20Declarations,
             "teamTwo50Declaration": $teamTwo50Declarations,
             "teamTwo100Declaration": $teamTwo100Declarations,
             "teamTwo150Declaration": $teamTwo150Declarations,
             "teamTwo200Declaration": $teamTwo200Declarations
             }''';
            if(playerWhoTook == 'player0'){
              playerWhoTook = widget.player1;
            }
            else if(playerWhoTook == 'player1'){
              playerWhoTook = widget.player2;
            }
            else if(playerWhoTook == 'player2'){
              playerWhoTook = widget.player3;
            }
            else if(playerWhoTook == 'player3'){
              playerWhoTook = widget.player4;
            }
            await updateUser(playerWhoTook, widget.player1, widget.player2, widget.player3, widget.player4,teamOneTotalPoints,teamTwoTotalPoints, widget.documentID, widget.playerWhoTookUpdate, widget.teamOneTotalPointsPrevious,widget.teamTwoTotalPointsPrevious).then((value) =>
                Navigator.pop(context,res));
          }
        },
        backgroundColor: Colors.green,
        label: Text(
          'Зачувај',
          style: TextStyle(fontSize: 17),
        ),
        icon: Icon(Icons.save),
      ) : null,
    );
  }
  void updateOtherTeamScore(String score, bool team) {
    if(team) {
      if(this.teamOnePoints.text[0] == '1'){
        setState(() {
          this.maxLengthTextFieldTeamOne = false;
          this.teamTwoPoints.text = (maxPointsOfRound - int.parse(this.teamOnePoints.text)).toString();
          calculateTotalScore();
        });
      }
      else {
        setState(() {
          this.maxLengthTextFieldTeamOne = true;
          this.teamTwoPoints.text = (maxPointsOfRound - int.parse(this.teamOnePoints.text)).toString();
          calculateTotalScore();
        });
      }
    }
    else {
      if(this.teamTwoPoints.text[0] ==  '1'){
        setState(() {
          this.maxLengthTextFieldTeamTwo = false;
          this.teamOnePoints.text = (maxPointsOfRound - int.parse(this.teamTwoPoints.text)).toString();
          calculateTotalScore();
        });
      }
      else {
        setState(() {
          this.maxLengthTextFieldTeamTwo = true;
          this.teamOnePoints.text = (maxPointsOfRound - int.parse(this.teamTwoPoints.text)).toString();
          calculateTotalScore();
        });
      }
    }
  }
  void calculateTotalScore() {
    setState(() {
      int top = 0;
      int ttp = 0;
      if(teamOnePoints.text.isNotEmpty){
        top = int.parse(teamOnePoints.text);
      }
      if(teamTwoPoints.text.isNotEmpty){
        ttp = int.parse(teamTwoPoints.text);
      }
      teamOneTotalPoints = top + teamOneDeclaration;
      teamTwoTotalPoints = ttp + teamTwoDeclaration;
      if(capot == 1){
        teamOneTotalPoints = 252 + teamOneDeclaration;
        teamTwoTotalPoints = teamTwoDeclaration;
        teamOnePoints.text = 162.toString();
        teamTwoPoints.text = 0.toString();
      }
      else if(capot == 2){
        teamTwoTotalPoints = 252 + teamTwoDeclaration;
        teamOneTotalPoints = teamOneDeclaration;
        teamTwoPoints.text = 162.toString();
        teamOnePoints.text = 0.toString();
      }
      if(_groupValue == 1){
        teamOneTotalPoints += 20;
      }
      else if(_groupValue == 2){
        teamTwoTotalPoints += 20;
      }

      int maxPoints = teamOneTotalPoints + teamTwoTotalPoints;
      if(playerWhoTook.isNotEmpty){
        if(playerWhoTook == 'player0' || playerWhoTook == 'player1'){
          if(teamOneTotalPoints < (maxPoints / 2)){
            teamTwoTotalPoints = maxPoints;
            teamOneTotalPoints = 0;
          }
        }
        else if(playerWhoTook == 'player2' || playerWhoTook=='player3'){
          if(teamTwoTotalPoints < (maxPoints / 2)){
            teamOneTotalPoints = maxPoints;
            teamTwoTotalPoints = 0;
          }
        }
      }
    });
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;

  RadioModel(this.isSelected, this.buttonText);
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Container(
        margin: EdgeInsets.all(2),
        child: Align(
          alignment: Alignment.center,
          child: Text(_item.buttonText, style: TextStyle(fontSize: 20,),textAlign: TextAlign.center,),
        ),
        decoration: new BoxDecoration(
          color: _item.isSelected ? Colors.grey.shade500 : Colors.grey.shade300,
          border: Border.all(width: 1, color: _item.isSelected ? Colors.black : Colors.grey.shade300),
          borderRadius: new BorderRadius.circular(10)
        ),
    ),);
  }
}

