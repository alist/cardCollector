//
//  ISHistoryScrollView.m
//  swyp
//
//  Created by Alexander List on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISHistoryScrollVC.h"
#import "ISSwypDropZoneCellManager.h"
#import "ISDoodleRecognizingGestureRecognizer.h"

@implementation ISHistoryScrollVC
@synthesize swypDropZoneView = _swypDropZoneView, sectionedDataModel = _sectionedDataModel;

#pragma mark - public
-(UIView*)swypDropZoneView{
	if (_swypDropZoneView == nil){
		_swypDropZoneView = [[swypWorkspaceBackgroundView alloc] initWithFrame:CGRectMake(0, 0, self.view.size.width, (deviceIsPad)?300:200)];
		[_swypDropZoneView setAutoresizingMask:UIViewAutoresizingNone];
		
		
		ISDoodleRecognizingGestureRecognizer * doodleGest	=	[[ISDoodleRecognizingGestureRecognizer alloc] initWithTarget:nil action:nil];
		
		[[self swypDropZoneView] addGestureRecognizer:doodleGest];
		
		assert(_swypHistoryTableView != nil);
		for (UIGestureRecognizer *gesture in _swypHistoryTableView.gestureRecognizers){
			[gesture requireGestureRecognizerToFail:doodleGest];
		}
		
	}
	return _swypDropZoneView;
}

#pragma mark - UIViewController
-(id) initWithObjectContext:(NSManagedObjectContext*)context swypWorkspace:(swypWorkspaceViewController*)workspace{
	if (self  = [super initWithNibName:nil bundle:nil]){
		_objectContext	=	context;
		_swypWorkspace	=	workspace;
	}
	return self;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	
	[self.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"historyBGTile"]]];
	
	_swypHistoryTableView		=	[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
	[_swypHistoryTableView setBackgroundColor:[UIColor clearColor]];
	[_swypHistoryTableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	
	[_swypHistoryTableView setDataSource:[self sectionedDataModel]];
	[_swypHistoryTableView setTableHeaderView:[self swypDropZoneView]]; 
	[self.view addSubview:_swypHistoryTableView];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
	if (deviceIsPhone_ish){
		return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	}else{
		return TRUE;
	}
}

#pragma mark - private
-(NITableViewModel*) sectionedDataModel{
	if (_sectionedDataModel == nil){
		NSMutableArray	* sectionArray	=	[[NSMutableArray alloc] init];
//		[sectionArray addObject:LocStr(@"Swÿp Drop Zone",@"On history view for people to swyp-in stuff")];
//		[sectionArray addObject:[[ISSwypDropZoneCellManager alloc] initWithSwypDropView:[self swypDropZoneView]]];
		[sectionArray addObject:LocStr(@"recently recieved",@"On history view for people to view stuff received")];
		_sectionedDataModel	=	[[NITableViewModel alloc] initWithSectionedArray:sectionArray delegate:(id)[NICellFactory class]];
	}
	return _sectionedDataModel;
}



@end
