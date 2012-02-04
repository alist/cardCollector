//
//  ISTextHistoryCell.m
//  swyp
//
//  Created by Alexander List on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISTextHistoryCell.h"

@implementation ISTextHistoryCell
@synthesize contentDisplayView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		UITextView	* textDisplay	=	[[UITextView alloc] initWithFrame:CGRectInset([[self backgroundView] frame],25,25)];
		[textDisplay setEditable:FALSE];
		[textDisplay setScrollEnabled:FALSE];
		[textDisplay setDataDetectorTypes:UIDataDetectorTypeAll];
		
		[self setContentDisplayView:textDisplay];
	}
	return self;
}	

+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
	//Do NSString performances to see what hight will be needed
	
	return 100;
}

-(void)	updateCellContents{
	
}
@end
