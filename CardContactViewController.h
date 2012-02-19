//
//  CardContactViewController.h
//  swyp
//
//  Created by Ying Quan Tan on 2/19/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISSwypHistoryItem.h"

@interface CardContactViewController : UIViewController

@property(retain, nonatomic) UIImageView *imageView;
@property(retain, nonatomic) UILabel  *nameLabel;
@property(retain, nonatomic) UIProgressView  *powerBar;

-(id)	loadContentFromHistoryItem: (ISSwypHistoryItem*)item;

@end
