//
//  ISTabVC.m
//  swyp
//
//  Created by Alexander List on 2/11/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISTabVC.h"

@implementation ISTabVC
@synthesize datasourceDelegate = _datasourceDelegate;

+(UITabBarItem*)tabBarItem{
	return nil;
}

-(void)viewDidLoad{
	[super viewDidLoad];
	
	self.view.autoresizingMask	=	UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	
	self.view.backgroundColor	=	[UIColor colorWithWhite:0 alpha:.5];
}

-(void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
}

-(void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
}

#pragma mark - delegation
#pragma mark <swypContentDataSourceProtocol, swypConnectionSessionDataDelegate>
- (NSArray*)	idsForAllContent{
	return nil;
}
- (UIImage *)	iconImageForContentWithID: (NSString*)contentID ofMaxSize:(CGSize)maxIconSize{	
	UIImage * returnImage	=	nil;
	if (returnImage == nil){
		returnImage	=	[UIImage imageNamed:@"swypPromptHud.png"];
	}
	return returnImage;
}

- (NSArray*)		supportedFileTypesForContentWithID: (NSString*)contentID{
	return nil;
}

- (NSData*)	dataForContentWithID: (NSString*)contentID fileType:	(swypFileTypeString*)type{
	NSData *	sendData	=	nil;	
	
	return sendData;
}

-(void)	setDatasourceDelegate:			(id<swypContentDataSourceDelegate>)delegate{
	_datasourceDelegate	=	delegate;
}
-(id<swypContentDataSourceDelegate>)	datasourceDelegate{
	return _datasourceDelegate;
}

-(void)	contentWithIDWasDraggedOffWorkspace:(NSString*)contentID{
	[_datasourceDelegate datasourceRemovedContentWithID:contentID withDatasource:self];
}

#pragma mark -
-(NSArray*)supportedFileTypesForReceipt{
	return nil;
}
-(void) yieldedData:(NSData *)streamData ofType:(NSString *)streamType fromDiscernedStream:(swypDiscernedInputStream *)discernedStream inConnectionSession:(swypConnectionSession *)session{
	
}



@end
