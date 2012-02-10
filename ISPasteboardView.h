//
//  ISPasteboardView.h
//  swyp
//
//  Created by Ethan Sherbondy on 2/10/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NINetworkImageView.h"
#import "ISPasteboardObject.h"

@interface ISPasteboardView : UIView <ISPasteboardObjectDelegate>{
    NINetworkImageView *_imageView;
    UITextView *_textView;
}

- (void)setImage:(UIImage *)image;
- (void)setText:(NSString *)text;
- (void)setAddress:(NSString *)address;

@end
