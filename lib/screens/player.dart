import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class Player extends StatefulWidget {
  final String playerID, playerName;
  final int taken,thrown,wins,losses;
  const Player(this.playerID,this.playerName,this.wins,this.losses,this.taken,this.thrown);
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  Map<String, double> dataForGames = new Map();
  Map<String, double> dataForRounds = new Map();
  List<Color> _colors = [
    Colors.green,
    Colors.red
  ];
  @override
  void initState() {
      dataForGames.addAll({
        'Победи': widget.wins.toDouble(),
        'Изгуби': widget.losses.toDouble(),
      });
      dataForRounds.addAll({
        'Изваени': (widget.taken-widget.thrown).toDouble(),
        'Шитнати': widget.thrown.toDouble(),
      });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Играч'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Text('Име на играчот: ' + widget.playerName, style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
            ),
            Container(
              child: Text('Игри', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23),),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Text('Победи: ' + widget.wins.toString(), style: TextStyle(fontSize: 20,color: Colors.green),),
                ),
                Container(
                  child: Text('Изгуби: ' + widget.losses.toString(), style: TextStyle(fontSize: 20, color: Colors.red),),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            PieChart(
              dataMap: dataForGames,
              colorList: _colors,
              chartLegendSpacing: 32.0,
              chartRadius: MediaQuery.of(context).size.width / 2,
              chartType: ChartType.ring,
              ringStrokeWidth: 25,
              centerText: 'Изиграни: ' + (widget.wins+widget.losses).toString(),
              legendOptions: LegendOptions(
                showLegends: false,
              ),
              chartValuesOptions: ChartValuesOptions(
                showChartValueBackground: true,
                showChartValues: true,
                showChartValuesInPercentage: true,
                showChartValuesOutside: false,
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            Row(
                children: <Widget>[
                  Expanded(
                      child: Divider()
                  ),
                ]
            ),
            Container(
              child: Text('Земени партии', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23),),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: Text('Изваени: ' + (widget.taken - widget.thrown).toString(), style: TextStyle(fontSize: 20,color: Colors.green),),
                ),
                Container(
                  child: Text('Шитнати: ' + (widget.thrown).toString(), style: TextStyle(fontSize: 20,color: Colors.red),),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            PieChart(
              dataMap: dataForRounds,
              colorList: _colors,
              chartLegendSpacing: 32.0,
              chartRadius: MediaQuery.of(context).size.width / 2,
              chartType: ChartType.ring,
              ringStrokeWidth: 25,
              centerText: 'Земени: ' + (widget.taken).toString(),
              legendOptions: LegendOptions(
                showLegends: false,
              ),
              chartValuesOptions: ChartValuesOptions(
                showChartValueBackground: true,
                showChartValues: true,
                showChartValuesInPercentage: true,
                showChartValuesOutside: false,
              ),
            ),
          ],
        ),
      )
    );
  }
}
