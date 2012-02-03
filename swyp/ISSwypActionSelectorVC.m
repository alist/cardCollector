//
//  ISSwypActionSelector.m
//  swyp
//
//  Created by Alexander List on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISSwypActionSelectorVC.h"
#import "ISContactVC.h"
#import "ISPhotoVC.h"
#import "ISCalendarVC.h"
#import "ISPasteboardVC.h"

@implementation ISSwypActionSelectorVC
@synthesize objectContext = _objectContext, swypWorkspace = _swypWorkspace;

-(swypWorkspaceViewController*)swypWorkspace{
	if (_swypWorkspace == nil){
		_swypWorkspace = [[swypWorkspaceViewController alloc] init];
	}
	return _swypWorkspace;
}

#pragma mark - NSObject
-(id) initWithObjectContext:(NSManagedObjectContext*)context{
	if (self  = [super initWithNibName:nil bundle:nil]){
		_objectContext	=	context;
	}
	return self;
}

#pragma mark - UIViewController

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	
	[self.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	
	_historyScrollView	=	[[ISHistoryScrollVC alloc] initWithObjectContext:_objectContext swypWorkspace:[self swypWorkspace]];
	[_historyScrollView.view setFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height-49)];//tab bar height
	[self.view addSubview:_historyScrollView.view];
    
    ISContactVC *contactVC = [[ISContactVC alloc] initWithNibName:nil bundle:nil];
    ISPhotoVC *photoVC = [[ISPhotoVC alloc] initWithNibName:nil bundle:nil];
    ISCalendarVC *calendarVC = [[ISCalendarVC alloc] initWithNibName:nil bundle:nil];
    ISPasteboardVC *pasteboardVC = [[ISPasteboardVC alloc] initWithNibName:nil bundle:nil];
    
    NSArray *viewControllers = [NSArray arrayWithObjects:contactVC, photoVC, calendarVC, pasteboardVC, nil];
    NSMutableArray *tabBarItems = [NSMutableArray array];
    for (UIViewController *VC in viewControllers) {
        [tabBarItems addObject:VC.tabBarItem];
    }
	
	_actionTabBar		=	[[UITabBar alloc] initWithFrame:CGRectMake(0, (self.view.size.height - 49), self.view.size.width, 49)];
    
    _actionTabBar.items = tabBarItems;
    _actionTabBar.delegate = self;
    
    [self.view addSubview:_actionTabBar];
    
	//tab bar at bottom
	
	//we get callbacks from tab bar, then add views above the histroy scrollview
	
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (tabBar.selectedItem.tag == _selectedTab) {
        tabBar.selectedItem = nil;
        _selectedTab = -1;
    } else {
        _selectedTab = item.tag;
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
	if (deviceIsPhone_ish){
		return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	}else{
		return TRUE;
	}
}

@end