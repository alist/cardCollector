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
    __unsafe_unretained ISPasteboardObject *	_datasource;
    UIButton *_button;
    UIImage *_generatedThumbnail;
}

- (id)initWithFrame:(CGRect)frame andDataSource:(ISPasteboardObject *)theDatasource;

- (void)setImage:(UIImage *)image;
- (void)setText:(NSString *)text;
- (void)setAddress:(NSString *)address;
- (CGSize)getSize;

@property (nonatomic, assign) id datasource;

@end
