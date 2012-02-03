//
//  ISSwypActionSelector.h
//  swyp
//
//  Created by Alexander List on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISHistoryScrollView.h"
@interface ISSwypActionSelector : UIViewController{

	ISHistoryScrollView	*			_swypHistoryScrollView;
	
	NSManagedObjectContext *		_objectContext;
	
	swypWorkspaceViewController *	_swypWorkspace;
}
@property (nonatomic, retain) NSManagedObjectContext *		objectContext;
@property (nonatomic, retain) swypWorkspaceViewController *	swypWorkspace;
@end
