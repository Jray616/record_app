import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class Record extends StatelessWidget{
  final List<Tab> mytabls = <Tab>[
    new Tab(text: '收入'),
    new Tab(text: '支出')
  ];

  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
        length: mytabls.length,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: mytabls,
              controller: _tabController,
              isScrollable: true,
            ),
          ),
          body: TabBarView(
              children: <Widget>[
                Center(
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    child: IconList()
                  ),
                ),
                Center(
                  child: Text('支出'),
                ),
              ],
          ),
        ),

    );
  }

}


//图标列表组件
class IconList extends StatelessWidget{

  final List<Map> items;
  IconList({Key key,@required this.items}):super(key:key);

  //获取图标列表
  Future getIconsList() async{
    Dio dio = new Dio();
    var url = "http://127.0.0.1:8081/directory/getAllDirectory";

    Response response = await dio.post(url);
    String data = response.data;
    Map map = json.decode(data);
    return map;
  }

  @override
  Widget build(BuildContext context) {

    var iconsList = getIconsList();

    // TODO: implement build
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing:5.0,  //纵轴间距
          crossAxisSpacing: 5.0,
          childAspectRatio: 1
      ),
      itemCount: items.length,
      itemBuilder: (BuildContext context,int index){
        Map map = items[index];
        String url = map['url'];
        String text = map['text'];
        return icon(url: url,text: text);
      },
    )
    ;
  }



}


//图标组件
class icon extends StatelessWidget{

  final String url;
  final String text;

  const icon({Key key, this.url, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Image.asset(url,
          width: 50.0,
          height: 50.0,
          fit: BoxFit.contain,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(text)
          ],
        ),
      ],
    );
  }

}
