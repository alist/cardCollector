//
//  ISPreviewWebViewVC.h
//  swyp
//
//  Created by Alexander List on 2/8/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISSwypHistoryItem.h"

@interface ISPreviewWebViewVC : UIViewController
@property (nonatomic, strong) UIWebView* webView;

-(id)	loadPreviewImageFromHistoryItem:(ISSwypHistoryItem*)item;
-(id)	loadContentFromHistoryItem:		(ISSwypHistoryItem*)item;
@end
