//
//  ISPasteboardVC.m
//  swyp
//
//  Created by Ethan Sherbondy on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISPasteboardVC.h"
#import "UIImage+Resize.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+URLEncoding.h"
#import <CoreLocation/CoreLocation.h>

@implementation ISPasteboardVC

@synthesize pbChangeCount;
@synthesize pbObjects;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Pasteboard", @"The pasteboard.") 
                                                        image:[UIImage imageNamed:@"paperclip"] tag:2];
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.frame = CGRectMake(0, screenSize.height-(212+49+20), 320, 212);
        self.view.autoresizesSubviews = YES;
        self.view.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth);
        
        pbScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
        pbScrollView.pagingEnabled = YES;
        [self.view addSubview:pbScrollView];
        
        self.pbObjects = [NSMutableArray array];
    }
    
    pbChangeCount = 0;
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];	
}

- (void)updatePasteboard {
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    // go by changecount
    if (pbChangeCount != pasteBoard.changeCount) {
        pbChangeCount = pasteBoard.changeCount;
        
        self.tabBarItem.badgeValue = @"!";
                
        if (pasteBoard.image) {
            ISPasteboardObject *pbItem = [[ISPasteboardObject alloc] init];

            UIImage *croppedImage = [pasteBoard.image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:self.view.size interpolationQuality:0.8];
            pbItem.image = [croppedImage copy];
            pbItem.text = nil;
            
            [pbObjects addObject:pbItem];
        }
        
        if (pasteBoard.URL) {
            ISPasteboardObject *pbItem = [[ISPasteboardObject alloc] init];

            pbItem.text = [pasteBoard.URL absoluteString];
            
            [pbObjects addObject:pbItem];
        }
        
        if (pasteBoard.string) {
            
            NSDataDetector *addressDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeAddress error:NULL];
            
            NSTextCheckingResult *match = [addressDetector firstMatchInString:pasteBoard.string options:0 range:NSMakeRange(0, pasteBoard.string.length)];
            
            ISPasteboardObject *pbItem = [[ISPasteboardObject alloc] init];

            if (match) {
                NSLog(@"A match!");
                pbItem.address = pasteBoard.string;
            } else {
                pbItem.text = pasteBoard.string;
            }
            
            [pbObjects addObject:pbItem];
        }
        
    } else {
        self.tabBarItem.badgeValue = nil;
    }
    
    for (id subview in [pbScrollView subviews]){
        if ([subview class] == [ISPasteboardView class]){
            [subview removeFromSuperview];
        }
    }
    
    int i = 0;
    for (ISPasteboardObject *pbObject in pbObjects){
        ISPasteboardView *pasteView = [[ISPasteboardView alloc] initWithFrame:
                                       CGRectMake(i*self.view.width, 0, self.view.width, self.view.height)];
        [pbScrollView addSubview:pasteView];
        pbObject.delegate = pasteView;
        
        NSLog(@"%@", pbObject.delegate);
        i += 1;
    }
    pbScrollView.contentSize = CGSizeMake(i*self.view.width, self.view.height);
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
