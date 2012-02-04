//
//  ISHistoryScrollView.m
//  swyp
//
//  Created by Alexander List on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISHistoryScrollVC.h"
#import "ISDoodleRecognizingGestureRecognizer.h"

@implementation ISHistoryScrollVC
@synthesize swypDropZoneView = _swypDropZoneView, sectionedDataModel = _sectionedDataModel, resultsController = _resultsController;

#pragma mark - public
-(UIView*)swypDropZoneView{
	if (_swypDropZoneView == nil){
		_swypDropZoneView = [[swypWorkspaceBackgroundView alloc] initWithFrame:CGRectMake(0, 0, self.view.size.width, (deviceIsPad)?300:200)];
		[_swypDropZoneView setAutoresizingMask:UIViewAutoresizingNone];
		
		
		ISDoodleRecognizingGestureRecognizer * doodleGest	=	[[ISDoodleRecognizingGestureRecognizer alloc] initWithTarget:nil action:nil];		
		[[self view] addGestureRecognizer:doodleGest];
		
		assert(_swypHistoryTableView != nil);
		for (UIGestureRecognizer *gesture in _swypHistoryTableView.gestureRecognizers){
			[gesture requireGestureRecognizerToFail:doodleGest];
		}
		
	}
	return _swypDropZoneView;
}

-(NSFetchedResultsController*)resultsController{
	if (_resultsController == nil)
	{
		
		NSFetchRequest *request = [self _newOrUpdatedFetchRequest];
		_resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:_objectContext sectionNameKeyPath:nil cacheName:nil];
		[_resultsController setDelegate:self];
	}
	return _resultsController;
}

-(NITableViewModel*) sectionedDataModel{
	if (_sectionedDataModel == nil){
		NSMutableArray	* sectionArray	=	[[NSMutableArray alloc] init];
		[sectionArray addObject:LocStr(@"recently recieved",@"On history view for people to view stuff received")];
		NSArray	* historyItems			= [[self resultsController] fetchedObjects];
		[sectionArray addObjectsFromArray:historyItems];
		_sectionedDataModel	=	[[NITableViewModel alloc] initWithSectionedArray:sectionArray delegate:(id)[NICellFactory class]];
	}
	return _sectionedDataModel;
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
//	[_swypHistoryTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	
	[_swypHistoryTableView setTableHeaderView:[self swypDropZoneView]]; 
	[self.view addSubview:_swypHistoryTableView];
	
	NSError *error = nil;
	[[self resultsController] performFetch:&error];
	if (error != nil){
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		[NSException exceptionWithName:[error domain] reason:[error description] userInfo:nil];
	}	
	[self _refreshDataModel];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
	if (deviceIsPhone_ish){
		return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	}else{
		return TRUE;
	}
}

#pragma mark - private
-(NSFetchRequest*)	_newOrUpdatedFetchRequest{
	NSFetchRequest* request = nil;
	request = _resultsController.fetchRequest;
	
	if (request == nil){
		NSEntityDescription *requestEntity =	[NSEntityDescription entityForName:@"SwypHistoryItem" inManagedObjectContext:_objectContext];
		
		request = [[NSFetchRequest alloc] init];
		[request setEntity:requestEntity];
		[request setFetchLimit:20];
	}
	
	NSSortDescriptor *dateSortOrder = [[NSSortDescriptor alloc] initWithKey:@"dateAdded" ascending:FALSE];
	[request setSortDescriptors:[NSArray arrayWithObjects:dateSortOrder, nil]];
	
	return request;
}

-(void)	_refreshDataModel{
	_sectionedDataModel = nil;
	[_swypHistoryTableView setDataSource:[self sectionedDataModel]];
}

#pragma mark - delegation
#pragma mark NSFetchedResultsController
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
	[self _refreshDataModel];
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
	
    if (type == NSFetchedResultsChangeInsert){
//		[_swypHistoryTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }else if (type == NSFetchedResultsChangeMove){
	}else if (type == NSFetchedResultsChangeUpdate){
	}else if (type == NSFetchedResultsChangeDelete){
	}
}
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
}


@end
