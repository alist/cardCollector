//
//  ISSwypHistoryItem.m
//  swyp
//
//  Created by Alexander List on 2/4/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISSwypHistoryItem.h"
#import "ISHistoryCell.h"
#import "ISTextHistoryCell.h"
#import "ISImageHistoryCell.h"

@implementation ISSwypHistoryItem

@dynamic dateAdded;
@dynamic itemData;
@dynamic itemPreviewImage;
@dynamic itemTag;
@dynamic itemType;

-(void) awakeFromInsert{
	[super awakeFromInsert];
	[self setDateAdded:[NSDate date]];
}

- (Class)cellClass{
	if ([[self itemType] isFileType:[NSString imagePNGFileType]] || [[self itemType] isFileType:[NSString imageJPEGFileType]]){
		return [ISImageHistoryCell class];
	}else if ([[self itemType] isFileType:[NSString textPlainFileType]]){
		return [ISTextHistoryCell class];
	}
	return [ISHistoryCell class];
}

- (UITableViewCellStyle)cellStyle{
	return UITableViewCellStyleDefault;
}

@end
