//
//  ISHistoryCell.m
//  swyp
//
//  Created by Alexander List on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISHistoryCell.h"
#import "NSDate+Relative.h"

@implementation ISHistoryCell
@synthesize historyItem	=	_historyItem, contentPreviewView = _contentPreviewView;
@synthesize dateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		self.selectionStyle		=	UITableViewCellSelectionStyleGray;
				
		[self setHeight:[[self class] heightForObject:nil atIndexPath:nil tableView:nil]];//otherwise frame is messed up for inset drawing
		
		UIView	* backgroundView		=	[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
		[backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight];
		backgroundView.backgroundColor	=	[UIColor whiteColor];
		[backgroundView setAlpha:.7];
		self.backgroundView				=	backgroundView;
		
		self.dateLabel			=	[[UILabel alloc] initWithFrame:CGRectMake(120, 8, 192, 20)];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.textColor = [UIColor grayColor];
        self.dateLabel.highlightedTextColor = [UIColor whiteColor];
		[self.dateLabel setTextAlignment:UITextAlignmentRight];
		[self.dateLabel setFont:[UIFont fontWithName:@"futura" size:12]];
		[self.dateLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
		[self addSubview:self.dateLabel];
		
		UIImageView* nwImgView		=	[[UIImageView alloc]	initWithFrame:CGRectMake(0, 0, 100, 100)];
		nwImgView.backgroundColor = [UIColor clearColor];
		[nwImgView setContentMode:UIViewContentModeScaleAspectFill];
		[nwImgView setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
		[self addSubview:nwImgView];
		
		[self setContentPreviewView:nwImgView];
		
	}
	return self;
}

- (BOOL)shouldUpdateCellWithObject:(id)object{
	if (_historyItem != object){
		_historyItem	=	object;
		[self.dateLabel setText:[[_historyItem dateAdded] distanceOfTimeInWordsToNow]];
		[self updateCellContents];
		return TRUE;
	}
	return FALSE;
}

+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
	return 100;
}

-(void)	updateCellContents{
	[[self contentPreviewView] setImage:[UIImage imageWithData:[[self historyItem] itemPreviewImage]]];
}
@end
