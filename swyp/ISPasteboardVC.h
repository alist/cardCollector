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

@interface ISPasteboardVC : UIViewController {
    UIScrollView *imageScrollView;
    NINetworkImageView *imageView;
    UITextView  *textView;
    NSArray     *pasteboardItems;
    NSString    *address;    
}

@property (strong, nonatomic) NSArray *pasteboardItems;

- (void)updatePasteboard;

@end