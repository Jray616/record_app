import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:record_app/src/keyBoard/keyboard_widget.dart';

class Record extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return RecordState();
  }

}

class RecordState extends State<Record>{

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



  //存放数据
  List<Map> items;
  VoidCallback _showBottomSheetCallback;
  bool isLoad = false;

  final List<Tab> mytabls = <Tab>[
    new Tab(text: '收入'),
    new Tab(text: '支出')
  ];

  TabController _tabController;

  @override
  void initState() {
    _showBottomSheetCallback = _showBottomSheet;

    getIconsList().then((val){
      setState(() {
        items = (val['data'] as List).cast();
        isLoad = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: mytabls.length,
      child: Scaffold(
        key: _scaffoldKey,
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
              child: getLeft(),
            ),
            Center(
              child: Text('支出'),
            ),
          ],
        ),
      ),

    );
  }


  //获取收入列表
  Widget getLeft(){
    if (isLoad) {
      return Container(
          margin: const EdgeInsets.all(10.0),
          child: getIconList()
      );
    }else{
      getLoading();
    }
  }

  ///加载页面
  Widget getLoading(){
    return Container(
        margin: const EdgeInsets.all(10.0),
        child: Center(
          child: Text("加载中......"),
        )
    );

  }

  //获取图标列表
  Future getIconsList() async{
    try {
      Response response;
      Dio dio = new Dio();
      dio.options.baseUrl = "http://118.24.61.197:8081";
      response = await dio.get("/directory/getAllDirectory");
      return response.data;
    } catch (e) {
      print(e);
    }

  }

  //图标列表组件
  Widget getIconList(){
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
        String url = "lib/src/images/" + map['Path'];
        String text = map['Name'];
        return getIcon(url, text);
      },
    );
  }




  /// 底部弹出 自定义键盘  下滑消失
  void _showBottomSheet(){
    setState(() {
      // disable the button
      _showBottomSheetCallback = null;
    });
    _scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) {
      return MyKeyboard();
    }).closed.
    whenComplete((){
      if (mounted) {
        setState(() {
          // re-enable the button
          _showBottomSheetCallback = _showBottomSheet;
        });
      }
    });

  }

  Widget getIcon (String url,String text){

    // TODO: implement build
    return GestureDetector(
      //点击事件
      onTap: (){
        _showBottomSheetCallback();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            url,
            width: 50.0,
            height: 50.0,
            fit: BoxFit.cover,
          ),
          Container(
            margin: const EdgeInsets.only(top: 2),
            child: Text(text),
          )
        ],
      ),
    );

  }

}









