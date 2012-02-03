//
//  ISSwypDropZoneCellManager.h
//  swyp
//
//  Created by Alexander List on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NimbusModels.h"

@interface ISSwypDropZoneCellManager : NSObject <NICellObject>{
	UIView *	_dropView;
}
@property (nonatomic, readonly) UIView* dropView;

-(id) initWithSwypDropView:(UIView*)dropView;

@end
