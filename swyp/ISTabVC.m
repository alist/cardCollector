//
//  ISTabVC.m
//  swyp
//
//  Created by Alexander List on 2/11/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISTabVC.h"

@implementation ISTabVC

+(UITabBarItem*)tabBarItem{
	return nil;
}

-(void)viewDidLoad{
	[super viewDidLoad];
	
	self.view.autoresizingMask	=	UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	
	self.view.backgroundColor	=	[UIColor colorWithWhite:0 alpha:.5];
}

-(void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	self.view.alpha	=	0;
}

-(void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	
	[UIView animateWithDuration:.5 animations:^{
		self.view.alpha	=	1;
	}];
}

@end
