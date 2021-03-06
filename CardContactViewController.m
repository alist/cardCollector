//
//  CardContactViewController.m
//  swyp
//
//  Created by Ying Quan Tan on 2/19/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "CardContactViewController.h"
#import "SwypCollectorCardsItem.h"

@interface CardContactViewController(Private) 
- (void)refresh;
@end

@implementation CardContactViewController

@synthesize imageView, nameLabel, powerBar, item;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.frame = CGRectOffset(imageView.frame, 0, 44);
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    nameLabel.font = [UIFont systemFontOfSize:18];
    nameLabel.backgroundColor = [UIColor clearColor];
  
    [self.view addSubview:imageView];
    [self.view addSubview:nameLabel];
    [self refresh];
}

-(void)	loadContent: (SwypCollectorCardsItem*)anItem {
 
  item = anItem;
  [self refresh];
  
}

- (void)refresh {
  if ([self isViewLoaded] && item) {
    imageView.image = item.personImage;
    nameLabel.text = item.personName;
  }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
  imageView = nil;
  nameLabel = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


  
@end
