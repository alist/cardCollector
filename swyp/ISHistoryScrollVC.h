//
//  ISHistoryScrollView.h
//  swyp
//
//  Created by Alexander List on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISHistoryScrollVC : UIViewController{
	NSManagedObjectContext *		_objectContext;
	swypWorkspaceViewController *	_swypWorkspace;
}
-(id) initWithObjectContext:(NSManagedObjectContext*)context swypWorkspace:(swypWorkspaceViewController*)workspace;
@end
