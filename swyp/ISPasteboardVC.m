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
#import <CoreLocation/CoreLocation.h>

@implementation ISPasteboardVC

@synthesize pbChangeCount;
@synthesize pbObjects;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Relevant", @"Tab bar item for relevant things") 
                                                        image:[UIImage imageNamed:@"paperclip"] tag:2];

#warning this file has several delegation-related compilation warnings related to "setDatasource" and the pastboard items
		
#warning move all this initialization to viewdidload
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        self.view.backgroundColor = [UIColor whiteColor];
#warning use variables to calculate frame; use superview frame during viewdidload to avoid issues with UIWindow's orientation when launching in landscape
        self.view.frame = CGRectMake(0, screenSize.height-(212+49+20), screenSize.width, 212);
        self.view.autoresizesSubviews = YES;
#warning add autoresizing mask item for flexibleTopMargin to maintain the stickiness to the bottom of the screen
        self.view.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth);
        
#warning init the frame of the view with the bounds of the self.view.bounds for your convenience withFrame:self.view.bounds
        pbScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
        pbScrollView.showsHorizontalScrollIndicator = NO;
        pbScrollView.pagingEnabled = YES;
        pbScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        pbScrollView.delegate = self;
        [self.view addSubview:pbScrollView];
        
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 212-24, screenSize.width, 24)];
        [self.view addSubview:pageControl];
        
        self.pbObjects = [NSMutableArray array];
        
        library = [[ALAssetsLibrary alloc] init];
    }
    
    pbChangeCount = 0;
    
    return self;
}



- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];	
}

- (void)addMostRecentPhotoTaken {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop){
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];

            // only grab the most recent asset
            [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:([group numberOfAssets]-1)] options:0 usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop){
                if (alAsset){
                    NSDate *timeTaken = [alAsset valueForProperty:ALAssetPropertyDate];
                    
                    // we only care if the photo was taken in the last 3 minutes
                    if (abs([timeTaken timeIntervalSinceNow]) < 60*3){
                        __block CGImageRef imgRef = CGImageRetain([[alAsset defaultRepresentation] fullScreenImage]);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (alAsset.defaultRepresentation.url != latestAssetURL){
                                
                                self.tabBarItem.badgeValue = @"!";
                                
                                latestAssetURL = alAsset.defaultRepresentation.url;
                                NSLog(@"Adding image!");
                                ISPasteboardObject *pbItem = [[ISPasteboardObject alloc] init];
                                pbItem.image = [UIImage imageWithCGImage:imgRef];
                                [self.pbObjects insertObject:pbItem atIndex:0];

                                [self redisplayPasteboard];
                            }
                        });                    
                    }                
                }
            }];
        } failureBlock:^(NSError *error) {
            NSLog(@"No groups, %@", error);
        }];
    });
}

- (void)redisplayPasteboard {
    for (id subview in [pbScrollView subviews]){
        if ([subview class] == [ISPasteboardView class]){
            [subview removeFromSuperview];
        }
    }
    
    NSLog(@"%@", pbObjects);
    
    int i = 0;
    for (ISPasteboardObject *pbObject in pbObjects){
        ISPasteboardView *pasteView = [[ISPasteboardView alloc] initWithFrame:
                                       CGRectMake(i*320, 0, 320, self.view.height)];
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
                
        if (pasteBoard.images) {
            for (UIImage *image in pasteBoard.images){
                ISPasteboardObject *pbItem = [[ISPasteboardObject alloc] init];
                pbItem.image = image;
                pbItem.text = nil;
                
                [pbObjects insertObject:pbItem atIndex:0];
            }
        }else if (pasteBoard.URL) {
            ISPasteboardObject *pbItem = [[ISPasteboardObject alloc] init];

            pbItem.text = [pasteBoard.URL absoluteString];
            
            [pbObjects insertObject:pbItem atIndex:0];
        
        } else if (pasteBoard.string) {
            
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
        [self addMostRecentPhotoTaken];
    }
    
    [self redisplayPasteboard];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    pageControl.currentPage = round(scrollView.contentOffset.x/320);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
