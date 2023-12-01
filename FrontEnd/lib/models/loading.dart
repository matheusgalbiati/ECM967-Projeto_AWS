import 'package:flutter/material.dart';

class LoadingDialog {
  void showMyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator(color: Color.fromRGBO(152, 218, 217, 1),));
      },
    );
  }
}