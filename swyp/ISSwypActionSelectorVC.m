//
//  ISSwypActionSelector.m
//  swyp
//
//  Created by Alexander List on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISSwypActionSelectorVC.h"

@implementation ISSwypActionSelectorVC
@synthesize objectContext = _objectContext, swypWorkspace = _swypWorkspace;

-(swypWorkspaceViewController*)swypWorkspace{
	if (_swypWorkspace == nil){
		_swypWorkspace = [[swypWorkspaceViewController alloc] init];
	}
	return _swypWorkspace;
}

#pragma mark - NSObject
-(id) initWithObjectContext:(NSManagedObjectContext*)context{
	if (self  = [super initWithNibName:nil bundle:nil]){
		_objectContext	=	context;
	}
	return self;
}

#pragma mark - UIViewController

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	
	[self.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	
	_historyScrollView	=	[[ISHistoryScrollVC alloc] initWithObjectContext:_objectContext swypWorkspace:[self swypWorkspace]];
	[_historyScrollView.view setFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height-49)];//tab bar height
	[self.view addSubview:_historyScrollView.view];
	
	_actionTabBar		=	[[UITabBarController alloc] init];
	//tab bar at bottom
	
	//we get callbacks from tab bar, then add views above the histroy scrollview
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
	if (deviceIsPhone_ish){
		return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	}else{
		return TRUE;
	}
}

@end