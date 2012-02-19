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

@class CardContactViewController;

@interface ISPreviewVC : UIViewController{
	id<swypContentDataSourceDelegate>	_datasourceDelegate;
}
@property (nonatomic, strong) ISSwypHistoryItem *			displayedHistoryItem;
@property (nonatomic, strong) ISPreviewMapViewVC *			mapPreviewVC;
@property (nonatomic, strong) ISPreviewWebViewVC *			webPreviewVC;
@property (nonatomic, strong) UIView *						actionButtonView;
@property (nonatomic, strong) UIButton *					exportButton;

-(UIViewController*) previewVCForHistoryItem:(ISSwypHistoryItem*)historyItem;
- (CardContactViewController *)cardContactVC;
//
//private
-(void) _updateExportButton;
@end
