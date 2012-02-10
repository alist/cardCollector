//
//  ISHistoryCell.h
//  swyp
//
//  Created by Alexander List on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NimbusModels.h"
#import "ISSwypHistoryItem.h"

@interface ISHistoryCell : UITableViewCell <NICell>

@property (nonatomic, strong) ISSwypHistoryItem	*	historyItem;
@property (nonatomic, strong) UIImageView *			contentPreviewView;
@property (nonatomic, retain) UILabel *				dateLabel;

-(void)	updateCellContents;

@end
