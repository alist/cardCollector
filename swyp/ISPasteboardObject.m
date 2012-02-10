//
//  ISPasteboardObject.m
//  swyp
//
//  Created by Ethan Sherbondy on 2/10/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISPasteboardObject.h"
#import "UIImage+Resize.h"

@implementation ISPasteboardObject

@synthesize delegate = _delegate;
@synthesize image = _image;
@synthesize thumbImage = _thumbImage;
@synthesize text = _text;
@synthesize address = _address;

- (void)setDelegate:(id)delegete {
    _delegate = delegete;
    if (self.image)   [self setThumbImageFromCurrentImage];
    if (self.text)    [self.delegate setText:self.text];
    if (self.address) [self.delegate setAddress:self.address];
}

- (void)setThumbImageFromCurrentImage {
    self.thumbImage = [self.image resizedImageWithContentMode:UIViewContentModeScaleAspectFill 
                                                       bounds:[self.delegate getSize] 
                                         interpolationQuality:0.8];
    [self.delegate setImage:self.thumbImage];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    
    if (self.delegate && image){
        [self setThumbImageFromCurrentImage];
    }
}

- (void)setText:(NSString *)text {
    _text = text;
    
    if (self.delegate && text){
        [self.delegate setText:text];
    }
}

- (void)setAddress:(NSString *)address {
    self.text = address;
    _address = address;
    
    if (self.delegate && address){
        [self.delegate setAddress:address];
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Text: %@ Address: %@ Image: %@", self.text, self.address, self.image];
}

@end
