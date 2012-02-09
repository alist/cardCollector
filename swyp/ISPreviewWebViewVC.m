//
//  ISPreviewWebViewVC.m
//  swyp
//
//  Created by Alexander List on 2/8/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISPreviewWebViewVC.h"

@implementation ISPreviewWebViewVC
@synthesize webView;

-(void)viewDidLoad{
	[super viewDidLoad];

	self.webView = [UIWebView new];
	[self.webView setScalesPageToFit:TRUE];
	[self.webView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
	[self.webView setClipsToBounds:TRUE];
	[self.webView setFrame:[self.view bounds]];
	[self setView:webView];

}

-(id)	loadPreviewImageFromHistoryItem:(ISSwypHistoryItem*)item{
	
	[self.webView loadData:[item itemPreviewImage] MIMEType:[swypFileTypeString imageJPEGFileType] textEncodingName:@"utf-8" baseURL:nil];

	
	return self;
}
-(id)	loadContentFromHistoryItem:		(ISSwypHistoryItem*)item{
	if (self.view)
		[self.webView loadData:[item itemData] MIMEType:[item itemType] textEncodingName:@"utf-8" baseURL:nil];

	return self;
}
@end
