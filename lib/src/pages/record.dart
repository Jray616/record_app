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
                    height: 200.0,
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

class IconList extends StatelessWidget{

  final List<String> items;
  IconList({Key key,@required this.items}):super(key:key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing:2.0,  //纵轴间距
          crossAxisSpacing: 2.0,
          childAspectRatio: 1
      ),
      children: <Widget>[

      ],
    )
    ;
  }

}