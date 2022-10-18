import 'package:flutter/material.dart';
import 'package:flutter_xfyun_ise/bean/ise_param.dart';
import 'package:flutter_xfyun_ise/flutter_xfyun_ise.dart';
import 'package:flutter_xfyun_ise_example/audio/AudioPlayerManager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ///测试内容文本
  var content = "一座座雪峰插入云霄，峰顶银光闪闪，大大小小的湖泊，像颗颗宝石镶嵌在彩带般的沟谷中。";
  var _score = "暂无评分";
  var _path = "";

  @override
  void initState() {
    super.initState();
    initPlatformState();
    setListener();
  }

  //设置监听处理
  void setListener() {
    FlutterXfyunIse.instance.setOnErrorListener((error) {
      print("****************************");
      print("错误信息：    ${error}");
      print("****************************");
    });
    FlutterXfyunIse.instance.setOnResultListener((score) {
      print("****************************");
      print("回调信息：    ${score}");
      setState(() {
        _score = score;
      });
      print("****************************");
    });
  }

  Future<void> setIseParameter() async {
    var dir = await getTemporaryDirectory();
    _path = "${dir.path}/${111222}.wav";
    //设置参数
    FlutterXfyunIse.instance.setParameter(
      param: IseParam()
        ..language = "zh_cn"
        ..category = "read_sentence"
        ..resultLevel = "complete"
        ..vadBos = "5000"
        ..vadEos = "1800"
        ..speechTimeout = "-1"
        ..subject = "ise"
        ..plev = "0"
        ..iseUnite = "1"
        ..rst = "entirety"
        ..extraAbility = "syll_phone_err_msg;pitch;multi_dimension"
        ..textEncoding = "utf-8"
        ..aue = "opus"
        ..audioFormat = "wav"
        ..iseAudioPath = "$_path",
    );
    print("setIseParameter  路径展示 :        ${_path}");
  }

  Future<void> initPlatformState() async {
    FlutterXfyunIse.instance.init(appid: "269d43b0");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('讯飞语音测评')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text("上次评分：       $_score"),
              Container(width: 200, height: 10, color: Colors.green, margin: EdgeInsets.only(top: 20, bottom: 20)),
              Text("测试数据：       $content"),
              SizedBox(height: 100),
              InkWell(
                child: Container(
                  width: 100,
                  height: 50,
                  color: Colors.red,
                  alignment: Alignment.center,
                  child: Text("开始测评"),
                ),
                onTap: () {
                  setIseParameter();
                  FlutterXfyunIse.instance.start(content: content);
                },
              ),
              InkWell(
                child: Container(
                  width: 100,
                  height: 50,
                  color: Colors.red,
                  alignment: Alignment.center,
                  child: Text("停止测评"),
                ),
                onTap: () {
                  FlutterXfyunIse.instance.stop();
                },
              ),
              InkWell(
                child: Container(
                  width: 100,
                  height: 50,
                  color: Colors.red,
                  alignment: Alignment.center,
                  child: Text("取消测评"),
                ),
                onTap: () {
                  FlutterXfyunIse.instance.cancel();
                },
              ),
              InkWell(
                child: Container(
                  width: 100,
                  height: 50,
                  color: Colors.red,
                  alignment: Alignment.center,
                  child: Text("结果解析"),
                ),
                onTap: () {
                  //结果解析
                  FlutterXfyunIse.instance.resultsParsing();
                },
              ),
              InkWell(
                child: Container(
                  width: 100,
                  height: 50,
                  color: Colors.red,
                  alignment: Alignment.center,
                  child: Text("播放录音音频"),
                ),
                onTap: () async {
                  AudioPlayerManager.instance.play(_path);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
