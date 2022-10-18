/// ise参数类
class IseParam {
  // 语言
  String? language;
  // 评测类型
  String? category;

  // 测试项目类型
  String? subject;

  // 设置录取音频最长时间。在听写、识别和声纹等需要录入音频的业务下。当录音超过这个时间，SDK会自动结束录音。
  String? speechTimeout;

  // 评测结果等级
  String? resultLevel;

  // 图像压缩格式，现在引擎不支持图像压缩，aue只能取值raw
  String? aue;

  // 音频格式
  String? audioFormat;

  // 评测录音保存路径
  String? iseAudioPath;

  // 输入文本编码格式
  String? textEncoding;

  // VAD前端点超时
  String? vadBos;

  // VAD后端点超时
  String? vadEos;

  //设置评分百分制 使用 ise_unite  rst  extra_ability 参数
  String? extraAbility;
  String? rst;
  String? iseUnite;

  //设置流式版本所需参数 : ent sub plev
  String? plev;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> param = {
      'language': language,
      'extra_ability': extraAbility,
      'ise_unite': iseUnite,
      'rst': rst,
      'category': category,
      'subject': subject,
      'speech_timeout': speechTimeout,
      'result_level': resultLevel,
      'aue': aue,
      'audio_format': audioFormat,
      'ise_audio_path': iseAudioPath,
      'text_encoding': textEncoding,
      'vad_bos': vadBos,
      'vad_eos': vadEos,
      'plev': plev,
    };
    // ignore: prefer_function_declarations_over_variables
    final isNull = (key, value) {
      return value == null;
    };
    param.removeWhere(isNull);
    return param;
  }
}
