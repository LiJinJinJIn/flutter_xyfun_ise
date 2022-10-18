#import "FlutterXfyunIsePlugin.h"
#if __has_include(<flutter_xfyun_ise/flutter_xfyun_ise-Swift.h>)
#import <flutter_xfyun_ise/flutter_xfyun_ise-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_xfyun_ise-Swift.h"
#endif

@implementation FlutterXfyunIsePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterXfyunIsePlugin registerWithRegistrar:registrar];
}
@end
