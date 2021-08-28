import 'package:flutter/material.dart';
import 'package:idkit_dropchoose/src/dropchoose_func.dart';
import 'package:idkit_dropchoose/src/dropchoose_root.dart';

/// 下拉选择组件
class IDKitDropChoose<T> extends DropChoose<T> {
  /// 下拉弹出是 ListView
  IDKitDropChoose.listBuilder({
    Key? key,
    Future<List<T>>? future,
    required DropMenuItem<T> itemForDropMenuAtIndexPath,
    DropMenuSelect<T>? didItemSelect,
    bool isExpand = false,
    bool isWholeEnable = false,
    String? placeholder,
    TextStyle? placeholderStyle,
    double offset = 10,
    double dorpMenuHeight = 120,
    Decoration? dropMenuDecoration,
    Decoration? dropChooseDecoration,
    EdgeInsetsGeometry? dropMenuPadding,
    EdgeInsetsGeometry? dropChooseMargin,
    EdgeInsetsGeometry? dropChoosePadding,
    double? dropChooseHeight,
    Color? arrowColor,
    double? arrowSize,
    double? interval,
    Widget? dropMenuError,
    Widget? dropMenuEmpty,
    Widget? dropMenuLoading,
  }) : super(
          key: key,
          isExpand: isExpand,
          isWholeEnable: isWholeEnable,
          placeholder: placeholder,
          placeholderStyle: placeholderStyle,
          offset: offset,
          dorpMenuHeight: dorpMenuHeight,
          itemForDropMenuAtIndexPath: itemForDropMenuAtIndexPath,
          type: DropChooseType.list,
          dropMenuDecoration: dropMenuDecoration,
          dropMenuPadding: dropMenuPadding,
          future: future,
          didItemSelect: didItemSelect,
          dropChooseDecoration: dropChooseDecoration,
          dropChooseHeight: dropChooseHeight,
          dropChooseMargin: dropChooseMargin,
          dropChoosePadding: dropChoosePadding,
          arrowColor: arrowColor,
          arrowSize: arrowSize,
          dropMenuEmpty: dropMenuEmpty,
          dropMenuError: dropMenuError,
          dropMenuLoading: dropMenuLoading,
        );

  /// 下拉弹出是 GridView
  IDKitDropChoose.gridBuilder({
    Key? key,
    Future<List<T>>? future,
    DropMenuSelect<T>? didItemSelect,
    required SliverGridDelegate gridDelegate,
    required DropMenuItem<T> itemForDropMenuAtIndexPath,
    bool isExpand = false,
    bool isWholeEnable = false,
    String? placeholder,
    TextStyle? placeholderStyle,
    double offset = 10,
    double dorpMenuHeight = 120,

    /// 组件元素是否满充父组件, 默认值: false
    Decoration? dropMenuDecoration,
    Decoration? dropChooseDecoration,
    EdgeInsetsGeometry? dropMenuPadding,
    EdgeInsetsGeometry? dropChooseMargin,
    EdgeInsetsGeometry? dropChoosePadding,
    double? dropChooseHeight,
    Color? arrowColor,
    double? arrowSize,
    double? interval,
    Widget? dropMenuError,
    Widget? dropMenuEmpty,
    Widget? dropMenuLoading,
  }) : super(
          key: key,
          isExpand: isExpand,
          isWholeEnable: isWholeEnable,
          placeholder: placeholder,
          placeholderStyle: placeholderStyle,
          offset: offset,
          dorpMenuHeight: dorpMenuHeight,
          gridDelegate: gridDelegate,
          itemForDropMenuAtIndexPath: itemForDropMenuAtIndexPath,
          type: DropChooseType.grid,
          dropMenuDecoration: dropMenuDecoration,
          dropMenuPadding: dropMenuPadding,
          future: future,
          didItemSelect: didItemSelect,
          dropChooseDecoration: dropChooseDecoration,
          dropChooseHeight: dropChooseHeight,
          dropChooseMargin: dropChooseMargin,
          dropChoosePadding: dropChoosePadding,
          arrowColor: arrowColor,
          arrowSize: arrowSize,
          dropMenuEmpty: dropMenuEmpty,
          dropMenuError: dropMenuError,
          dropMenuLoading: dropMenuLoading,
        );
}

/// 仿照数据
class DropModel<T> {
  DropModel({
    this.model,
    this.dropState = false,
  });
  final T? model;
  bool dropState;
}
