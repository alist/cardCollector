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
        self.view.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin);
        
        pbScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
        pbScrollView.showsHorizontalScrollIndicator = YES;
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
        
        ISPasteboardObject *pbObject = [[ISPasteboardObject alloc] init];
        
        if (pasteBoard.image) {
            UIImage *croppedImage = [pasteBoard.image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:self.view.size interpolationQuality:0.8];
            pbObject.image = croppedImage;
            pbObject.text = nil;
        } else if (pasteBoard.URL) {
            pbObject.text = [pasteBoard.URL absoluteString];
        } else if (pasteBoard.string) {
            
            NSDataDetector *addressDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeAddress error:NULL];
            
            NSTextCheckingResult *match = [addressDetector firstMatchInString:pasteBoard.string options:0 range:NSMakeRange(0, pasteBoard.string.length)];
            
            if (match) {
                NSLog(@"A match!");
                pbObject.address = pasteBoard.string;
            } else {
                pbObject.text = pasteBoard.string;
            }
        }
        
        [pbObjects addObject:pbObject];

    } else {
        self.tabBarItem.badgeValue = nil;
    }
    
    int i = 0;
    for (ISPasteboardObject *pbObject in pbObjects){
        ISPasteboardView *pasteView = [[ISPasteboardView alloc] initWithFrame:
                                       CGRectMake(i*self.view.width, 0, self.view.width, self.view.height)];
        [pbScrollView addSubview:pasteView];
        [pbObject setDelegate:pasteView];
        
        NSLog(@"%@, %@", pbObject.text, pbObject.address);
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
