import 'dart:async';

import 'package:flutter/material.dart';
import 'package:idkit_dropchoose/idkit_dropchoose.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String sl = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 40, top: 120),
      alignment: Alignment.center,
      child: Center(
        child: Column(
          children: [
            IDKitDropChoose.listBuilder(
              future: Future(() {
                return ['老大', '老鹅', '小王'];
              }),
              itemForDropMenuAtIndexPath: (String d, index) {
                return SizedBox(
                  child: Text(d),
                  height: 40,
                );
              },
              placeholder: '请选择亲友',
              dorpMenuHeight: 200,
              didItemSelect: (String d) {
                return d;
              },
              dropChooseDecoration: BoxDecoration(
                color: Colors.red,
              ),
              dropMenuDecoration: BoxDecoration(
                color: Colors.pink,
              ),
            ),
            SizedBox(
              height: 60,
            ),
            IDKitDropChoose<int>.gridBuilder(
              future: Future.delayed(Duration(seconds: 6), () {
                return [1, 2, 3, 3, 4];
              }),
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemForDropMenuAtIndexPath: (d, index) {
                return SizedBox(
                  child: Text('测试'),
                  height: 40,
                );
              },
              didItemSelect: (int s) => s.toString(),
              dropMenuDecoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(10),
              ),
              dropMenuPadding: EdgeInsets.all(40),
              isExpand: true,
              isWholeEnable: true,
            ),
            SizedBox(
              height: 60,
            ),
            IDKitDropChoose.gridBuilder(
              future: Future.delayed(Duration(seconds: 6), () {
                return ['大哥', '星弟', '小米', '大米', '中米']
                    .map((e) => ItemModel(e, false))
                    .toList();
              }),
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemForDropMenuAtIndexPath: (ItemModel d, index) {
                d.state = d.name == sl;

                return Container(
                  color: d.state ? Colors.pink : Colors.green,
                  child: SizedBox(
                    child: Text(
                      d.name,
                    ),
                    height: 40,
                  ),
                );
              },
              didItemSelect: (ItemModel s) {
                s.state = true;
                sl = s.name;
                return s.name;
              },
              dropMenuDecoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(10),
              ),
              dropMenuPadding: EdgeInsets.all(40),
              isExpand: true,
              isWholeEnable: true,
            )
          ],
        ),
      ),
    );
  }
}

class ItemModel {
  final String name;
  bool state;

  ItemModel(this.name, this.state);
}
