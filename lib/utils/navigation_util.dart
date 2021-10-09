import 'package:flutter/material.dart';

class NavigationUtil{

  static gotoPage(BuildContext context,StatefulWidget widget){
    Navigator.push(context,MaterialPageRoute(builder: (context) => widget));
  }

  static goToPageWithoutStack(BuildContext context,StatefulWidget widget) async {
    _clearStack(context);
    await Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => widget));
  }

  static _clearStack(BuildContext context){
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}