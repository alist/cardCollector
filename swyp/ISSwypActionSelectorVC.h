//
//  ISSwypActionSelector.h
//  swyp
//
//  Created by Alexander List on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISHistoryScrollVC.h"
#import "ISPasteboardVC.h"

///Hosts the swyp history view, presents a tab bar for actions at the bottom, the displays action views over the scrolling history
@interface ISSwypActionSelectorVC : UIViewController <UITabBarDelegate>{

	ISHistoryScrollVC	*			_historyScrollView;
	UITabBar *                      _actionTabBar;
    NSInteger                       _selectedTab; // the tag value
	
	NSManagedObjectContext *		_objectContext;
	
	swypWorkspaceViewController *	_swypWorkspace;
    NSArray *                       _viewControllers;
    
    ISPasteboardVC *                _pasteboardVC;
}
@property (nonatomic, strong) NSManagedObjectContext *		objectContext;
@property (nonatomic, strong) swypWorkspaceViewController *	swypWorkspace;

-(id) initWithObjectContext:(NSManagedObjectContext*)context;
- (void)updatePasteboard;

@end
