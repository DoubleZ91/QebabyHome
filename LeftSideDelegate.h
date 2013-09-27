//
//  LeftSideDelegate.h
//  QeBaby
//
//  Created by DoubleZ on 13-9-26.
//  Copyright (c) 2013年 DoubleZ. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum _SideBarShowDirection
{
    SideBarShowDirectionNone = 0,
    SideBarShowDirectionLeft = 1,
    SideBarShowDirectionRight = 2
}  SideBarShowDirection;

@protocol LeftSideDelegate <NSObject>

@optional
- (void) leftSideBarSelectWithController:(UIViewController*) controller;
- (void) rightSideBarSelectWithController:(UIViewController*) controller;
- (void) showSideBarControllerWithDirection:(SideBarShowDirection)direction;

@end
