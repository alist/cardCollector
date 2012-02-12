//
//  ISCalendarVC.m
//  swyp
//
//  Created by Ethan Sherbondy on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISCalendarVC.h"
#import <QuartzCore/QuartzCore.h>

@implementation ISCalendarVC
@synthesize calendarDataSource = _calendarDataSource, kalVC = _kalVC;
//temp
@synthesize exportingCalImage;

+(UITabBarItem*)tabBarItem{
	return [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Calendar", @"Your calendar events on the tab bar.") image:[UIImage imageNamed:@"calendar"] tag:1];
}

#pragma mark -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[self class] tabBarItem];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	
	
	_calendarDataSource			=	[ISEventKitDataSource dataSource];
	_kalVC	=	[[KalViewController alloc] initWithSelectedDate:[NSDate date]];
	[_kalVC setDataSource:_calendarDataSource];
	[_kalVC setDelegate:self];
	[_kalVC.view setFrame:self.view.bounds];
	[_kalVC.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	[self.view addSubview:_kalVC.view];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
	return YES;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell * cell	=	[tableView cellForRowAtIndexPath:indexPath];
	UIGraphicsBeginImageContextWithOptions(cell.size,YES, 0);
	[cell.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	self.exportingCalImage	=	image;
	
	[[swypWorkspaceViewController sharedSwypWorkspace] setContentDataSource:self];
	[[self datasourceDelegate] datasourceSignificantlyModifiedContent:self];
	[[swypWorkspaceViewController sharedSwypWorkspace] presentContentWorkspaceAtopViewController:[[[UIApplication sharedApplication] keyWindow] rootViewController]];
}

#pragma mark <swypContentDataSourceProtocol, swypConnectionSessionDataDelegate>
- (NSArray*)	idsForAllContent{
	return [NSArray arrayWithObject:@"PREVIEW_DISPLAYED_CAL_ITEM"];
}
- (UIImage *)	iconImageForContentWithID: (NSString*)contentID ofMaxSize:(CGSize)maxIconSize{	
	UIImage * returnImage	=	self.exportingCalImage;
	if (returnImage == nil){
		returnImage	=	[UIImage imageNamed:@"swypPromptHud.png"];
	}
	return returnImage;
}

- (NSArray*)		supportedFileTypesForContentWithID: (NSString*)contentID{
	return [NSArray arrayWithObjects:[NSString imageJPEGFileType],[NSString imagePNGFileType], nil];
}

- (NSData*)	dataForContentWithID: (NSString*)contentID fileType:	(swypFileTypeString*)type{
	NSData *	sendData	=	nil;	
	
	if ([type isFileType:[NSString imagePNGFileType]]){
		sendData	=	UIImagePNGRepresentation(self.exportingCalImage);
	}else if ([type isFileType:[NSString imageJPEGFileType]]){
		sendData	=	 UIImageJPEGRepresentation(self.exportingCalImage,.8);
	}else{
		EXOLog(@"No data coverage for content type %@ of ID %@",type,contentID);
	}
	
	
	return sendData;
}


@end
