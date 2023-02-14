/********* wswAdWork.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import "AppDelegate.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>
#import <BUAdSDK/BUAdSDK.h>

@interface wswAdWork : CDVPlugin {
  // Member variables go here.
}

- (void)coolMethod:(CDVInvokedUrlCommand*)command;
@end

@implementation wswAdWork

- (void)successWithCallbackID:(NSString *)callbackID withMessage:(NSString *)message
{
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
    [self.commandDelegate sendPluginResult:commandResult callbackId:callbackID];
}



- (void)failWithCallbackID:(NSString *)callbackID withMessage:(NSString *)message
{
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:message];
    [self.commandDelegate sendPluginResult:commandResult callbackId:callbackID];
}

- (void)wswScreenAd:(CDVInvokedUrlCommand *)command {
    self.urlCommand = command;
    NSDictionary *params = [command.arguments objectAtIndex:0];
    if ([[params objectForKey:@"type"] isEqualToString:@"pangolin"]) {
        __weak typeof(self) weakSelf = self;
        [BUAdSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //请求广告逻辑处理
                    strongSelf.splashAd = [[BUSplashAd alloc] initWithSlotID:@"888084745" adSize:UIScreen.mainScreen.bounds.size];
                    // 设置开屏广告代理
                    strongSelf.splashAd.delegate = strongSelf;
                    // 加载广告
                    [strongSelf.splashAd loadAdData];
                });
            }
        }];
        
        [self requestIDFA];
    }
    else if ([[params objectForKey:@"type"] isEqualToString:@"tenxun"]) {
        
    }
    
}

- (void)requestIDFA {
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            // Tracking authorization completed. Start loading ads here.
            // [self loadAd];
        }];
    } else {
        // Fallback on earlier versions
    }
}

- (void)splashAdLoadSuccess:(BUSplashAd *)splashAd {
    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    [splashAd showSplashViewInRootViewController:keyWindow.rootViewController];
    [self successWithCallbackID:self.urlCommand.callbackId  withMessage:[CloudPushSDK getDeviceId]?:@""];
}

- (void)splashAdLoadFail:(BUSplashAd *)splashAd error:(BUAdError *)error {
    [self successWithCallbackID:self.urlCommand.callbackId  withMessage:error.description];
}

@end
