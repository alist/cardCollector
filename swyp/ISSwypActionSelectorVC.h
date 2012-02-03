//
//  ISSwypActionSelector.h
//  swyp
//
//  Created by Alexander List on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISHistoryScrollVC.h"

///Hosts the swyp history view, presents a tab bar for actions at the bottom, the displays action views over the scrolling history
@interface ISSwypActionSelectorVC : UIViewController{

	ISHistoryScrollVC	*			_historyScrollView;
	UITabBarController *			_actionTabBar;
	
	NSManagedObjectContext *		_objectContext;
	
	swypWorkspaceViewController *	_swypWorkspace;
}
@property (nonatomic, retain) NSManagedObjectContext *		objectContext;
@property (nonatomic, retain) swypWorkspaceViewController *	swypWorkspace;

-(id) initWithObjectContext:(NSManagedObjectContext*)context;
@end