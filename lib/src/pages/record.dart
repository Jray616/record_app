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

  Function _showBottomSheetCallback;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //存放数据
  List<Map> items;
  bool isLoad = false;
  //存放选中的值
  Map result = new Map();

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
      child: RecordProvider(
        id: result['select'],
        AmountType: '001001',
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
      )

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
        String id = map['Id'];
        String url = "lib/src/images/" + map['Path'];
        String text = map['Name'];
        return IconData(
          id: id,
          url: url,
          text: text,
          result: result,
          callback: _showBottomSheet,
        );
      },
    );
  }

  /// 底部弹出 自定义键盘  下滑消失
  void _showBottomSheet(String val){

    //如果没有选中就弹出来
    if(result['select'] == null){
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
    result['select'] = val;
    setState(() {

    });
  }

}


class IconData extends StatefulWidget{
  String id;
  String url;
  String text;
  Map result;
  final callback;
  IconData({Key key, this.id,this.url,this.text,this.result,this.callback}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return IconDataState();
  }
}

class IconDataState extends State<IconData>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return GestureDetector(
      //点击事件
      onTap: (){
        widget.callback(widget.id);
      },
      child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: widget.result['select'] == widget.id ? Colors.amberAccent : Colors.white70,
              border: Border.all(color: Colors.white,width: 1.0),
              borderRadius: BorderRadius.circular(200.0),
            ),
            padding: EdgeInsets.all(13.0),
            child: Image.asset(
              widget.url,
            ),
          )
          ,
          Container(
            margin: const EdgeInsets.only(top: 2),
            child: Text(widget.text),
          ),
        ],
      ),

    );
  }



}

class RecordProvider extends InheritedWidget{

  final String id;
  final String AmountType;
  final Widget child;

  RecordProvider({this.id, this.AmountType, this.child}): super(child: child);

  static RecordProvider of(BuildContext context) =>
    context.inheritFromWidgetOfExactType(RecordProvider);
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

}







