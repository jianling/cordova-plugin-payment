/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import "CDVPayment.h"
#import <Cordova/CDVPlugin.h>
#import <AlipaySDK/AlipaySDK.h>

@implementation CDVPayment

- (void)pay:(CDVInvokedUrlCommand*)command
{
    NSString *signedString = [command.arguments objectAtIndex:0];

    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        // 应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"alisdkdemo";

        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:signedString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

@end
