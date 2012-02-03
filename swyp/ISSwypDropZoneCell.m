//
//  ISSwypDropZoneCell.m
//  swyp
//
//  Created by Alexander List on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISSwypDropZoneCell.h"

@implementation ISSwypDropZoneCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
	}
	return self;
}

- (BOOL)shouldUpdateCellWithObject:(id)object{
	if (_dropZoneManager != object){
		_dropZoneManager	=	object;
		
		[self setBackgroundView:[_dropZoneManager dropView]];
	}
	return FALSE;
}

+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
	if (deviceIsPhone_ish){
		return 200;
	}else{
		return 300;
	}
}

@end
