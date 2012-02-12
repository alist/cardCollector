//
//  ISCalendarVC.m
//  swyp
//
//  Created by Ethan Sherbondy on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISCalendarVC.h"
#import <Kal.h>

@implementation ISCalendarVC
+(UITabBarItem*)tabBarItem{
	return [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Calendar", @"Your calendar events on the tab bar.") image:[UIImage imageNamed:@"calendar"] tag:1];
}

#pragma mark -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[self class] tabBarItem];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	
	KalViewController * kalVC	=	[[KalViewController alloc] initWithSelectedDate:[NSDate date]];
	[kalVC.view setFrame:self.view.bounds];
	[kalVC.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	[self.view addSubview:kalVC.view];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
	return YES;
}

@end
