import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:idkit_dropchoose/src/dropchoose_func.dart';

class DropChoose<T> extends StatefulWidget {
  DropChoose({
    Key? key,
    this.isExpand = false,
    this.isWholeEnable = false,
    this.placeholder,
    this.placeholderStyle,
    this.offset = 10,
    this.dorpMenuHeight = 120,
    required this.itemForDropMenuAtIndexPath,
    required this.type,
    this.gridDelegate,
    this.dropMenuDecoration,
    this.dropMenuPadding,
    this.future,
    this.didItemSelect,
    this.dropChooseDecoration,
    this.dropChooseMargin,
    this.dropChoosePadding,
    this.dropChooseHeight,
    this.arrowColor,
    this.arrowSize,
    this.interval,
    this.dropMenuEmpty,
    this.dropMenuError,
    this.dropMenuLoading,
    this.dropChooseStyle,
  }) : super(key: key);

  /// 组件元素是否满充父组件, 默认值: false
  final bool isExpand;

  /// 整体是否可以点击，默认值: false
  final bool isWholeEnable;

  /// 提示选择语
  final String? placeholder;

  /// 提示选择语样式
  final TextStyle? placeholderStyle;

  /// 弹出菜单的偏移
  final double offset;

  /// 弹出菜单的高度
  final double dorpMenuHeight;

  // /// 获取弹出菜单子元素
  final DropMenuItem<T> itemForDropMenuAtIndexPath;

  /// 弹出菜单的形式
  final DropChooseType type;

  /// 弹出菜单为 Grid 是的 delegate
  final SliverGridDelegate? gridDelegate;

  /// 弹出菜单的样式
  final Decoration? dropMenuDecoration;

  /// 选择器的样式
  final Decoration? dropChooseDecoration;

  /// 弹出菜单的内边距
  final EdgeInsetsGeometry? dropMenuPadding;

  /// 展示弹出菜单数据
  final Future<List<T>>? future;

  /// 返回选择的内容
  final DropMenuSelect<T>? didItemSelect;

  /// 选择器的外边距
  final EdgeInsetsGeometry? dropChooseMargin;

  /// 选择器的内边距
  final EdgeInsetsGeometry? dropChoosePadding;

  /// 选择器的高度
  final double? dropChooseHeight;

  /// 箭头颜色
  final Color? arrowColor;

  /// 箭头大小
  final double? arrowSize;

  /// 展示和箭头的间隔
  final double? interval;

  /// 弹出菜单无数据
  final Widget? dropMenuEmpty;

  /// 弹出菜单数据错误
  final Widget? dropMenuError;

  /// 弹出菜单数据加载中
  final Widget? dropMenuLoading;

  /// 选择器文本样式
  final TextStyle? dropChooseStyle;

  @override
  _DropChooseState createState() => _DropChooseState<T>();
}

class _DropChooseState<T> extends State<DropChoose<T>> with DropChooseFunc {
  // 按钮点击控制订阅者
  late StreamController<bool> _buttonStreamController =
      StreamController<bool>();

  // 选择内容订阅者
  late StreamController<String> _selecdStreamController =
      StreamController<String>();

  // 下拉菜单的状态
  late bool isDropMenuState = false;

  // 是否已经选择
  late bool isSelecd = false;

  // 是否扩展动态获取的组件
  late Widget child;

  @override
  void initState() {
    child = Material(
      color: Colors.transparent,
      child: StreamBuilder(
        stream: _selecdStreamController.stream,
        builder: (_, AsyncSnapshot<String> asyncSnapshot) {
          if (asyncSnapshot.hasData) {
            return Text(
              asyncSnapshot.data!,
              style: widget.dropChooseStyle,
            );
          } else {
            return Text(
              widget.placeholder ?? '请选择',
              style: widget.placeholderStyle ??
                  TextStyle(
                    color: Color(0xff999999),
                    fontSize: 18,
                  ),
            );
          }
        },
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        margin: widget.dropChooseMargin,
        padding: widget.dropChoosePadding,
        decoration: widget.dropChooseDecoration,
        height: widget.dropChooseHeight,
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.isExpand ? Expanded(child: child) : child,
            SizedBox(width: widget.interval ?? 5),
            StreamBuilder(
              stream: _buttonStreamController.stream,
              initialData: false,
              builder: (_, AsyncSnapshot<bool> asyncSnapshot) {
                double _angle = asyncSnapshot.data! ? pi * 0.5 : 0;
                return GestureDetector(
                  child: Transform.rotate(
                    angle: _angle,
                    child: Icon(
                      Icons.chevron_right,
                      color: widget.arrowColor,
                      size: widget.arrowSize,
                    ),
                  ),
                  onTap: _showDropMenu,
                );
              },
            ),
          ],
        ),
      ),
      onTap: widget.isWholeEnable ? _showDropMenu : null,
    );
  }

  /// 展开菜单
  void _showDropMenu() {
    isDropMenuState = !isDropMenuState;
    _buttonStreamController.add(isDropMenuState);
    Rect rect = DropChooseFunc.getRect(context);
    Point point = DropChooseFunc.getDrawStartPoint(
        context, rect, widget.dorpMenuHeight, widget.offset);
    showDialog(
      barrierColor: Colors.transparent,
      barrierDismissible: false, // 个别手机不生效
      context: context,
      useSafeArea: false,
      builder: (_) {
        return Material(
          color: Colors.transparent,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Navigator.pop(context),
            child: Stack(
              children: [
                Positioned(
                  left: point.x.toDouble(),
                  top: point.y.toDouble(),
                  child: Container(
                    padding: widget.dropMenuPadding,
                    decoration: widget.dropMenuDecoration,
                    height: widget.dorpMenuHeight,
                    width: rect.size.width,
                    child: DropChooseFunc.getDropMenuWidget<T>(
                      type: widget.type,
                      gridDelegate: widget.gridDelegate,
                      itemForDropMenuAtIndexPath:
                          widget.itemForDropMenuAtIndexPath,
                      future: widget.future,
                      emptyPage: widget.dropMenuEmpty,
                      errorPage: widget.dropMenuError,
                      loadingPage: widget.dropMenuLoading,
                      itemChick: (T data) {
                        if (widget.didItemSelect != null) {
                          String? content = widget.didItemSelect!(data);
                          _selecdStreamController
                              .add(content ?? widget.placeholder ?? '');
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    ).then((value) {
      isDropMenuState = false;
      _buttonStreamController.add(isDropMenuState);
    });
  }

  /// 销毁
  @override
  void dispose() {
    _buttonStreamController.close();
    _selecdStreamController.close();
    super.dispose();
  }
}

/// 下拉弹框类型
enum DropChooseType {
  list,
  grid,
  custom,
}
