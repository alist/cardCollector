//
//  UIWindow+ISUXAddons.m
//  swyp
//
//  Created by Alexander List on 2/11/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "UIWindow+ISUXAddons.h"

@implementation UIWindow (ISUXAddons)
-(void)flashWindow{
	UIView * flashView	= [[UIView alloc] initWithFrame:self.bounds];
	[flashView setBackgroundColor:[UIColor whiteColor]];
	[flashView setAlpha:0];
	[self addSubview:flashView];
	
	[UIView animateWithDuration:.3 delay:0 options:UIViewAnimationCurveEaseIn animations:^{
		[flashView setAlpha:.8];
	} completion:^(BOOL completed){
		[UIView animateWithDuration:.3 animations:^{
			[flashView setAlpha:0];
		}completion:^(BOOL completed){
			[flashView removeFromSuperview];
		}];
	}];
	
}
@end
