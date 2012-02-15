//
//  ISContactVC.m
//  swyp
//
//  Created by Ethan Sherbondy on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISContactVC.h"
#import <QuartzCore/QuartzCore.h>

@implementation ISContactVC

+(UITabBarItem*)tabBarItem{
	return [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Contact", @"Your contact card on tab bar.") image:[UIImage imageNamed:@"user"] tag:0];
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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
- (void)loadView {

}
*/

- (void)viewWillAppear:(BOOL)animated {
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        CGFloat ty = self.view.origin.y - contactCard.view.origin.y + 
                    (self.view.height-contactCard.view.height)/2;
        contactCard.view.transform = CGAffineTransformTranslate(contactCard.view.transform, 0, ty);
    }completion:^(BOOL finished){
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        CGFloat ty = self.view.size.height;
        contactCard.view.transform = CGAffineTransformTranslate(contactCard.view.transform, 0, ty);
    }completion:^(BOOL finished){
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    contactCard = [[ISContactCardVC alloc] init];
    contactCard.view.origin = CGPointMake((self.view.width - 300)/2, self.view.size.height);
    [self.view addSubview:contactCard.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
