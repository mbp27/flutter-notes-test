import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  static const String routeName = '/loading';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.3),
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(20.0),
            child: Platform.isIOS
                ? const CupertinoActivityIndicator()
                : const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
