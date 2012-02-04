//
//  ISHistoryCell.m
//  swyp
//
//  Created by Alexander List on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISHistoryCell.h"

@implementation ISHistoryCell
@synthesize historyItem	=	_historyItem, contentDisplayView = _contentDisplayView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		self.selectionStyle		=	UITableViewCellSelectionStyleGray;
		
		[self setHeight:100];
		
		UIView	* backgroundView		=	[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
		[backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight];
		backgroundView.backgroundColor	=	[UIColor whiteColor];
		
		self.backgroundView				=	backgroundView;
		
	}
	return self;
}

- (BOOL)shouldUpdateCellWithObject:(id)object{
	if (_historyItem != object){
		_historyItem	=	object;
		[self updateCellContents];
		return TRUE;
	}
	return FALSE;
}

+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
	return 100;
}

-(void)	updateCellContents{
	
}
@end
