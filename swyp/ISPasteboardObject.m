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

- (void)setDelegate:(id)delegete {
    NSLog(@"Setting delegate");
    _delegate = delegete;
    [self.delegate setImage:self.image];
    [self.delegate setText:self.text];
    [self.delegate setAddress:self.address];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    
    if (self.delegate){
        [self.delegate setImage:image];
    }
}

- (void)setText:(NSString *)text {
    _text = text;
    
    if (self.delegate){
        [self.delegate setText:text];
    }
}

- (void)setAddress:(NSString *)address {
    self.text = address;
    _address = address;
    
    if (self.delegate){
        [self.delegate setAddress:address];
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Text: %@ Address: %@ Image: %@", self.text, self.address, self.image];
}

@end
