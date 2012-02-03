//
//  ISHistoryScrollView.m
//  swyp
//
//  Created by Alexander List on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISHistoryScrollVC.h"

@implementation ISHistoryScrollVC

#pragma mark - UIViewController
-(id) initWithObjectContext:(NSManagedObjectContext*)context swypWorkspace:(swypWorkspaceViewController*)workspace{
	if (self  = [super initWithNibName:nil bundle:nil]){
		_objectContext	=	context;
		_swypWorkspace	=	workspace;
	}
	return self;
}

-(void) dealloc{
	_swypWorkspace = nil;
	_objectContext = nil;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	
	[self.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"historyBGTile"]]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
	if (deviceIsPhone_ish){
		return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	}else{
		return TRUE;
	}
}

@end
