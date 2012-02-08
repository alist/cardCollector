//
//  ISSwypHistoryItem.h
//  swyp
//
//  Created by Alexander List on 2/4/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NimbusModels.h"

@interface ISSwypHistoryItem : NSManagedObject <NICellObject>

@property (nonatomic, retain) NSDate * dateAdded;
@property (nonatomic, retain) NSData * itemData;
@property (nonatomic, retain) NSData * itemPreviewImage;
@property (nonatomic, retain) NSString * itemTag;
@property (nonatomic, retain) NSString * itemType;

@end
