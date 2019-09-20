#import "FlutterPluginDemoPlugin.h"

@implementation FlutterPluginDemoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_plugin_demo"
            binaryMessenger:[registrar messenger]];
  FlutterPluginDemoPlugin* instance = [[FlutterPluginDemoPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if([@"invoke" isEqualToString:call.method]) {
        SEL selector = nil;
        NSArray *arguments = call.arguments[@"params"];
        NSString *methodName = call.arguments[@"method"];
        if (!arguments.count) {
            selector = NSSelectorFromString(methodName);

        } else {
            selector = NSSelectorFromString([NSString stringWithFormat:@"%@:",methodName]);
        }
    
        NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
        
        if(signature == nil){
            // 抛出异常
            NSString *reason = [NSString stringWithFormat:@"%@方法不存在",call.arguments[@"method"]];
            @throw [NSException exceptionWithName:@"error" reason:reason userInfo:nil];
        }
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        
        invocation.target = self;
        invocation.selector = selector;
        
        if (arguments.count) {
            [invocation setArgument:&arguments atIndex:2];

        }
      
        //调用方法
        [invocation invoke];
        
        // 获取返回值
        NSObject *ret = nil;
        
        //signature.methodReturnLength == 0 说明给方法没有返回值
        if (signature.methodReturnLength) {
            void *returnValue = nil;
            [invocation getReturnValue:&returnValue];
            ret = (__bridge NSObject *)returnValue;
        }
        
        result(ret);
        
    }
   else {
    result(FlutterMethodNotImplemented);
  }
}



- (NSString *)platformVersion {
    return [@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]];
}

- (void)openAppStore:(NSArray *)param {
    NSString* iTunesLink;
    NSString *appID = param[0];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 11) {
        iTunesLink = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/xy/app/foo/id%@",appID];
    } else {
        iTunesLink = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",appID];
    }
        
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}
@end
