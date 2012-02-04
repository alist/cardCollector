//
//  UIApplication+ISApplicationAddtions.h
//  swyp
//
//  Created by Alexander List on 2/4/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (ISApplicationAddtions)
-(NSNumber*)appRunCount;
-(void)incrementRunCount;
@end
