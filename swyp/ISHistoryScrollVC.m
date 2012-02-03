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
		_objectContext	=	[context retain];
		_swypWorkspace	=	[workspace retain];
	}
	return self;
}

-(void) dealloc{
	SRELS(_swypWorkspace);
	SRELS(_objectContext);
	[super dealloc];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	
	[self.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	[self.view setFrame:CGRectMake(0, 0, self.view.superview.size.width, self.view.superview.size.height - 49)];//tab bar sizing
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
