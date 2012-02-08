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

@interface ISPasteboardVC : UIViewController <swypSwypableContentSuperviewContentDelegate, swypContentDataSourceProtocol, swypConnectionSessionDataDelegate> {
    __weak id<swypContentDataSourceDelegate>	_delegate;
    NINetworkImageView *imageView;
    UILabel     *textView;
    NSArray     *pasteboardItems;
    NSString    *address;
    
    swypWorkspaceViewController*	_swypWorkspace;
}

@property (strong, nonatomic) NSArray *pasteboardItems;
@property (strong, nonatomic) swypWorkspaceViewController * swypWorkspace;

- (void)updatePasteboard;

@end
