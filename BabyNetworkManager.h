//
//  BabyNetworkManager.h
//  QeBaby
//
//  Created by DoubleZ on 13-9-16.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BabyNetworkMgrDelegate;

/** 处理baby的业务*/
@interface BabyNetworkManager : NSObject
//-------------------------
//---The initNetworkWorkplace function must be invoked at least once before the network manager is used.
//-------------------------
+ (void) initNetworkWorkplace;

/** login*/
+ (void) loginWithEmailAndPwd:(NSString*) email withPassword:(NSString*) password autologin:(bool)isAutologin;

#pragma mark - register and check register
/** register*/
+ (bool) registerWithInfo:(NSString*) email withPassword:(NSString*)password withBabyName:(NSString*) babyName;
/** check register email*/
+ (bool) checkRegisterEmail:(NSString*)email;

/** baby growths. */
+ (NSData*) babyGrowthsWithStartAndLength:(NSUInteger) start Length:(NSUInteger) length;
/** get baby MSG with start and length*/
+ (NSData*) babyMsgWithStartAndLength:(NSUInteger) start Length:(NSUInteger) length;


+ (NSData*) babyGrowthsWithURL:(NSURL*) url;



/** upload image*/
+ (void) uploadImage:(UIImage*) uploadImage fileName:(NSString*)name delegate:(id<BabyNetworkMgrDelegate>) delegate ;
/** create growth which only has content*/
+ (bool) createGrowthWithContent:(NSString*) content;
/** create growth which has content and image*/
+ (bool) createGrowthWithContentAndImageArray:(NSString*) content withImageArray :(NSArray*) imageArr;
@end


@protocol BabyNetworkMgrDelegate <NSObject>

@optional
- (void) uploadImageSuccess:(NSData*)data;
- (void) uploadImageFailure:(NSData*)data;

@end
