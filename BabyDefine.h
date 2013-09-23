//
//  Header.h
//  QeBaby
//
//  Created by DoubleZ on 13-9-11.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#ifndef QeBaby_Header_h
#define QeBaby_Header_h

#define STR(x) #x
//baby所有json接口
//定义url格式

//baby主页
#define BabyHome @"http://www.qebaby.com/home"
//baby server address
#define BabyServerAddress @"www.qebaby.com"


//主页数据接口
#define BabyHomeDataUrl @"http://www.qebaby.com/home/new_growths"
#define BabyHomeDataUrlForStartAndLength @"http://www.qebaby.com/home/new_growths?start=%d&length=%d"
#define BabyHomeDataUrlWithStartAndLength(x,y) [NSString stringWithFormat:BabyHomeDataUrlForStartAndLength, x, y]

//登录接口
#define BabyHomeLoginMain @"http://www.qebaby.com/login/dologin"
#define BabyHomeLogin @"http://www.qebaby.com/login/dologin?email=%@&password=%@"
#define BabyHomeLoginWithNameAndPassword(username,password) [NSString stringWithFormat:BabyHomeLogin, username,password]
//注册接口
#define BabyHomeRegister @"http://www.qebaby.com/register/regist"
#define BabyHomeCheckEmail @"http://www.qebaby.com/register/check_email"

//http
#define HTTP_POST_STR @"POST"
#define HTTP_GET_STR @"GET"
#define SessionKey @"Cookie"
#define SessionValue @"ts_session=puea34k91lhda8epjob78dhso7"

//BabyLog
#define BabyLog(s, ...)  NSLog(@"< %@:(%d) %s >%@", [[NSString stringWithUTF8String:__FILE__]  \
                lastPathComponent],__LINE__, __FUNCTION__,[NSString stringWithFormat:(s), ##__VA_ARGS__])  
#define BabyLogData(s,data) BabyLog(s,[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
#define BabyLogHttpRequest(request) \
                    BabyLog(@"request http header field:%@", [request allHTTPHeaderFields]);
#define BabyLogHttpResponse(response) \
                    BabyLog(@"response http header field:%@", [response allHeaderFields]);\
                    BabyLog(@"response status code:%d",response.statusCode);
#endif


//baby notification
#define BabyMsgHadRefreshed @"tableview msg was change"


//实用的宏
#define MainScreenHeight    [[UIScreen mainScreen] bounds].size.height
#define MainScreenWidth     [[UIScreen mainScreen] bounds].size.width

#define DefaultImageHeight 380

#define X(view) view.frame.origin.x
#define Y(view) view.frame.origin.y

#define Height(view) view.frame.size.height
#define Width(view) view.frame.size.width


/** 暂时不知道放哪，先放这儿*/
#define NameLabelWidth 150
#define HeadViewHeight 150
#define HeadViewWidth HeadViewHeight
#define TimeLabelWidth 150
#define ImageHeightPer 480
#define ImageWidthPer 360
#define ContentLabelHeight 400