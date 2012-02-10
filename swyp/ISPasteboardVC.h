//
//  ISPasteboardVC.h
//  swyp
//
//  Created by Ethan Sherbondy on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "NINetworkImageView.h"
#import "ISPasteboardView.h"

@interface ISPasteboardVC : UIViewController {
    UIScrollView    *pbScrollView;
}

@property (assign, nonatomic) NSInteger pbChangeCount;
@property (strong, nonatomic) NSMutableArray *pbObjects;

- (void)updatePasteboard;

@end