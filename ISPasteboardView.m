//
//  ISPasteboardView.m
//  swyp
//
//  Created by Ethan Sherbondy on 2/10/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISPasteboardView.h"
#import "NSString+URLEncoding.h"

static NSString *googleMapsURL = @"http://maps.googleapis.com/maps/api/staticmap?sensor=false&size=320x212&center=%@&zoom=13&scale=%i&markers=blue%%7C%@";

@implementation ISPasteboardView

@synthesize image = _image;
@synthesize text = _text;
@synthesize address = _address;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, 320, 212);
        
        _imageView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _imageView.hidden = YES;
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _textView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75];
        _textView.editable = NO;
        _textView.font = [UIFont systemFontOfSize:18];
        
        _textView.hidden = YES;
        
        [self addSubview:_imageView];
        [self addSubview:_textView];
    }
    return self;
}

- (void)setText:(NSString *)text {
    _text = text;
    _textView.text = text;
    
    CGRect frame = _textView.frame;
    frame.size.height = _textView.contentSize.height;
    _textView.frame = frame;
    
    _textView.hidden = text ? NO : YES;
}

- (void)setAddress:(NSString *)address {
    NSLog(@"Setting address.");
    _address = address;
    
    self.text = [address capitalizedString];
    NSString *urlEncodedAddress = [address urlEncodeUsingEncoding:NSUTF8StringEncoding];
    NSInteger scale = [UIScreen mainScreen].scale;
    NSString *fullMapURL = [NSString stringWithFormat:googleMapsURL, 
                            urlEncodedAddress, scale, urlEncodedAddress];
    NSLog(@"%@", fullMapURL);
    [_imageView setPathToNetworkImage:fullMapURL];
    _imageView.hidden = NO;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _imageView.image = image;
    
    _imageView.hidden = image ? NO : YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
