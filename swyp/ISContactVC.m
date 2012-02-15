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
        CGFloat ty = self.view.origin.y - contactView.origin.y + (self.view.height-contactView.height)/2;
        contactView.transform = CGAffineTransformTranslate(contactView.transform, 0, ty);
    }completion:^(BOOL finished){
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        CGFloat ty = self.view.size.height;
        contactView.transform = CGAffineTransformTranslate(contactView.transform, 0, ty);
    }completion:^(BOOL finished){
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    contactView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    contactView.autoresizingMask = UIViewAutoresizingFlexibleMargins|UIViewAutoresizingFlexibleWidth;
    contactView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"handmadepaper"]];
    contactView.clipsToBounds = NO;
    CALayer *layer = contactView.layer;
    layer.shadowRadius = 8;
    layer.shadowColor = [UIColor whiteColor].CGColor;
    layer.shadowOffset = CGSizeMake(0, 20);
    layer.shadowPath = [UIBezierPath bezierPathWithRect:contactView.bounds].CGPath;
    [self.view addSubview:contactView];
    contactView.origin = CGPointMake((self.view.width - 300)/2, self.view.size.height);
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
