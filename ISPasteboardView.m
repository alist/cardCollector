//
//  ISPasteboardView.m
//  swyp
//
//  Created by Ethan Sherbondy on 2/10/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ISPasteboardView.h"
#import "NSString+URLEncoding.h"
#import "UIImage+Resize.h"

static NSString *googleMapsURL = @"http://maps.googleapis.com/maps/api/staticmap?sensor=false&size=320x212&center=%@&zoom=13&scale=%i&markers=blue%%7C%@";

@implementation ISPasteboardView

@synthesize datasource = _datasource;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        _imageView = [[NINetworkImageView alloc] initWithFrame:frame];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        
        _textView = [[UITextView alloc] initWithFrame:frame];
        _textView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75];
        _textView.editable = NO;
        _textView.font = [UIFont systemFontOfSize:18];
        _textView.hidden = YES;
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = frame;
                
        [self addSubview:_imageView];
        [self addSubview:_textView];
        [self addSubview:_button];
                
    }
    return self;
}

- (void)setText:(NSString *)text {
    _textView.text = text;
    
    CGRect frame = _textView.frame;
    frame.size.height = _textView.contentSize.height;
    _textView.frame = frame;
    
    _textView.hidden = text ? NO : YES;
}

- (void)setAddress:(NSString *)address {
    NSLog(@"Setting address.");
    
    NSString *urlEncodedAddress = [address urlEncodeUsingEncoding:NSUTF8StringEncoding];
    NSInteger scale = [UIScreen mainScreen].scale;
    NSString *fullMapURL = [NSString stringWithFormat:googleMapsURL, 
                            urlEncodedAddress, scale, urlEncodedAddress];
    NSLog(@"%@", fullMapURL);
    [_imageView setPathToNetworkImage:fullMapURL];    
}

- (void)setImage:(UIImage *)image {
    NSLog(@"Setting image.");
    _imageView.image = image;
}

- (void)setDatasource:(id)theDatasource {
    NSLog(@"Setting the datasource.");
    
    _generatedThumbnail = nil; // clear out the generated thumbnail image
    _datasource = (ISPasteboardObject *)theDatasource;
    
    [_button addTarget:self.datasource action:@selector(displayInSwypWorkspace:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_datasource.image)   [self setImage:_datasource.image];
    if (_datasource.text)    [self setText:_datasource.text];
    if (_datasource.address) [self setAddress:_datasource.address];
    
}

- (UIImage *)getThumbnail {
    if (!_generatedThumbnail){
        UIGraphicsBeginImageContext(self.frame.size);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        _generatedThumbnail = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _generatedThumbnail;
}

- (CGSize)getSize {
    return self.size;
}

/*
- (void)drawRect:(CGRect)rect
{
}
*/

@end
