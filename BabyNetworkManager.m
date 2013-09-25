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
    
    NSMutableURLRequest *request = [BabyNetwork requestUsingPOSTWithURL:url WithHttpBodyDict:parameter];
    [request setHTTPShouldHandleCookies:YES];
    
    NSHTTPURLResponse *response;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    BabyLog(@"Login data:%@",str);
    BabyLogHttpResponse(response);
}

/** register*/
+ (bool) registerWithInfo:(NSString*) email withPassword:(NSString*)password withBabyName:(NSString*) babyName
{
    NSURL *url = [NSURL URLWithString:BabyHomeRegister];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setValue:email forKey:@"email"];
    [parameter setValue:password forKey:@"password"];
    [parameter setValue:password forKey:@"password2"];
    [parameter setValue:babyName forKey:@"baby_name"];
    NSMutableURLRequest *request = [BabyNetwork requestUsingPOSTWithURL:url WithHttpBodyDict:parameter];
    
    NSHTTPURLResponse *response;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *str =  [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    BabyLog(@"Register data:%@",str);
    BabyLogHttpResponse(response);
    
    NSError *error;
    NSDictionary * dict;
    id jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];  ///????&
    if (jsonDict != nil && error == nil)
    {
        if ([jsonDict isKindOfClass:[NSDictionary class]]) {
            NSLog(@"json is a Dictionary.");
            NSLog(@"%@", (NSDictionary*)jsonDict);
            dict = (NSDictionary*)jsonDict;
            
            bool tmp = [[dict valueForKey:@"code"] boolValue];
            if (tmp != 0) {
                return false;
            }
        }
    }
    return true;
}

/** check register email*/
+ (bool) checkRegisterEmail:(NSString*)email
{
    NSURL *url = [NSURL URLWithString:BabyHomeCheckEmail];
    NSMutableDictionary *parameter  = [[NSMutableDictionary alloc]init];
    [parameter setValue:email forKey:@"email"];
    NSMutableURLRequest *request = [BabyNetwork requestUsingPOSTWithURL:url WithHttpBodyDict:parameter];
    
    NSHTTPURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    BabyLog(@"register data:%@",str);
    
    NSError *error;
    NSDictionary * dict;
    id jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];  ///????&
    if (jsonDict != nil && error == nil)
    {
        if ([jsonDict isKindOfClass:[NSDictionary class]]) {
            NSLog(@"json is a Dictionary.");
            NSLog(@"%@", (NSDictionary*)jsonDict);
            dict = (NSDictionary*)jsonDict;
            
            dict = (NSDictionary*)[dict valueForKey:@"data"];
            bool existed = [[dict valueForKey:@"existed"]boolValue];
            if (!existed) {
                return false;
            }
        }
    }
     
    return true;
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

#pragma mark -
#pragma mark - create growths
/** create growth which only has content*/
+ (void) createGrowthWithContent:(NSString*) content
{
    NSDate *date = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlag = NSDayCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit;
    NSDateComponents *dd = [cal components:unitFlag fromDate:date];
    int year = [dd year];
    int month = [dd month];
    int day = [dd day];
    NSString *today = [NSString stringWithFormat:@"%d-%d-%d",year,month,day];
    
    NSURL *url = [NSURL URLWithString:BabyHomeCreateGrowth];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setValue:content forKey:@"content"];
    [parameter setValue:@"" forKey:@"image"];
    [parameter setValue:today forKey:@"timeline"];
    
    NSHTTPURLResponse *response;
    NSURLRequest *request = [BabyNetwork requestUsingPOSTWithURL:url WithHttpBodyDict:parameter];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
//    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    BabyLogData(@"create growth:%@", data);
}
/** create growth which has content and image*/
+ (void) createGrowthWithContentAndImageArray:(NSString*) content withImageArray :(NSArray*) imageArr
{
    
}
@end
