//
//  ISPasteboardVC.m
//  swyp
//
//  Created by Ethan Sherbondy on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISPasteboardVC.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+URLEncoding.h"
#import <AssetsLibrary/AssetsLibrary.h>
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
        pbScrollView.showsHorizontalScrollIndicator = NO;
        pbScrollView.pagingEnabled = YES;
        pbScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        pbScrollView.delegate = self;
        [self.view addSubview:pbScrollView];
        
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 212-24, 320, 24)];
        [self.view addSubview:pageControl];
        
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

- (void)addMostRecentPhotoTaken {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop){
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];

        // only grab the most recent asset
        [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:([group numberOfAssets]-1)] options:0 usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop){
            if (alAsset){
                NSDate *timeTaken = [alAsset valueForProperty:ALAssetPropertyDate];
                
                // we only care if the photo was taken in the last 5 minutes
                if (abs([timeTaken timeIntervalSinceNow]) < 60*5){
                    __block CGImageRef imgRef = CGImageRetain([[alAsset defaultRepresentation] fullScreenImage]);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (alAsset.defaultRepresentation.url != latestAssetURL) {
                            latestAssetURL = alAsset.defaultRepresentation.url;

                            NSLog(@"Adding image!");
                            ISPasteboardObject *pbItem = [[ISPasteboardObject alloc] init];
                            pbItem.image = [UIImage imageWithCGImage:imgRef];
                            [self.pbObjects insertObject:pbItem atIndex:0];

                            [self redisplayPasteboard];
                        }
                        
                        CGImageRelease(imgRef);
                    });                    
                }                
            }
        }];
    } failureBlock:^(NSError *error) {
        NSLog(@"No groups, %@", error);
    }];
}

- (void)redisplayPasteboard {
    for (id subview in [pbScrollView subviews]){
        if ([subview class] == [ISPasteboardView class]){
            [subview removeFromSuperview];
        }
    }
    
    int i = 0;
    for (ISPasteboardObject *pbObject in pbObjects){
        ISPasteboardView *pasteView = [[ISPasteboardView alloc] initWithFrame:
                                       CGRectMake(i*self.view.width, 0, self.view.width, self.view.height)];
        pbObject.delegate = pasteView;
        [pbScrollView addSubview:pasteView];
        i += 1;
    }
    pbScrollView.contentSize = CGSizeMake(i*self.view.width, self.view.height);
    pageControl.numberOfPages = i;
}

- (void)updatePasteboard {
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    // go by changecount
    if (pbChangeCount != pasteBoard.changeCount) {
        pbChangeCount = pasteBoard.changeCount;
        
        self.tabBarItem.badgeValue = @"!";
                
        if (pasteBoard.image) {
            ISPasteboardObject *pbItem = [[ISPasteboardObject alloc] init];
            pbItem.image = [pasteBoard.image copy];
            pbItem.text = nil;
            
            [pbObjects insertObject:pbItem atIndex:0];
        }
        
        if (pasteBoard.URL) {
            ISPasteboardObject *pbItem = [[ISPasteboardObject alloc] init];

            pbItem.text = [pasteBoard.URL absoluteString];
            
            [pbObjects insertObject:pbItem atIndex:0];
        }
        
        if (pasteBoard.string) {
            
            NSDataDetector *addressDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeAddress error:NULL];
            
            NSTextCheckingResult *match = [addressDetector firstMatchInString:pasteBoard.string options:0 range:NSMakeRange(0, pasteBoard.string.length)];
            
            ISPasteboardObject *pbItem = [[ISPasteboardObject alloc] init];

            if (match) {
                pbItem.address = pasteBoard.string;
            } else {
                pbItem.text = pasteBoard.string;
            }
            
            [pbObjects insertObject:pbItem atIndex:0];
        }
    } else {
        self.tabBarItem.badgeValue = nil;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self addMostRecentPhotoTaken];
    });
    
    [self redisplayPasteboard];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    pageControl.currentPage = round(scrollView.contentOffset.x/320);
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
