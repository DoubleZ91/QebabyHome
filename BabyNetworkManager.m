//
//  BabyNetworkManager.m
//  QeBaby
//
//  Created by DoubleZ on 13-9-16.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import "BabyNetworkManager.h"
#import "BabyDefine.h"
#import "BabyNetwork.h"
/** 标记是否网络被初始化*/
static Boolean bNetworkInit = false;

@implementation BabyNetworkManager
+ (void)initNetworkWorkplace
{
    if (bNetworkInit) 
        return;
    else
        bNetworkInit = true;
    
    //get the session through accessing the baby home website
    //就算不缓存session也可以，目前没用到
    NSURL *homeURL = [NSURL URLWithString:BabyHome];
    NSURLRequest *homeRequest = [NSURLRequest requestWithURL:homeURL];
    NSHTTPURLResponse *homeResponse;
    //Response传指针的取址是因为，指针本身也是值传递，如果要改变指针的指向，那也必须是传指针的指针
    [NSURLConnection sendSynchronousRequest:homeRequest returningResponse:&homeResponse error:nil];
    NSDictionary *homeHttpResponseHeader = [homeResponse allHeaderFields];
    NSString *cookieStr = [homeHttpResponseHeader valueForKey:@"Set-Cookie"];
    if (cookieStr) {
        [BabyNetwork setSession:[cookieStr substringWithRange:NSMakeRange(0, 37)]];
    }
    BabyLog(@"session is :%@",cookieStr);
}
+ (void) loginWithEmailAndPwd:(NSString*) email withPassword:(NSString*) password autologin:(bool)isAutologin
{
    NSURL *url = [NSURL URLWithString:BabyHomeLoginMain];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setValue:email forKey:@"email"];
    [parameter setValue:password forKey:@"password" ];
    if(isAutologin)
        [parameter setValue:@"1" forKey:@"autologin"];
    else
        [parameter setValue:@"0" forKey:@"autologin"];
    
    NSMutableURLRequest *request = [BabyNetwork requsetUsingPOSTWithURL:url WithHttpBodyDict:parameter];
    [request setHTTPShouldHandleCookies:YES];
    
    NSHTTPURLResponse *response;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    BabyLog(@"Login data:%@",str);
    BabyLogHttpResponse(response);
}

#pragma mark -
#pragma mark - add data
+ (NSData*) babyGrowthsWithStartAndLength:(NSUInteger) start Length:(NSUInteger) length
{
    NSURL *url = [NSURL URLWithString:BabyHomeDataUrlWithStartAndLength(start, length)];
    return [self babyGrowthsWithURL:url];
}
+ (NSData*) babyGrowthsWithURL:(NSURL*) url
{
    NSURLRequest *request = [BabyNetwork requestUsingGETWithURL:url WithParameterDict:nil];
    NSHTTPURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    BabyLogData(@"response data:%@", data);
    BabyLogHttpResponse(response);
    return data;
}
+ (NSData*) babyMsgWithStartAndLength:(NSUInteger)start Length:(NSUInteger)length
{
    NSURL *url = [NSURL URLWithString:BabyHomeDataUrlWithStartAndLength(start, length)];
    NSURLRequest *request = [BabyNetwork requestUsingGETWithURL:url WithParameterDict:nil];
    NSHTTPURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    BabyLogData(@"response data:%@", data);
    BabyLogHttpResponse(response);
    return data;
}
@end
