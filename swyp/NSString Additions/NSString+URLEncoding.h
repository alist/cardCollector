//
//  NSString+NSString_URLEncoding.h
//  swyp
//
//  Created by Ethan Sherbondy on 2/4/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//
//  http://madebymany.com/blog/url-encoding-an-nsstring-on-ios

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)

-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;

@end
