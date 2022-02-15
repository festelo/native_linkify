#import "NativeLinkifyPlugin.h"
#if __has_include(<native_linkify/native_linkify-Swift.h>)
#import <native_linkify/native_linkify-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "native_linkify-Swift.h"
#endif

@implementation NativeLinkifyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNativeLinkifyPlugin registerWithRegistrar:registrar];
}
@end
