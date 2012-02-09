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
@synthesize mapPreviewVC = _mapPreviewVC, webPreviewVC = _webPreviewVC;

//need to add "display from view" property
//which will screenshot and set SS to background view
//need to prevent funky uiview scrolling
//need to add nice button for actions in corner

#pragma mark previewer
-(void)setDisplayedHistoryItem:(ISSwypHistoryItem *)displayedHistoryItem{
	if (_displayedHistoryItem != displayedHistoryItem){
		_displayedHistoryItem = displayedHistoryItem;

		[self.view addSubview:[self previewVCForHistoryItem:displayedHistoryItem].view];
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

-(ISPreviewMapViewVC*)mapPreviewVC{
	if (_mapPreviewVC == nil){
		_mapPreviewVC = [[ISPreviewMapViewVC alloc] init];
		[_mapPreviewVC.view.layer setCornerRadius:10];
		[_mapPreviewVC.view setBounds:CGRectInset(self.view.bounds, 15, 20)];

	}
	return _mapPreviewVC;
}

-(ISPreviewWebViewVC*)webPreviewVC{
	if (_webPreviewVC == nil){
		_webPreviewVC	=	[[ISPreviewWebViewVC alloc] init];
		[_webPreviewVC.view.layer setCornerRadius:10];
		[_webPreviewVC.view setBounds:CGRectInset(self.view.bounds, 15, 20)];

	}
	return _webPreviewVC;
}

#pragma mark - UIViewController
-(void) dismissVC{
	[self dismissModalViewControllerAnimated:TRUE];
}

-(void)viewDidLoad{
	[super viewDidLoad];
	
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reduceMemoryUsage) name: UIApplicationDidReceiveMemoryWarningNotification object: nil];
	
	[self setModalPresentationStyle:UIModalPresentationFullScreen];
	[self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
	
	[self.view setBackgroundColor:[UIColor lightGrayColor]];
	[self.view setClipsToBounds:TRUE];
	[self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	
	UITapGestureRecognizer * dismissViewRecognizer	=	[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissVC)];
	[self.view addGestureRecognizer:dismissViewRecognizer];
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
