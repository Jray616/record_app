import 'package:flutter/material.dart';

class Detail extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          title: Text("记账"),
          centerTitle: true,
          bottom: PreferredSize(
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text("2019年"),
                        ),
                        Container(
                          margin: const EdgeInsets.all(3.0),
                          child: Text("04月"),

                        )
                      ],

                    ),
                    onTap: (){
                      print("111111111111");
                    },
                  )

                ],
              ),
              preferredSize: Size(11, 11)
          ),
        ),
        preferredSize: Size.fromHeight(80)
      ),
    );

  }

}