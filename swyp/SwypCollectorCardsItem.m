//
//  SwypCollectorCardsItem.m
//  swyp
//
//  Created by Alexander List on 2/19/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "SwypCollectorCardsItem.h"

@implementation SwypCollectorCardsItem
@synthesize personName = _personName, personRank = _personRank, personImage;

-(UIImage*)personImage{
	return [UIImage imageWithData:[self itemPreviewImage]];
}

-(void) setPersonImage:(UIImage *)image{
	[self setItemPreviewImage:UIImageJPEGRepresentation(image, .8)];
}



-(void) awakeFromFetch{
	[super awakeFromFetch];
	[self loadFromObjData];
}

-(void) setPersonName:(NSString *)personName{
	_personName = personName;
	[self saveToObjData];
}

-(void) setPersonRank:(NSNumber *)personRank{
	_personRank = personRank;
	[self saveToObjData];
}

-(void) saveToObjData{
	
}

-(void) loadFromObjData{
	
}

@end
