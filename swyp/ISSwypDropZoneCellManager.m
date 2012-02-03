//
//  ISSwypDropZoneCellManager.m
//  swyp
//
//  Created by Alexander List on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISSwypDropZoneCellManager.h"
#import "ISSwypDropZoneCell.h"

@implementation ISSwypDropZoneCellManager
@synthesize dropView = _dropView;

-(id) initWithSwypDropView:(UIView *)dropView{
	if (self = [super init]){
		_dropView =	dropView;
	}
	return self;
}

- (Class)cellClass{
	return [ISSwypDropZoneCell class];
}

- (UITableViewCellStyle)cellStyle{
	return UITableViewCellStyleDefault;
}
@end
