//
//  ISPreviewVC.h
//  swyp
//
//  Created by Alexander List on 2/8/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISSwypHistoryItem.h"
#import "ISPreviewMapViewVC.h"
#import "ISPreviewWebViewVC.h"

@interface ISPreviewVC : UIViewController
@property (nonatomic, strong) UINavigationController *		navController;
@property (nonatomic, strong) ISSwypHistoryItem *			displayedHistoryItem;
@property (nonatomic, strong) ISPreviewMapViewVC *			mapPreviewVC;
@property (nonatomic, strong) ISPreviewWebViewVC *			webPreviewVC;

-(UIViewController*) previewVCForHistoryItem:(ISSwypHistoryItem*)historyItem;
@end
