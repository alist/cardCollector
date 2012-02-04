//
//  ISPasteboardVC.h
//  swyp
//
//  Created by Ethan Sherbondy on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface ISPasteboardVC : UIViewController {
    UIImageView *imageView;
    UILabel     *textView;
    NSArray     *pasteboardItems;
}

@property (nonatomic, strong) NSArray *pasteboardItems;

- (void)updatePasteboard;

@end
