import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:record_app/src/dateTime/flutter_datetime_picker.dart';




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
                  YearMonth(),
                  Container(
                    padding: const EdgeInsets.only(left: 60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(bottom: 7,top: 7),
                          width: 100,
                          child: Text(
                            '收入',
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 7),
                          width: 100,
                          child: Text(
                            '11111111',
                            textAlign: TextAlign.left,),
                        )
                      ],
                    ),
                  ),
                 Container(
                   padding: const EdgeInsets.only(left: 60),
                   child: Column(
                     children: <Widget>[
                       Container(
                         padding: const EdgeInsets.only(bottom: 7,top: 7),
                         width: 100,
                         child: Text('支出',
                             textAlign: TextAlign.left),
                       ),
                       Container(
                         padding: const EdgeInsets.only(bottom: 7),
                         width: 100,
                         child: Text('222222',
                             textAlign: TextAlign.left),
                       )
                     ],
                   ),
                 ),



                ],

              ),
              preferredSize: Size(11, 11)
          ),
        ),
        preferredSize: Size.fromHeight(100)
      ),
      body: recordList()
    );

  }

}




//详情组件
class RecordDetail extends StatelessWidget{
  String path;  //图片地址
  String name; //名字
  int amount; //金额
  String statistics; //统计字符串

  RecordDetail({Key key, this.path,this.name , this.amount,this.statistics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color:  Colors.white70,
            border: Border.all(color: Colors.white,width: 1.0),
            borderRadius: BorderRadius.circular(200.0),
          ),
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.all(10.0),
          child: Image(
            alignment: Alignment.centerLeft,
            image: AssetImage('lib/src/images/' + path),
          ),
        ),
        Container(
          child: Text(
            name,
            style: TextStyle(fontSize: 18),

          ),
          padding: const EdgeInsets.all(7),
        ),
        Expanded(
          child:Container(
            child: Text(statistics,textAlign: TextAlign.end,style: TextStyle(fontSize: 18),),
            padding: const EdgeInsets.all(7),
          ),)
      ],
    );
  }

}

//获取单条数据详情
List<Widget> _getRecordDetail(List recordDetail){

  List<Widget> list = List();
  var length = recordDetail.length; //总数

  for (int i = 0;i < recordDetail.length;i++) {
    Map val = recordDetail[i] as Map;
    String Path = val['Path'];  //地址
    String Name = val['Name'] == null ? "" :val['Name'];  //名称
    int Amount = val['Amount'];  //金额
    String AmountType = val['AmountType'];  //类型

    String type = '';
    if ( AmountType == '12') {
      type = Amount.toString();

    }else{
      type = "-" + Amount.toString();
    }

    list.add(RecordDetail(
      path: Path,
      name: Name,
      amount: Amount,
      statistics: type,
    ));

    //增加短线
    if (i < (length -1)) {
      list.add(Row(
        children: <Widget>[
          Container(
            width: 70,
            height: 7,
          ),
          Container(width: 330, height: 2.0, color: Color(0xFFF3F3F3),),
        ],
      ));

    }

  }

  return list;
}



//获取单条数据
Widget getrecord(List records){

  String Weekstr = '';
  String Mothstr = '';
  num expendTotal = 0;  //支出总金额
  num incomeTotal = 0;  //收入总金额
  String statistics = ''; // 统计字符串
  for(var val in records){
    if (val['Weekstr'] != null) {
      Weekstr = val['Weekstr'];  //星期几
    }

    Mothstr = val['Mothstr'];  //年月
    num Amount = val['Amount'];  //金额
    String AmountType = val['AmountType'];  //类型

    String type = '支出';
    if ( AmountType == '12') {
      type = '收入';
      incomeTotal += Amount;
    }else{
      expendTotal += Amount;
    }

  }

  if (expendTotal != 0) {
    statistics += "支出: " + expendTotal.toString();
  }
  if (incomeTotal != 0) {
    statistics += " 支出: " + incomeTotal.toString();
  }

  List<Widget> list = List();
  list.add(
      Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(7),
            child: Text(Mothstr),
          ),
          Container(
            padding: const EdgeInsets.all(7),
            child: Text(Weekstr),
          ),
          Expanded(
              child: Container(
                padding: const EdgeInsets.all(7),
                child: Text(statistics,textAlign: TextAlign.end,),
              )),
        ],
      )
  );
  list.add(
    Container(width: double.infinity, height: 2.0, color: Color(0xFFF3F3F3),),
  );
  list.addAll(_getRecordDetail(records));

  return Column(
    children: list,
  );

}

//列表
class recordList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return recordListState();
  }

}

class recordListState extends State<recordList>{

  //存放数据
  List records;
  bool isLoad = false;  //是否加载完毕
  @override
  void initState(){

    //默认年月
    DateTime now = new DateTime.now();
    String _yearMonth = now.year.toString() + "-" + now.month.toString();

    getRecordList(_yearMonth).then((val){

      if (!mounted) {
        return;
      }

      setState(() {

        records = val['data'] as List;
        isLoad = true;

      });
    });

  }

  @override
  Widget build(BuildContext context) {
    //获取收入列表
    if (!isLoad) {
      return getLoading();
    }

    return  ListView.builder(
        itemCount: records.length,
        itemBuilder: (BuildContext context,int index){

          Map record =  new Map<String, dynamic>.from(records[index]);

          List list ;
          record.forEach((key,value){
            list = value;
          });

          return getrecord(list);

        }
    );

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


//获取记录列表
Future getRecordList(String month) async{
  try {
    Response response;
    Dio dio = new Dio();
    dio.options.baseUrl = "http://118.24.61.197:8081";
    response = await dio.post("/record/getRecord");
    return response.data;
  } catch (e) {
    print(e);
  }

}



//自定义年月组件
class  YearMonth extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return YearMonthState();
  }

}

class YearMonthState extends State<YearMonth>{

  //默认年月
  static DateTime now = new DateTime.now();
  String _yearMonth = now.year.toString() + "-" + now.month.toString();
  String _year = now.year.toString() + '年';
  String _month = now.month.toString() + '月';

  //获取年月
  void _getYearMonth(){

    DatePicker.showYearOrMouthOrDayPicker(context,
      showTitleActions: true,
      onChanged: (val){
        setState(() {
          _yearMonth = val.year.toString() + "-" + val.month.toString();
          _year = val.year.toString() + '年' ;
          _month = val.month.toString() + '月';
        });
      },
      onConfirm: (val){
        setState(() {
          _yearMonth = val.year.toString() + "-" + val.month.toString();
          _year = val.year.toString() + '年' ;
          _month = val.month.toString() + '月';
        });
      },

      locale: LocaleType.zh,
      dateType: DateType.YEAR_MOUTH

    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: _getYearMonth ,
      child: Container(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          children: <Widget>[
            Container(
              child: Text(_year),
              padding: const EdgeInsets.all(7),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                children: <Widget>[
                  Text(_month),
                  Text(' ▼|')
                ],
              ),
            )
          ],
        ),
      ),

    );
  }

}

