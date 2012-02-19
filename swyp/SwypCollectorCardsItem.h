//
//  SwypCollectorCardsItem.h
//  swyp
//
//  Created by Alexander List on 2/19/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISSwypHistoryItem.h"

@interface SwypCollectorCardsItem : ISSwypHistoryItem
@property (nonatomic, strong)	NSString * personName;
@property (nonatomic, strong)	NSNumber * personRank;
@property (nonatomic, strong)	UIImage * personImage;

-(void) saveToObjData;
-(void) loadFromObjData;
@end
