//
//  BabyNetwork.h
//  QeBaby
//
//  Created by DoubleZ on 13-9-11.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BabyMsgData.h"

@interface BabyNetwork : NSObject

/**将dictionary数据转化为特定格式的string数据。*/
+ (NSString*) HTTPBodyWithParameter:(NSDictionary *)parameter;
#pragma mark -
#pragma mark - method for creating http POST request
/** http request use POST method with HttpBodyDict*/
+ (NSMutableURLRequest*) requsetUsingPOSTWithURL:(NSURL*) url WithHttpBodyDict: (NSDictionary*) parameterDict;
/** http resquest use POST method with HttpBodyString*/
+ (NSMutableURLRequest*) requestUsingPOSTWithURL:(NSURL*) url WithHttpBodyString: (NSString*) parameterStr;
/** http resquest use POST method with httpBodyData*/
+ (NSMutableURLRequest*) requestUsingPOSTWithURL:(NSURL*) url WithHttpBodyData: (NSData*) parameterData;

#pragma mark -
#pragma mark - method for creating http GET request
/** http resquest use GET method with String Parameter.*/
+ (NSMutableURLRequest*) requestUsingGETWithURL:(NSURL*) url WithParameterString:(NSString*) parameterStr;
/** http resquest use GET method with Dictionary Parameter.*/
+ (NSMutableURLRequest*) requestUsingGETWithURL:(NSURL*) url WithParameterDict:(NSDictionary*) parameterDict;

/**通过url来获取json*/
+ (NSData*) requestJSONFromBabyURL:(NSURL*)url;
/**通过json来获取所有数据，主要图片*/
+ (BabyMsgData*) requestBabyMsgWithJSONDictionary:(NSDictionary *)jsonDict;
/**通过url来获取图片*/
+ (UIImage*) requestImageWithURL:(NSURL*)url;
+ (UIImage*) requestImageWithURLString:(NSString*)urlStr;

+ (NSString*) getSession;
+ (NSString*) getSessionNum;
+ (void) setSession:(NSString*) session;
@end
