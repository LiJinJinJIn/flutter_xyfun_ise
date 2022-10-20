import 'package:audioplayers/audioplayers.dart';

///音频播放管理
class AudioPlayerManager {
  factory AudioPlayerManager() => _getInstance();

  static AudioPlayerManager get instance => _getInstance();
  static AudioPlayerManager? _instance;
  AudioPlayer? _audioPlayer;

  // 获取单利模式
  static AudioPlayerManager _getInstance() {
    if (_instance == null) {
      _instance = new AudioPlayerManager._internal();
    }
    return _instance!;
  }

  AudioPlayerManager._internal() {
    if (_audioPlayer == null) {
      _audioPlayer = AudioPlayer();
    }
  }

  //播放视频
  void playToFile(String filePath) {
    var result = _audioPlayer?.play(DeviceFileSource(filePath));
    if (result == 1) {
      print('pause success');
    } else {
      print('pause failed');
    }
  }

  //播放视频
  void playToUrl(String url) {
    var result = _audioPlayer?.play(UrlSource(url));
    if (result == 1) {
      print('pause success');
    } else {
      print('pause failed');
    }
  }

  //不可见时暂停播放
  void pause() {
    _audioPlayer?.pause();
  }

  //停止播放
  void stop() {
    _audioPlayer?.stop();
  }

  //可见时恢复播放
  void resume() {
    _audioPlayer?.resume();
  }

  //释放资源
  void release() {
    _audioPlayer?.release();
  }
}
