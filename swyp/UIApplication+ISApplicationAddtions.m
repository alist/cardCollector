//
//  UIApplication+ISApplicationAddtions.m
//  swyp
//
//  Created by Alexander List on 2/4/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "UIApplication+ISApplicationAddtions.h"

@implementation UIApplication (ISApplicationAddtions)
-(NSNumber*)appRunCount{
	NSUserDefaults *userDefaults = [NSUserDefaults new];
	NSInteger runCount = [userDefaults integerForKey:@"totalApplicationRuns"];
	return [NSNumber numberWithInteger:runCount];
}
-(void)incrementRunCount{
	NSUserDefaults *userDefaults = [NSUserDefaults new];
	[userDefaults setInteger:[[self appRunCount] intValue] +1 forKey:@"totalApplicationRuns"];
}

@end
