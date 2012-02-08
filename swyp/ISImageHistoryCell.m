//
//  ISImageHistoryCell.m
//  swyp
//
//  Created by Alexander List on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISImageHistoryCell.h"

@implementation ISImageHistoryCell
@synthesize contentDisplayView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		// Initialization code
		UIView * bgView		=	[[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor clearColor];
		UIImageView* nwImgView		=	[[UIImageView alloc]	initWithFrame:CGRectMake(0, 0, 100, 100)];
        nwImgView.backgroundColor = [UIColor clearColor];
		[nwImgView setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
        nwImgView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:nwImgView];
		
		[self setContentDisplayView:nwImgView];

	}
	return self;
}

-(void)	updateCellContents{
	[contentDisplayView setImage:[UIImage imageWithData:[[self historyItem] itemData]]];
}
@end
