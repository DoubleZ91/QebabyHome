//
//  BabyNetwork.m
//  QeBaby
//
//  Created by DoubleZ on 13-9-11.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import "BabyNetwork.h"
#import "BabyDefine.h"
#import "AFNetworking.h"
static NSString* BabySession;
@implementation BabyNetwork

+ (NSString*) HTTPBodyWithParameter:(NSDictionary *)parameter
{
    NSMutableArray *parametersArray = [[NSMutableArray alloc]init];
    for (NSString *key in [parameter allKeys]){
        id value = [parameter objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
        }
    }
    return [parametersArray componentsJoinedByString:@"&"];
}
#pragma mark - post
+ (NSMutableURLRequest*) requsetUsingPOSTWithURL:(NSURL*) url WithHttpBodyDict: (NSDictionary*) parameterDict
{
    if (parameterDict == nil) {
        return [self requestUsingPOSTWithURL:url WithHttpBodyData:nil];
    }
    else{
        NSString *parameterStr = [self HTTPBodyWithParameter:parameterDict];
        return [self requestUsingPOSTWithURL:url WithHttpBodyString:parameterStr];
    }
}
+ (NSMutableURLRequest*) requestUsingPOSTWithURL:(NSURL*) url WithHttpBodyString: (NSString*) parameterStr
{
    if (parameterStr == nil) {
        return [self requestUsingPOSTWithURL:url WithHttpBodyData:nil];
    }
    else{
        NSData *bodyData = [parameterStr dataUsingEncoding:NSUTF8StringEncoding];
        return [self requestUsingPOSTWithURL:url WithHttpBodyData:bodyData];
    }
}

+ (NSMutableURLRequest*) requestUsingPOSTWithURL:(NSURL *)url WithHttpBodyData:(NSData *)parameterData
{
    if (parameterData == nil) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];
        [request setHTTPMethod:HTTP_POST_STR];
        return request;
    }
    else{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];
        [request setHTTPMethod:HTTP_POST_STR];
        [request setHTTPBody:parameterData];
        return request;
    }
}

#pragma mark - GET
+ (NSMutableURLRequest*) requestUsingGETWithURL:(NSURL*) url WithParameterString:(NSString*) parameterStr
{
    if (parameterStr == nil) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];
        [request setHTTPMethod:HTTP_GET_STR];
        return request;
    }
    else {
        NSString *appendixStr = [NSString stringWithFormat:@"?%@",parameterStr];
        NSURL *requestURL = [NSURL URLWithString:appendixStr relativeToURL:url];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:requestURL];
        [request setHTTPMethod:HTTP_GET_STR];
        return request;
    }
}

+ (NSMutableURLRequest*) requestUsingGETWithURL:(NSURL*) url WithParameterDict:(NSDictionary*) parameterDict
{
    if (parameterDict == nil) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];
        [request setHTTPMethod:HTTP_GET_STR];
        return request;
    }
    else
    {
        NSString *parameterStr = [self HTTPBodyWithParameter:parameterDict];
        return [self requestUsingGETWithURL:url WithParameterString: parameterStr];
    }
}
/**通过url来获取json*/
+ (NSData*) requestJSONFromBabyURL:(NSURL*)url
{
    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];
    NSMutableURLRequest *request = [BabyNetwork requestUsingGETWithURL:url WithParameterString:nil];
    [request setHTTPShouldHandleCookies:YES];
    
    NSHTTPURLResponse *response;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *content = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    BabyLogHttpRequest(request);
    BabyLogHttpResponse(response);
    BabyLog(@"Response data:%@",content);
    return data;
}
/**通过已经拿到的json数据来处理并获取图片等内容*/
+ (BabyMsgData*) requestBabyMsgWithJSONDictionary:(NSDictionary *)jsonDict
{
    BabyLog(@"%@",jsonDict);
    NSString *nameStr = [jsonDict valueForKey:@"users_name"];
    NSString *content = [jsonDict valueForKey:@"growth_content"];
    NSUInteger time = (NSUInteger)[[jsonDict valueForKey:@"growth_timeline"] integerValue];
    NSString *headImageURL = [jsonDict valueForKey:@"users_avatar"];
    NSArray *imageArrayURL = [jsonDict valueForKey:@"growth_photos"];
    UIImage *headImage = nil;
    if (headImageURL) {
        headImage = [self requestImageWithURLString:headImageURL];
    }
    else
    {
        NSLog(@"%s %@",__FUNCTION__,@"headImage nil.");
    }
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    if (imageArrayURL == nil || imageArrayURL.count == 0) {
        NSLog(@"%s %@",__FUNCTION__,@"imageArray nil.");
    }
    else
    {
        for (int i = 0; i < imageArrayURL.count; i++) {
            UIImage *image = [self requestImageWithURLString:[imageArrayURL objectAtIndex:i]];
            if (image == nil) {
                continue;
            }
            //缩放成为符合要求的大小 ---imageView处修改比例
            //image = [self scaleToRequireImage:image];
            [imageArray addObject:image];
        }
    }
    return [[BabyMsgData alloc]initWithAllMsg:nameStr withHeadImage:headImage withTime:time withContent:content withImageArray:imageArray ];
}
/**缩放图片*/
+ (UIImage*) scaleToRequireImage:(UIImage*) srcImage
{
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    NSInteger imageWidth = screenSize.size.width  - 20;
    
    if (imageWidth > srcImage.size.width) {
        return srcImage;
    }
    
    float scale = srcImage.size.width / imageWidth;
    UIGraphicsBeginImageContext(CGSizeMake(imageWidth, srcImage.size.height * scale));
    [srcImage drawInRect:CGRectMake(0, 0, imageWidth, srcImage.size.height *scale)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaleImage;
}


/**通过url来获取图片*/
+ (UIImage*) requestImageWithURL:(NSURL*)url
{
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
    UIImage* image = [[UIImage alloc]initWithData:imageData];
    return image;
}
+ (UIImage*) requestImageWithURLString:(NSString*)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    return [self requestImageWithURL:url];
}
+ (void) setSession:(NSString *)session
{
    BabySession = [NSString stringWithString:session];
}

+ (NSString*) getSession
{
    return BabySession;
}
+ (NSString*) getSessionNum
{
    return [BabySession substringFromIndex:11];
}
@end
