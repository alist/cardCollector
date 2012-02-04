//
//  ISImageHistoryCell.m
//  swyp
//
//  Created by Alexander List on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISImageHistoryCell.h"

@implementation ISImageHistoryCell
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

-(void)	updateCellContents{
	
}
@end
