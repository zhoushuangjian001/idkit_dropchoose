import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idkit_dropchoose/src/dropchoose_root.dart';

/// 菜单元素
typedef DropMenuItem<T> = Widget Function(T data, int index);

/// 菜单元素点击
typedef DorpMenuItemChick<T> = Function(T data);

/// 返回选择的内容
typedef DropMenuSelect<T> = String? Function(T data);

class DropChooseFunc {
  /// 计算绘制起点
  static Point getDrawStartPoint(
    BuildContext context,
    Rect rect,
    double dropMenuHeight,
    double offset,
  ) {
    late double dy;
    double topOffset = MediaQuery.of(context).viewPadding.top;
    Size screenSize = MediaQuery.of(context).size;
    double total = dropMenuHeight + offset;
    bool drowState = (screenSize.height - rect.bottom) >= total;
    if (drowState) {
      dy = rect.bottom + offset;
    } else {
      dy = rect.top - offset;
    }
    return Point(rect.left, dy - topOffset);
  }

  /// 获取当前组件的大小
  static Rect getRect(BuildContext context) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    Size size = renderBox.size;
    return offset & size;
  }

  /// 获取对应的组件
  static Widget? getDropMenuWidget<T>({
    required DropChooseType type,
    required DropMenuItem<T> itemForDropMenuAtIndexPath,
    SliverGridDelegate? gridDelegate,
    double cacheExtent = 5,
    Future<List<T>>? future,
    required DorpMenuItemChick<T> itemChick,
    Widget? errorPage,
    Widget? emptyPage,
    Widget? loadingPage,
  }) {
    late Widget _widget;
    switch (type) {
      case DropChooseType.list:
        _widget = FutureBuilder(
          future: future,
          initialData: <T>[],
          builder: (_, AsyncSnapshot<List<T>> asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting ||
                asyncSnapshot.connectionState == ConnectionState.none) {
              return loadingPage ?? DropChooseFunc.getLoaddingPage();
            } else if (asyncSnapshot.connectionState == ConnectionState.done) {
              List<T> list = asyncSnapshot.data!;
              if (list.isEmpty) {
                return emptyPage ?? DropChooseFunc.getEmptyPage();
              }
              return ListView.builder(
                itemBuilder: (_, index) {
                  T data = list[index];
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => itemChick(data),
                    child: itemForDropMenuAtIndexPath(data, index),
                  );
                },
                itemCount: list.length,
                cacheExtent: cacheExtent,
              );
            } else {
              return errorPage ?? DropChooseFunc.getErrorPage();
            }
          },
        );
        _widget = FutureBuilder(
          future: future,
          initialData: <T>[],
          builder: (_, AsyncSnapshot<List<T>> asyncSnapshot) {
            List<T> list = asyncSnapshot.data!;
            return ListView.builder(
              itemBuilder: (_, int index) {
                T data = list[index];
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => itemChick(data),
                  child: itemForDropMenuAtIndexPath(data, index),
                );
              },
              itemCount: list.length,
              cacheExtent: cacheExtent,
            );
          },
        );
        break;
      case DropChooseType.grid:
        _widget = FutureBuilder(
          future: future,
          initialData: <T>[],
          builder: (_, AsyncSnapshot<List<T>> asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting ||
                asyncSnapshot.connectionState == ConnectionState.none) {
              return loadingPage ?? DropChooseFunc.getLoaddingPage();
            } else if (asyncSnapshot.connectionState == ConnectionState.done) {
              List<T> list = asyncSnapshot.data!;
              if (list.isEmpty) {
                return emptyPage ?? DropChooseFunc.getEmptyPage();
              }
              return GridView.builder(
                gridDelegate: gridDelegate!,
                itemBuilder: (_, index) {
                  T data = list[index];
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => itemChick(data),
                    child: itemForDropMenuAtIndexPath(data, index),
                  );
                },
                itemCount: list.length,
                cacheExtent: cacheExtent,
              );
            } else {
              return errorPage ?? DropChooseFunc.getErrorPage();
            }
          },
        );
        break;
      default:
    }
    return _widget;
  }

  /// 空也面
  static Widget getEmptyPage() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        '暂无数据',
        style: TextStyle(
          fontSize: 20,
          color: Color(0xff666666),
        ),
      ),
    );
  }

  /// 错误页面
  static Widget getErrorPage() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        '加载失败',
        style: TextStyle(
          fontSize: 20,
          color: Color(0xff666666),
        ),
      ),
    );
  }

  /// 错误页面
  static Widget getLoaddingPage() {
    return Container(
      alignment: Alignment.center,
      child: CupertinoActivityIndicator(),
    );
  }
}
