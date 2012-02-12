//
//  ISTabVC.h
//  swyp
//
//  Created by Alexander List on 2/11/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISTabVC : UIViewController <swypContentDataSourceProtocol, swypConnectionSessionDataDelegate>
@property (nonatomic, assign) id<swypContentDataSourceDelegate>	datasourceDelegate;

+(UITabBarItem*)tabBarItem;
@end
