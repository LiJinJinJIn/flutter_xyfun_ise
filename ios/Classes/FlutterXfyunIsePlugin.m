#import "FlutterXfyunIsePlugin.h"
#if __has_include(<flutter_xfyun_ise/flutter_xfyun_ise-Swift.h>)
#import <flutter_xfyun_ise/flutter_xfyun_ise-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_xfyun_ise-Swift.h"
#endif

#import <iflyMSC/iflyMSC.h>
#import "ise/Results/ISEResultXmlParser.h"
#import "ise/Results/ISEResult.h"

@interface FlutterXfyunIsePlugin() <IFlySpeechEvaluatorDelegate, ISEResultXmlParserDelegate>

@property (nonatomic, strong) IFlySpeechEvaluator *iFlySpeechEvaluator;
@property (nonatomic, strong) FlutterMethodChannel *channel;
@property (nonatomic, strong) ISEResultXmlParser *resultParser;
@property (nonatomic, strong) NSString *resultStr;

@end

@implementation FlutterXfyunIsePlugin

- (id)initWithChannel:(FlutterMethodChannel*)channel {
    if (self = [super init]) {
        self.channel = channel;
    }
    return self;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_xfyun_ise"
            binaryMessenger:[registrar messenger]];
    FlutterXfyunIsePlugin* instance = [[FlutterXfyunIsePlugin alloc] initWithChannel:channel];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"init" isEqualToString:call.method]) {
        [self initXFyun:call];
    } else if ([@"setParameter" isEqualToString:call.method]) {
        [self setParameter:call];
    } else if ([@"start" isEqualToString:call.method]) {
        [self start:call];
    } else if ([@"stop" isEqualToString:call.method]) {
        [self stop];
    } else if ([@"cancel" isEqualToString:call.method]) {
        [self cancel];
    } else if ([@"destroy" isEqualToString:call.method]) {
        [self destroy];
    } else if ([@"resultsParsing" isEqualToString:call.method]) {
        [self resultsParsing];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)initXFyun:(FlutterMethodCall *)call {
    NSString *appId = [call.arguments valueForKey:@"appid"];
    //Appid是应用的身份信息，具有唯一性，初始化时必须要传入Appid。
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@", appId];
    [IFlySpeechUtility createUtility:initString];
    
    self.iFlySpeechEvaluator = [IFlySpeechEvaluator sharedInstance];
    self.iFlySpeechEvaluator.delegate = self;
    
    self.resultParser = [[ISEResultXmlParser alloc] init];
    self.resultParser.delegate = self;
}

- (void)setParameter:(FlutterMethodCall *)call {
    // 设置训练参数
    // 清空参数
    [self.iFlySpeechEvaluator setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    
    for (NSString *key in [call.arguments allKeys]) {
        [self.iFlySpeechEvaluator setParameter:[call.arguments valueForKey:key] forKey:key];
    }
}

- (void)start:(FlutterMethodCall *)call {
    NSData *content = [call.arguments valueForKey:@"content"];
    [self.iFlySpeechEvaluator startListening:content params:nil];
}

- (void)stop {
    [self.iFlySpeechEvaluator stopListening];
}

- (void)cancel {
    [self.iFlySpeechEvaluator cancel];
}

- (void)destroy {
    [self.iFlySpeechEvaluator destroy];
}

- (void)resultsParsing {
    if (!self.resultParser) {
        return;
    }
    
    [self.resultParser parserXml:self.resultStr];
}

- (void)flutterInvokeMethodError:(id _Nullable)result {
    if([result isKindOfClass:[FlutterError class]]) {
        FlutterError *error = result;
        NSLog(@"Critical Error: invokeMethod %@ failed with FlutterError errorCode: %@, message: %@, details: %@", @"onResultListener", [error code], [error message], [error details]);
    } else if([result isKindOfClass:[FlutterMethodNotImplemented class]]) {
        NSLog(@"Critical Error: invokeMethod %@ failed with FlutterMethodNotImplemented", @"onResultListener");
        [result raise]; // force shut down
    }
}

#pragma - IFlySpeechEvaluatorDelegate

/*!
 *  音量和数据回调
 *
 *  @param volume 音量
 *  @param buffer 音频数据
 */
- (void)onVolumeChanged:(int)volume buffer:(NSData *)buffer {
    NSLog(@"IFlySpeechEvaluatorDelegate : onVolumeChanged");
}

/*!
 *  开始录音回调<br>
 *  当调用了`startListening`函数之后，如果没有发生错误则会回调此函数。如果发生错误则回调onCompleted:函数
 */
- (void)onBeginOfSpeech {
    NSLog(@"IFlySpeechEvaluatorDelegate : onBeginOfSpeech");
}

/*!
 *  停止录音回调<br>
 *  当调用了`stopListening`函数或者引擎内部自动检测到断点，如果没有发生错误则回调此函数。<br>
 *  如果发生错误则回调onCompleted:函数
 */
- (void)onEndOfSpeech {
    NSLog(@"IFlySpeechEvaluatorDelegate : onEndOfSpeech");
}

/*!
 *  正在取消
 */
- (void)onCancel {
    NSLog(@"IFlySpeechEvaluatorDelegate : onCancel");
}

/*!
 *  评测错误回调
 *
 *  在进行语音评测过程中的任何时刻都有可能回调此函数，你可以根据errorCode进行相应的处理.当errorCode没有错误时，表示此次会话正常结束，否则，表示此次会话有错误发生。特别的当调用`cancel`函数时，引擎不会自动结束，需要等到回调此函数，才表示此次会话结束。在没有回调此函数之前如果重新调用了`startListenging`函数则会报错误。
 *
 *  @param errorCode 错误描述类
 */
- (void)onCompleted:(IFlySpeechError *)errorCode {
    [self.channel invokeMethod:@"onErrorListener" arguments:[errorCode errorDesc] result:^(id _Nullable result) {
        [self flutterInvokeMethodError:result];
    }];
}

/*!
 *  评测结果回调<br>
 *  在评测过程中可能会多次回调此函数，你最好不要在此回调函数中进行界面的更改等操作，只需要将回调的结果保存起来。
 *
 *  @param results -[out] 评测结果。
 *  @param isLast  -[out] 是否最后一条结果
 */
- (void)onResults:(NSData *)results isLast:(BOOL)isLast {
    if (!results)
        return;
    
    self.resultStr = @"";

    const char *chResult = [results bytes];
    NSString *strResults = [[NSString alloc] initWithBytes:chResult length:[results length] encoding:NSUTF8StringEncoding];
    
    if (strResults){
        self.resultStr = [self.resultStr stringByAppendingString:strResults];
    }
}


#pragma - ISEResultXmlParserDelegate
- (void)onISEResultXmlParser:(NSXMLParser *)parser Error:(NSError *)error {
    NSLog(@"ISEResultXmlParserDelegate : onISEResultXmlParser Error: %@", error);
}

- (void)onISEResultXmlParserResult:(ISEResult *)iseResult {
    NSLog(@"ISEResultXmlParserDelegate : onISEResultXmlParserResult");
    [self.channel invokeMethod:@"onResultListener" arguments:[NSString stringWithFormat:@"%f", [iseResult total_score]] result:^(id _Nullable result) {
        [self flutterInvokeMethodError:result];
    }];
}

@end
