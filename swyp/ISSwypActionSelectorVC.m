//
//  ISSwypActionSelector.m
//  swyp
//
//  Created by Alexander List on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISSwypActionSelectorVC.h"
#import "ISContactVC.h"
#import "ISCalendarVC.h"
#import "NIDeviceOrientation.h"

@implementation ISSwypActionSelectorVC
@synthesize objectContext = _objectContext, swypWorkspace = _swypWorkspace;
@synthesize calendarVC = _calendarVC, contactVC = _contactVC, pasteboardVC = _pasteboardVC;
#pragma mark - public
-(swypWorkspaceViewController*)swypWorkspace{
	if (_swypWorkspace == nil){
		_swypWorkspace = [swypWorkspaceViewController sharedSwypWorkspace];
	}
	return _swypWorkspace;
}

-(ISContactVC*) contactVC{
	if (_contactVC == nil){
		_contactVC		=	[[ISContactVC alloc] initWithNibName:nil bundle:nil];
		[_contactVC.view	setFrame:CGRectMake(0, 0, self.view.width, self.view.height-[_actionTabBar height])];
	}
	return _contactVC;
}
-(ISCalendarVC*)calendarVC{
	if (_calendarVC ==nil){
		_calendarVC		=	[[ISCalendarVC alloc] initWithNibName:nil bundle:nil];
		[_calendarVC.view	setFrame:CGRectMake(0, 0, self.view.width, self.view.height-[_actionTabBar height])];
	}
	return _calendarVC;
}
-(ISPasteboardVC*) pasteboardVC{
	if (_pasteboardVC == nil){
		_pasteboardVC = [[ISPasteboardVC alloc] initWithNibName:nil bundle:nil];
		[_pasteboardVC.view	setFrame:CGRectMake(0, 0, self.view.width, self.view.height-[_actionTabBar height])];
	}
	return _pasteboardVC;
}

#pragma mark - NSObject
-(id) initWithObjectContext:(NSManagedObjectContext*)context{
	if (self  = [super initWithNibName:nil bundle:nil]){
		_objectContext	=	context;
        _selectedTab = -1;
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

	_historyNavController	=	[[UINavigationController alloc] initWithRootViewController:_historyScrollView];
	[_historyNavController.view setSize:CGSizeMake(self.view.size.width, self.view.size.height-49)];
	[_historyNavController setDelegate:self];
	[self addChildViewController:_historyNavController];
	[self.view addSubview:_historyNavController.view];
    
	[[self pasteboardVC] updatePasteboard];
    
    NSMutableArray *tabBarItems = [NSMutableArray array];
	[tabBarItems addObject:[ISContactVC tabBarItem]];
	[tabBarItems addObject:[ISCalendarVC tabBarItem]];
	[tabBarItems addObject:[ISPasteboardVC tabBarItem]];

	_actionTabBar		=	[[UITabBar alloc] init];
    _actionTabBar.frame = CGRectMake(0, (self.view.size.height - 49), self.view.size.width, 49);
    _actionTabBar.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin|
                                      UIViewAutoresizingFlexibleLeftMargin|
                                      UIViewAutoresizingFlexibleRightMargin|
                                      UIViewAutoresizingFlexibleWidth);
    
    _actionTabBar.items = tabBarItems;
    _actionTabBar.delegate = self;
    
    [self.view addSubview:_actionTabBar];
        
	//tab bar at bottom
	
	//we get callbacks from tab bar, then add views above the histroy scrollview
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (_selectedTab != -1){
		[_calendarVC.view removeFromSuperview];
		[_contactVC.view removeFromSuperview];
		[_pasteboardVC.view removeFromSuperview];
    }
    
    if (tabBar.selectedItem.tag == _selectedTab) {
        tabBar.selectedItem = nil;
        _selectedTab = -1;
    } else {
        _selectedTab = item.tag;
        ISTabVC * selectedVC	=	nil;
		if (_selectedTab == [[ISCalendarVC tabBarItem] tag]){
			selectedVC	=	[self calendarVC];
		}else if (_selectedTab == [[ISContactVC tabBarItem] tag]){
			selectedVC	=	[self contactVC];			
		}else if (_selectedTab == [[ISPasteboardVC tabBarItem] tag]){
			selectedVC	=	[self pasteboardVC];
			item.badgeValue = nil;
		}
		
		
		CGRect orientationRect	=	CGRectZero;;
		orientationRect.size	=	(UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])? [self view].frame:CGRectMake(0, 0,[self view].frame.size.height, [self view].frame.size.width)).size;
		orientationRect.size.height -= [_actionTabBar height];
		[selectedVC.view	setFrame:orientationRect];

		selectedVC.view.alpha	=	0;
        [self.view addSubview:selectedVC.view];
		[UIView animateWithDuration:.5 animations:^{
			selectedVC.view.alpha	=	1;
		}];
    }
    
}

- (void)updatePasteboard {
    [_pasteboardVC updatePasteboard];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
	if (deviceIsPhone_ish){
		return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	}else{
		return TRUE;
	}
}


#pragma mark - delegation
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
	if ( viewController == _historyScrollView ) {
		[navigationController setNavigationBarHidden:YES animated:animated];
	} else if ( [navigationController isNavigationBarHidden] ) {
		[navigationController setNavigationBarHidden:NO animated:animated];
	}
}
@end