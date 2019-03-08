import 'package:flutter/material.dart';
import 'package:record_app/src/keyBoard/custom_keyboard_button.dart';
import 'package:record_app/src/keyBoard/pay_password.dart';


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
  /// 定义 确定 按钮 接口  暴露给调用方
  String moneyStr = "";
  double money = 0;

  ///回调函数
  void _onKeyDown(KeyEvent data){

    if(data.key == "date"){
      showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime.now().subtract(new Duration(days: 30)), // 减 30 天
        lastDate: new DateTime.now().add(new Duration(days: 30)),       // 加 30 天
      ).then((DateTime val) {
        print(val);   // 2018-07-12 00:00:00.000
        buttonStatekey.currentState.widget.text = val.year.toString();
        setState(() {
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
        moneyStr = money.toString() + "+";
      }
    }

    if (moneyStr.contains("-") && !moneyStr.endsWith("-")){

      if (data.key == "+" || data.key == "-" || data.key == "=") {
        List<String> split = moneyStr.split("-");
        double a = double.parse(split[0]);
        double b = double.parse(split[1]);
        money = a - b;
        moneyStr = money.toString() + "-";
      }
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
//      onAffirmButton();
    }
    setState(() {});
  }

  void onCommitChange() {
    _onKeyDown(new KeyEvent("commit"));
  }

  void onOneChange(BuildContext cont) {
    _onKeyDown(new KeyEvent("1"));
  }

  void onTwoChange(BuildContext cont) {
    _onKeyDown(new KeyEvent("2"));
  }

  void onThreeChange(BuildContext cont) {
    _onKeyDown(new KeyEvent("3"));
  }

  void onFourChange(BuildContext cont) {
    _onKeyDown(new KeyEvent("4"));
  }

  void onFiveChange(BuildContext cont) {
    _onKeyDown(new KeyEvent("5"));
  }

  void onSixChange(BuildContext cont) {
    _onKeyDown(new KeyEvent("6"));
  }

  void onSevenChange(BuildContext cont) {
    _onKeyDown(new KeyEvent("7"));
  }

  void onEightChange(BuildContext cont) {
    _onKeyDown(new KeyEvent("8"));
  }

  void onNineChange(BuildContext cont) {
    _onKeyDown(new KeyEvent("9"));
  }

  void onZeroChange(BuildContext cont) {
    _onKeyDown(new KeyEvent("0"));
  }

  void onDotChange(BuildContext cont) {
    _onKeyDown(new KeyEvent("."));
  }


  /// 点击删除
  void onDeleteChange() {
    _onKeyDown(new KeyEvent("del"));
  }

  /// 点击今天
  void onDateChange() {
    _onKeyDown(new KeyEvent("date"));
  }

  /// 点击加号
  void onAddChange() {
    _onKeyDown(new KeyEvent("+"));
  }
  /// 点击减号
  void onMinusChange() {
    _onKeyDown(new KeyEvent("-"));
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
                      text: '今天', callback: (val) => onDateChange()),
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
                      text: '+', callback: (val) => onAddChange()),
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
                      text: '-', callback: (val) => onMinusChange()),
                ],
              ),
              ///  第四行
              new Row(
                children: <Widget>[
                  CustomKbBtn(
                      text: '.', callback: (val) => onDotChange(context)),
                  CustomKbBtn(
                      text: '0', callback: (val) => onZeroChange(context)),
                  CustomKbBtn(text: '删除', callback: (val) => onDeleteChange()),
                  CustomKbBtn(text: '确定', callback: (val) => onCommitChange()),
                ],
              ),

            ],
          )
        ],
      ),
    );
  }
}