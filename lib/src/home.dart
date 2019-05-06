import 'package:flutter/material.dart';
import 'pages/my.dart';
import 'pages/chart.dart';
import 'pages/detail.dart';
import 'pages/record.dart';

class BottomnavigationWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BottomnavigationWigetState();
}

class BottomnavigationWigetState extends State<BottomnavigationWidget> {
  final _bottonNavitionColor = Colors.blue;
  int _currentIndex = 0;
  List<Widget> list = List();

  @override
  void initState() {
    list.add(Detail());
    list.add(Chart());
    list.add(Record());
    list.add(My());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: list[_currentIndex],
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => Record()
            ));
          },
        child: Icon(
          Icons.add,
          color: Colors.white70,
        ),

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,  //融合
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.assignment,
                color: _bottonNavitionColor,
              ),
              title: (Text(
                '明细',
                style: TextStyle(color: _bottonNavitionColor),
              ))),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.assessment,
                color: _bottonNavitionColor,
              ),
              title: (Text(
                '图表',
                style: TextStyle(color: _bottonNavitionColor),
              ))),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.assessment,
                color: _bottonNavitionColor,
              ),
              title: (Text(
                '发现',
                style: TextStyle(color: _bottonNavitionColor),
              ))),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
                color: _bottonNavitionColor,
              ),
              title: (Text(
                '我的',
                style: TextStyle(color: _bottonNavitionColor),
              ))),
        ],
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
