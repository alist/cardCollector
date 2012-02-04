//
//  ISPasteboardVC.m
//  swyp
//
//  Created by Ethan Sherbondy on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISPasteboardVC.h"
#import "UIImage+Resize.h"

@implementation ISPasteboardVC

@synthesize pasteboardItems;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Pasteboard", @"The pasteboard.") 
                                                        image:[UIImage imageNamed:@"paperclip"] tag:3];
    }
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0, screenSize.height-(120+49+20), 320, 120);
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 120)];
    imageView.hidden = YES;
    [self.view addSubview:imageView];
    
    textView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 120)];
    textView.hidden = YES;
    [self.view addSubview:textView];
    
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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)updatePasteboard {
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    if (!pasteboardItems || ![pasteboardItems isEqualToArray:pasteBoard.items]) {

        pasteboardItems = pasteBoard.items;
        
        self.tabBarItem.badgeValue = @"!";
        
        imageView.image = nil;
        
        if (pasteBoard.image) {
            UIImage *croppedImage = [pasteBoard.image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:imageView.size interpolationQuality:0.8];
            [imageView setImage:croppedImage];
            textView.text = nil;
        } else if (pasteBoard.URL) {
            textView.text = [pasteBoard.URL absoluteString];
        } else if (pasteBoard.string) {
            textView.text = pasteBoard.string;
        }
            
        textView.hidden = (textView.text) ? NO : YES;
        imageView.hidden = (imageView.image) ? NO : YES;
    } else {
        self.tabBarItem.badgeValue = nil;
    }
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
