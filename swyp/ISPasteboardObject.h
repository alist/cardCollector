//
//  ISPasteboardObject.h
//  swyp
//
//  Created by Ethan Sherbondy on 2/10/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ISPasteboardObjectDelegate <NSObject>

@required
- (void)setImage:(UIImage *)image;
- (void)setText:(NSString *)text;
- (void)setAddress:(NSString *)address;
- (void)setDatasource:(id)datasource;
- (UIImage *)getThumbnail;
- (CGSize)getSize;
@end

@interface ISPasteboardObject : NSObject <swypContentDataSourceProtocol, swypConnectionSessionDataDelegate> {
    __unsafe_unretained id <ISPasteboardObjectDelegate> delegate;
    id<swypContentDataSourceDelegate>	_datasourceDelegate;
}

@property (nonatomic, assign) id <ISPasteboardObjectDelegate> delegate;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *itemType;

- (void)displayInSwypWorkspace:(id)sender;

@end