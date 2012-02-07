//
//  ISHistoryScrollView.h
//  swyp
//
//  Created by Alexander List on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NimbusModels.h"


///The view that shows a swyp workspace drop-zone in the header, and the history of all swyp-received content below
@interface ISHistoryScrollVC : UIViewController <UITableViewDelegate, NSFetchedResultsControllerDelegate, swypContentDataSourceDelegate>{
	NSManagedObjectContext *		_objectContext;
	swypWorkspaceViewController *	_swypWorkspace;
	
	UITableView *					_swypHistoryTableView;
	
}
@property (nonatomic, strong) UIView *						swypDropZoneView;
@property (nonatomic, strong) NITableViewModel *			sectionedDataModel;
@property (nonatomic, strong) NSFetchedResultsController*	resultsController;

-(id) initWithObjectContext:(NSManagedObjectContext*)context swypWorkspace:(swypWorkspaceViewController*)workspace;


//
//private
-(NSFetchRequest*)	_newOrUpdatedFetchRequest;
-(void)				_refreshDataModel;
@end
