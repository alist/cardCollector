//
//  ISPreviewVC.m
//  swyp
//
//  Created by Alexander List on 2/8/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISPreviewVC.h"
#import <QuartzCore/QuartzCore.h>

@implementation ISPreviewVC
@synthesize displayedHistoryItem = _displayedHistoryItem;
@synthesize mapPreviewVC = _mapPreviewVC, webPreviewVC = _webPreviewVC, actionButtonView = _actionButtonView;

#pragma mark actions
-(void)pressedPasteboardButton:(UIButton*)sender{
	[sender setBackgroundColor:[UIColor colorWithRed:30/255 green:144/255 blue:255/255 alpha:.5]];
	[UIView animateWithDuration:.75 animations:^{
		[sender setBackgroundColor:[UIColor clearColor]];
	}];
	[[self displayedHistoryItem] addToPasteboard];
}
-(void)pressedSwypButton:(UIButton*)sender{
	[sender setBackgroundColor:[UIColor colorWithRed:30/255 green:144/255 blue:255/255 alpha:.5]];
	[UIView animateWithDuration:.75 animations:^{
		[sender setBackgroundColor:[UIColor clearColor]];
	}];

}
-(void)pressedExportButton:(UIButton*)sender{
	[sender setBackgroundColor:[UIColor colorWithRed:30/255 green:144/255 blue:255/255 alpha:.5]];
	[UIView animateWithDuration:.75 animations:^{
		[sender setBackgroundColor:[UIColor clearColor]];
	}];
}

#pragma mark previewer
-(void)setDisplayedHistoryItem:(ISSwypHistoryItem *)displayedHistoryItem{
	if (_displayedHistoryItem != displayedHistoryItem){
		_displayedHistoryItem = displayedHistoryItem;

		[_mapPreviewVC.view removeFromSuperview];
		[_webPreviewVC.view removeFromSuperview];
		
		UIView * previewView	=	[self previewVCForHistoryItem:displayedHistoryItem].view;
		[self.view addSubview:previewView];
		[self.view sendSubviewToBack:previewView];
	}
}

-(UIViewController*) previewVCForHistoryItem:(ISSwypHistoryItem*)historyItem{
	UIViewController * swypItemVC	=	nil;
	
	if ([[historyItem itemType] isFileType:[NSString swypAddressFileType]]){
		swypItemVC	=	[[self webPreviewVC] loadPreviewImageFromHistoryItem:historyItem];
	}else if ([[historyItem itemType] isFileType:[NSString swypContactFileType]]){
		swypItemVC	=	[[self webPreviewVC] loadPreviewImageFromHistoryItem:historyItem];		
	}else{
		swypItemVC	=	[[self webPreviewVC] loadContentFromHistoryItem:historyItem];
	}
	
	return swypItemVC;
}

-(UIView*)	actionButtonView{
	if (_actionButtonView == nil){
		UIView * actionView	=	[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
		[actionView setOrigin:CGPointMake(0, 0)];
		[actionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
		[actionView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"previewVCActionButtonsBGTile"]]];
		[actionView.layer setShadowColor: [[UIColor blackColor] CGColor]];
		[actionView.layer setShadowOpacity:0.8f];
		[actionView.layer setShadowOffset: CGSizeMake(0, 3)];
		[actionView.layer setShadowRadius:4.0];
		[actionView setClipsToBounds:NO];

		NSInteger viewThirdSize		=	(int)self.view.width/3;

		UIButton * pastboardButton	=	[UIButton buttonWithType:UIButtonTypeCustom];
		[pastboardButton setFrame:CGRectMake(0, 0, viewThirdSize, 40)];
		[pastboardButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin];
		[pastboardButton setShowsTouchWhenHighlighted:TRUE];
		[[pastboardButton titleLabel] setFont:[UIFont fontWithName:@"futura" size:12]];
		[pastboardButton titleLabel].highlightedTextColor	= [UIColor lightGrayColor];
		[pastboardButton setTitle:LocStr(@"Copy",@"preview of received swyp item") forState:UIControlStateNormal];
		
		[pastboardButton addTarget:self action:@selector(pressedPasteboardButton:) forControlEvents:UIControlEventTouchUpInside];
		[actionView addSubview:pastboardButton];
		
		UIButton * swypButton	=	[UIButton buttonWithType:UIButtonTypeCustom];
		[swypButton setFrame:CGRectMake(viewThirdSize, 0, viewThirdSize, 40)];
		[swypButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin];
		[swypButton setShowsTouchWhenHighlighted:TRUE];
		[[swypButton titleLabel] setFont:[UIFont fontWithName:@"futura" size:12]];
		[swypButton titleLabel].highlightedTextColor	= [UIColor lightGrayColor];
		[swypButton setTitle:LocStr(@"Swÿp",@"preview of received swyp item") forState:UIControlStateNormal];
		
		[swypButton addTarget:self action:@selector(pressedSwypButton:) forControlEvents:UIControlEventTouchUpInside];
		[actionView addSubview:swypButton];
		
		UIButton * exportButton	=	[UIButton buttonWithType:UIButtonTypeCustom];
		[exportButton setFrame:CGRectMake(viewThirdSize*2, 0, viewThirdSize, 40)];
		[exportButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth];
		[exportButton setShowsTouchWhenHighlighted:TRUE];
		[exportButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
		[[exportButton titleLabel] setFont:[UIFont fontWithName:@"futura" size:12]];
		[exportButton titleLabel].highlightedTextColor	= [UIColor lightGrayColor];
		[exportButton setTitle:LocStr(@"Export",@"preview of received swyp item") forState:UIControlStateNormal];
		
		[exportButton addTarget:self action:@selector(pressedExportButton:) forControlEvents:UIControlEventTouchUpInside];
		[actionView addSubview:exportButton];
		
		_actionButtonView = actionView;
	}
	return _actionButtonView;
}

-(ISPreviewMapViewVC*)mapPreviewVC{
	if (_mapPreviewVC == nil){
		_mapPreviewVC = [[ISPreviewMapViewVC alloc] init];
		[_mapPreviewVC.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
		[_mapPreviewVC.view setFrame:CGRectMake(0, [self actionButtonView].height, self.view.width, self.view.height)];

	}
	return _mapPreviewVC;
}

-(ISPreviewWebViewVC*)webPreviewVC{
	if (_webPreviewVC == nil){
		_webPreviewVC	=	[[ISPreviewWebViewVC alloc] init];
		[_webPreviewVC.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
		[_webPreviewVC.view setFrame:CGRectMake(0, [self actionButtonView].height, self.view.width, self.view.height - [self actionButtonView].height)];

	}
	return _webPreviewVC;
}

#pragma mark - UIViewController

-(void)viewDidLoad{
	[super viewDidLoad];
	
	[[[self navigationController] toolbar] setTintColor:[UIColor lightGrayColor]];
	[[self navigationItem] setTitle:LocStr(@"Preview", @"History item preview view")];
	
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reduceMemoryUsage) name: UIApplicationDidReceiveMemoryWarningNotification object: nil];
	
	[self setModalPresentationStyle:UIModalPresentationFullScreen];
	[self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
	
	[self.view setBackgroundColor:[UIColor lightGrayColor]];
	[self.view setClipsToBounds:TRUE];
	[self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	
	[self.view addSubview:[self actionButtonView]];
}

-(void) reduceMemoryUsage{
	
	if (_mapPreviewVC != nil && [_mapPreviewVC.view isDescendantOfView:self.view] == NO){
		[_mapPreviewVC.view removeFromSuperview];
		_mapPreviewVC  =	nil;
	}

	if (_webPreviewVC != nil && [_webPreviewVC.view isDescendantOfView:self.view] == NO){
		[_webPreviewVC.view removeFromSuperview];
		_webPreviewVC  =	nil;
	}

}

-(void) viewDidUnload{
	[super viewDidUnload];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
