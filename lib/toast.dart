import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast({String? message, Color? bgColor}){
  Fluttertoast.showToast(
      msg: message ?? 'An has error occurred.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: bgColor ?? Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
  );
}