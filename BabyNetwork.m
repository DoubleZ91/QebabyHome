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
#import <dispatch/dispatch.h>
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
+ (NSMutableURLRequest*) requestUsingPOSTWithURL:(NSURL*) url WithHttpBodyDict: (NSDictionary*) parameterDict
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

/** http resquest use POST method with Image for upload image*/
+ (NSMutableURLRequest*) requestForUploadImageUsingPOSTWithURL:(NSURL*) url WithImageData:(NSData*)imageData name:(NSString*)name
{
    //setup request object
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    [request setHTTPMethod:HTTP_POST_STR];
    //add contenty-type. use a string doundary.
    NSString *boundary = @"0xKhTmLbOuNdArY";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data;boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    // NSASCIIStringEncoding vs NSUTF8StringEncoding
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data;name=\"image[]\";filename=%@\r\n",name]dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: image/png\r\n\r\n"]dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendData:[[NSData dataWithData:imageData] dataUsingEncoding:NSUTF8StringEncoding ]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary]dataUsingEncoding:NSUTF8StringEncoding] ];
    [request setHTTPBody:body];
    
    return request;
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
    //@autoreleasepool {

    BabyLog(@"%@",jsonDict);
    NSString *nameStr = [jsonDict valueForKey:@"users_name"];
    NSString *content = [jsonDict valueForKey:@"growth_content"];
    NSUInteger time = (NSUInteger)[[jsonDict valueForKey:@"growth_timeline"] integerValue];
    NSString *headImageURL = [jsonDict valueForKey:@"users_avatar"];
    NSArray *imageArrayURL = [jsonDict valueForKey:@"growth_photos"];
    
    NSMutableArray *smallImageURL = [[NSMutableArray alloc] init ];
    for (NSString *smallURL in imageArrayURL) {
//        @autoreleasepool {
//        NSMutableString *str = [NSMutableString stringWithString: smallURL];
//        [str replaceOccurrencesOfString:@"attachments" withString:@"small" options:NSCaseInsensitiveSearch range:NSMakeRange(20, 35)];
//            smallURL = [NSString stringWithString:str];
//        }
         [smallImageURL addObject: [smallURL stringByReplacingOccurrencesOfString:@"attachments" withString:@"small"]];
    }
    
    UIImage *headImage = nil;
    if (headImageURL) {
        headImage = [self requestImageWithURLString:headImageURL];
    }
    else
    {
        NSLog(@"%s %@",__FUNCTION__,@"headImage nil.");
    }
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    if (smallImageURL == nil || smallImageURL.count == 0) {
        NSLog(@"%s %@",__FUNCTION__,@"imageArray nil.");
    }
    else
    {
        for (int i = 0; i < smallImageURL.count; i++) {
            UIImage *image = [self requestImageWithURLString:[smallImageURL objectAtIndex:i]];
            if (image == nil) {
                continue;
            }
            //缩放成为符合要求的大小 ---imageView处修改比例
            image = [self scaleToRequireImage:image];
            //image = [self resizeImage:image];
            if (image == nil) {
                continue;
            }
            [imageArray addObject:image];
        }
    }
        
    
    return [[BabyMsgData alloc]initWithAllMsg:nameStr withHeadImage:headImage withTime:time withContent:content withImageArray:imageArray ];
        
    //}  //auto release pool
}
/**缩放图片*/
+ (UIImage*) scaleToRequireImage:(UIImage*) srcImage
{
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    float imageWidth = screenSize.size.width  - 20;
    
    if (imageWidth > srcImage.size.width) {
        return srcImage;
    }
    
    float scale = srcImage.size.width / imageWidth;
    UIGraphicsBeginImageContext(CGSizeMake(imageWidth, srcImage.size.height / scale));
    [srcImage drawInRect:CGRectMake(0, 0, imageWidth, srcImage.size.height /scale)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaleImage;
}


/**通过url来获取图片*/
+ (UIImage *) resizeImage:(UIImage*)image
{
    CGSize size = image.size;
    float scale = size.width/MainScreenWidth;
    size.width = MainScreenWidth;
    size.height = size.height/scale;
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage*) requestImageWithURL:(NSURL*)url
{
#warning init imageData :need more efficiency code..
    NSData *imageData = nil;
    UIImage *image = nil;
    NSError *error = nil;
    @try {
        //imageData = [[NSData alloc] initWithContentsOfURL:url];
        imageData = [[NSData alloc]initWithContentsOfURL:url options:NSDataReadingMappedAlways error:&error];
       
        if(error){
            BabyLog(@"%@",[error localizedDescription]);
        }
        else
            image = [[UIImage alloc]initWithData:imageData];
    }
    @catch (NSException *exception) {
        BabyLog(@"init imageData error.............................................");
    }
    @finally {
        
        return image;
    }
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
