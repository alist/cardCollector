//
//  ISHistoryScrollView.m
//  swyp
//
//  Created by Alexander List on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISHistoryScrollVC.h"
#import "ISDoodleRecognizingGestureRecognizer.h"
#include <QuartzCore/QuartzCore.h>


@implementation ISHistoryScrollVC
@synthesize swypDropZoneView = _swypDropZoneView, sectionedDataModel = _sectionedDataModel, resultsController = _resultsController, objectContext = _objectContext;
@synthesize datasourceDelegate = _datasourceDelegate;

#pragma mark - public
-(UIView*)swypDropZoneView{
	if (_swypDropZoneView == nil){
		
		_swypDropZoneView = [_swypWorkspace workspaceViewForEmbeddedSwypInWithFrame:CGRectMake(0, 0, self.view.size.width, (deviceIsPad)?300:200)];
		[_swypDropZoneView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];

		UIView * workspacePromptImageView	=	[_swypDropZoneView swypPromptImageView];
		CGPoint center	=	[workspacePromptImageView center];
		if (deviceIsPhone_ish){
			workspacePromptImageView.transform = CGAffineTransformScale([workspacePromptImageView transform], .7, .7);
			[workspacePromptImageView setCenter:center];
		}
		
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
	if (_resultsController == nil){
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
		[_swypWorkspace setContentDataSource:self];
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
	[_swypHistoryTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[_swypHistoryTableView setDelegate:self];
	
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

#pragma mark UITableViewDelegate
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	CGFloat height	=	0;
	
	id object  =  [(NITableViewModel*)[tableView dataSource] objectAtIndexPath:indexPath];
	id class	=	[object cellClass];
	if ([class respondsToSelector:@selector(heightForObject:atIndexPath:tableView:)]){
		height	=	[class heightForObject:object atIndexPath:indexPath tableView:tableView];
	}
	return height;
}

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

#pragma mark swypContentDataSourceProtocol

#pragma mark - delegation
- (NSArray*)	idsForAllContent{
	return nil;
}
- (UIImage *)	iconImageForContentWithID: (NSString*)contentID ofMaxSize:(CGSize)maxIconSize{	
	return nil;
	
}
- (NSArray*)		supportedFileTypesForContentWithID: (NSString*)contentID{
	return [NSArray arrayWithObjects:[NSString imagePNGFileType],[NSString imageJPEGFileType],nil];
}

- (NSData*)	dataForContentWithID: (NSString*)contentID fileType:	(swypFileTypeString*)type{
	NSData *	sendPhotoData	=	nil;	
	return sendPhotoData;
}

-(void)	setDatasourceDelegate:			(id<swypContentDataSourceDelegate>)delegate{
	_datasourceDelegate	=	delegate;
}
-(id<swypContentDataSourceDelegate>)	datasourceDelegate{
	return _datasourceDelegate;
}

-(void)	contentWithIDWasDraggedOffWorkspace:(NSString*)contentID{
	
	EXOLog(@"Dragged content off! %@",contentID);
	[_datasourceDelegate datasourceRemovedContentWithID:contentID withDatasource:self];
}

#pragma mark swypConnectionSessionDataDelegate
-(NSArray*)supportedFileTypesForReceipt{
	return [NSArray arrayWithObjects:[NSString textPlainFileType],[NSString imageJPEGFileType] ,[NSString imagePNGFileType], nil];
}

-(BOOL) delegateWillReceiveDataFromDiscernedStream:(swypDiscernedInputStream*)discernedStream ofType:(NSString*)streamType inConnectionSession:(swypConnectionSession*)session{
	if ([[NSSet setWithArray:[swypContentInteractionManager supportedReceiptFileTypes]] containsObject:[discernedStream streamType]]){
		return TRUE;
	}else{
		return FALSE;
	}
}

-(void)	yieldedData:(NSData*)streamData discernedStream:(swypDiscernedInputStream*)discernedStream inConnectionSession:(swypConnectionSession*)session{
	EXOLog(@" datasource received data of type: %@",[discernedStream streamType]);
	
	ISSwypHistoryItem* item	=	[NSEntityDescription insertNewObjectForEntityForName:@"SwypHistoryItem" inManagedObjectContext:[self objectContext]];
	[item setItemType:[discernedStream streamType]];
	[item setItemData:streamData];

	NSError * error = nil;
	if (![[self objectContext] save:&error]){
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	} 
	
	[self _refreshDataModel];
	[_swypHistoryTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
		
}

@end
