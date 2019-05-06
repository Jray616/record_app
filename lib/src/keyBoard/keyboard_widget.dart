import 'package:flutter/material.dart';
import 'package:record_app/src/keyBoard/custom_keyboard_button.dart';
import 'package:record_app/src/keyBoard/pay_password.dart';
import 'package:dio/dio.dart';
import '../pages/record.dart';


/// 自定义密码 键盘
class MyKeyboard extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return MyKeyboardState();
  }

}

class MyKeyboardState extends State<MyKeyboard>{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ButtonState> buttonStatekey = GlobalKey<ButtonState>();
  String dateStr = "今天";
  String dataStr2 = "";
  double size = 20.0;
  /// 定义 确定 按钮 接口  暴露给调用方
  String moneyStr = "";
  double money = 0;
  String confirmStr = "完成";


  ///回调函数
  void _onKeyDown(BuildContext cont,KeyEvent data){

    if(data.key == "date"){
      showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime.now().subtract(new Duration(days: 30)), // 减 30 天
        lastDate: new DateTime.now().add(new Duration(days: 30)),       // 加 30 天
      ).then((DateTime val) {
        print(val);   // 2018-07-12 00:00:00.000
        setState(() {
          dataStr2 = val.year.toString() + "-" + val.month.toString() + "-" + val.day.toString();
          dateStr =  val.year.toString() + "/" + val.month.toString() + "/" + val.day.toString();
          size = 13.0;
        });
      }).catchError((err) {
        print(err);
      });
      return;
    }

    if (moneyStr.contains("+") && !moneyStr.endsWith("+")){

      if (data.key == "+" || data.key == "-" || data.key == "=") {
        List<String> split = moneyStr.split("+");
        double a = double.parse(split[0]);
        double b = double.parse(split[1]);
        money = a + b;
        if (data.key == "=") {
          moneyStr = money.toString();
        }else{
          moneyStr = money.toString() + "-";
        }
      }
    }

    if (moneyStr.contains("-") && !moneyStr.endsWith("-")){

      if (data.key == "+" || data.key == "-" || data.key == "=") {
        List<String> split = moneyStr.split("-");
        double a = double.parse(split[0]);
        double b = double.parse(split[1]);
        money = a - b;
        if (data.key == "=") {
          moneyStr = money.toString();
        }else{
          moneyStr = money.toString() + "-";
        }
      }
    }

    //=符号逻辑判读
    if ((moneyStr.contains("+") || moneyStr.contains("-")) && (!moneyStr.endsWith("+") || !moneyStr.endsWith("-"))) {
      confirmStr = "=";
      setState(() {});
    }
    //如果点击了=号之后就变成完成
    if (data.key == "=") {
      confirmStr = "完成";
      setState(() {});
    }

    if ( data.key != "=" && !data.isDelete() && !data.isCommit()) {
      if (moneyStr.endsWith("+") || moneyStr.endsWith("-")) {
        if (data.key == "+" || data.key == "-") {
          setState(() {});
          return;
        }
      }
      moneyStr += data.key;
    }

    if (data.isDelete()) {
      if (moneyStr.length > 0) {
        moneyStr = moneyStr.substring(0, moneyStr.length - 1);
      }
    } else if (data.isCommit()) {
      money = double.parse(moneyStr);
      saveRecord(cont).then((val){
        print(val);
      });

    }
    setState(() {});
  }

  //保存记录
  Future saveRecord(BuildContext context) async{
    try {

      Map param = new Map();
      param['UserId'] = "1111";
      param['Amount'] = money;
      param['Date'] = dataStr2;
      param['Directory'] = RecordProvider.of(context).id;

      Dio dio = new Dio();
      dio.options.baseUrl = "http://118.24.61.197:8081";
      var post = dio.post("/record/saveRecord",data: param);
      print(post);
    } catch (e) {
      print(e);
    }

  }

  void onCommitChange(BuildContext cont,String confirmStr) {
    _onKeyDown(cont,new KeyEvent(confirmStr));
  }

  void onOneChange(BuildContext cont) {
    _onKeyDown(cont,new KeyEvent("1"));
  }

  void onTwoChange(BuildContext cont) {
    _onKeyDown(cont,new KeyEvent("2"));
  }

  void onThreeChange(BuildContext cont) {
    _onKeyDown(cont,new KeyEvent("3"));
  }

  void onFourChange(BuildContext cont) {
    _onKeyDown(cont,new KeyEvent("4"));
  }

  void onFiveChange(BuildContext cont) {
    _onKeyDown(cont,new KeyEvent("5"));
  }

  void onSixChange(BuildContext cont) {
    _onKeyDown(cont,new KeyEvent("6"));
  }

  void onSevenChange(BuildContext cont) {
    _onKeyDown(cont,new KeyEvent("7"));
  }

  void onEightChange(BuildContext cont) {
    _onKeyDown(cont,new KeyEvent("8"));
  }

  void onNineChange(BuildContext cont) {
    _onKeyDown(cont,new KeyEvent("9"));
  }

  void onZeroChange(BuildContext cont) {
    _onKeyDown(cont,new KeyEvent("0"));
  }

  void onDotChange(BuildContext cont) {
    _onKeyDown(cont,new KeyEvent("."));
  }


  /// 点击删除
  void onDeleteChange(BuildContext cont) {
    _onKeyDown(cont,new KeyEvent("del"));
  }

  /// 点击今天
  void onDateChange(BuildContext cont) {
    _onKeyDown(cont,new KeyEvent("date"));
  }

  /// 点击加号
  void onAddChange(BuildContext cont) {
    _onKeyDown(cont,new KeyEvent("+"));
  }
  /// 点击减号
  void onMinusChange(BuildContext cont) {
    _onKeyDown(cont,new KeyEvent("-"));
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var _screenWidth = mediaQuery.size.width;

    // TODO: implement build
    return Container(
      key: _scaffoldKey,
      width: double.infinity,
      height: 300.0,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: 30.0,
            color: Colors.white,
            alignment: Alignment.center,
            child: Text(
              "下滑隐藏",
              style: TextStyle(fontSize: 12.0,color: Color(0xff999999)),
            ),
          ),
          Container(
            height: 40.0,
            width: _screenWidth,
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Container(
                  height: 40.0,
                  width: _screenWidth / 2,
                  child: TextField(
                    scrollPadding: const EdgeInsets.all(2.0),
                    decoration: InputDecoration(
                        icon: Icon(Icons.assignment_late),
                        hintText: "点击备注",
                        border: InputBorder.none
                    ),
                  ),
                ),
                Container(
                  height: 40.0,
                  width: _screenWidth / 2,
                  alignment: Alignment.center,
                  child: Text(moneyStr),
                )
              ],
            )
          ),
          ///  键盘主体
          Column(
            children: <Widget>[

              ///  第一行
              Row(
                children: <Widget>[
                  CustomKbBtn(
                      text: '1', callback: (val) => onOneChange(context)),
                  CustomKbBtn(
                      text: '2', callback: (val) => onTwoChange(context)),
                  CustomKbBtn(
                      text: '3', callback: (val) => onThreeChange(context)),
                  CustomKbBtn(
                    key: buttonStatekey,
                      text: dateStr,
                      size: size,
                      callback: (val) => onDateChange(context)),
                ],
              ),
              ///  第二行
              Row(
                children: <Widget>[
                  CustomKbBtn(
                      text: '4', callback: (val) => onFourChange(context)),
                  CustomKbBtn(
                      text: '5', callback: (val) => onFiveChange(context)),
                  CustomKbBtn(
                      text: '6', callback: (val) => onSixChange(context)),
                  CustomKbBtn(
                      text: '+', callback: (val) => onAddChange(context)),
                ],
              ),
              ///  第三行
              Row(
                children: <Widget>[
                  CustomKbBtn(
                      text: '7', callback: (val) => onSevenChange(context)),
                  CustomKbBtn(
                      text: '8', callback: (val) => onEightChange(context)),
                  CustomKbBtn(
                      text: '9', callback: (val) => onNineChange(context)),
                  CustomKbBtn(
                      text: '-', callback: (val) => onMinusChange(context)),
                ],
              ),
              ///  第四行
              new Row(
                children: <Widget>[
                  CustomKbBtn(
                      text: '.', callback: (val) => onDotChange(context)),
                  CustomKbBtn(
                      text: '0', callback: (val) => onZeroChange(context)),
                  CustomKbBtn(text: '删除', callback: (val) => onDeleteChange(context)),
                  CustomKbBtn(text: confirmStr, callback: (val) => onCommitChange(context,confirmStr)),
                ],
              ),

            ],
          )
        ],
      ),
    );
  }
}