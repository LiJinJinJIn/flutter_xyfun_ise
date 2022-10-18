import 'dart:async';
import 'package:flutter/services.dart';
import 'bean/ise_param.dart';

//返回结果监听处理
typedef OnResultListener = void Function(String result);

//返回错误信息检讨
typedef OnErrorListener = void Function(String error);

class FlutterXfyunIse {
  static FlutterXfyunIse get instance => _instance;
  final MethodChannel _channel;
  static late OnResultListener _onResultListener;
  static late OnErrorListener _onErrorListener;

  static final FlutterXfyunIse _instance = FlutterXfyunIse.private(const MethodChannel('flutter_xfyun_ise'));

  FlutterXfyunIse.private(MethodChannel channel) : _channel = channel {
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  ///设置回调
  Future _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case "onResultListener":
        _onResultListener(call.arguments);
        break;
      case "onErrorListener":
        _onErrorListener(call.arguments);
        break;
      default:
        break;
    }
  }

  ///设置评测结果回调
  void setOnResultListener(OnResultListener onResultListener) => _onResultListener = onResultListener;

  ///设置错误信息回调
  void setOnErrorListener(OnErrorListener onErrorListener) => _onErrorListener = onErrorListener;

  ///初始化操作
  Future<void> init({required String appid}) async {
    await _channel.invokeMethod('init', <String, dynamic>{'appid': appid});
  }

  ///设置数据参数操作
  Future<void> setParameter({required IseParam param}) async {
    await _channel.invokeMethod('setParameter', <String, dynamic>{'param': param.toMap()});
  }

  ///开始评测
  Future<void> start({required String content}) async {
    await _channel.invokeMethod('start', <String, dynamic>{'content': content});
  }

  ///停止评测
  Future<void> stop() async {
    await _channel.invokeMethod('stop');
  }

  ///取消评测
  Future<void> cancel() async {
    await _channel.invokeMethod('cancel');
  }

  ///释放资源
  Future<void> destroy() async {
    await _channel.invokeMethod('destroy');
  }

  ///结果解析
  Future<void> resultsParsing() async {
    await _channel.invokeMethod('resultsParsing');
  }
}
