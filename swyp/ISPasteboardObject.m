//
//  ISPasteboardObject.m
//  swyp
//
//  Created by Ethan Sherbondy on 2/10/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISPasteboardObject.h"

@implementation ISPasteboardObject

@synthesize delegate = _delegate;
@synthesize image = _image;
@synthesize text = _text;
@synthesize address = _address;

- (void)setDelegete:(id)delegete {
    _delegate = delegete;
    [self.delegate setImage:self.image];
    [self.delegate setText:self.text];
    [self.delegate setAddress:self.address];
}

- (void)setImage:(UIImage *)image {
    if (self.delegate){
        [self.delegate setImage:image];
    }
}

- (void)setText:(NSString *)text {
    if (self.delegate){
        [self.delegate setText:text];
    }
}

- (void)setAddress:(NSString *)address {
    self.text = address;
    
    if (self.delegate){
        [self.delegate setAddress:address];
    }
}

@end
