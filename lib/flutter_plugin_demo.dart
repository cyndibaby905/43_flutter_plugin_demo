import 'dart:async';

import 'package:flutter/services.dart';
import 'dart:convert';

class FlutterPluginDemo {
  static const MethodChannel _channel =
      const MethodChannel('flutter_plugin_demo');


  static String getSymbolName(Symbol symbol) {
    String string = symbol.toString();
    return string.substring(8, string.length - 2);
  }

  static Future<dynamic> methodTemplate(String methodName, List<dynamic> params) async {
    print(params);
    dynamic result = await _channel.invokeMethod("invoke", {
      "method": methodName,
      "params": params,
    });
    return result;
  }

  @override
  Future<dynamic> noSuchMethod(Invocation invocation) {
    String methodName = getSymbolName(invocation.memberName);

    dynamic args = invocation.positionalArguments;
    print('methodName:$methodName');
    print('args:$args');
    return methodTemplate(methodName, args);
  }

  Future<dynamic> platformVersion();

  Future<dynamic> openAppStore(appid);

}
