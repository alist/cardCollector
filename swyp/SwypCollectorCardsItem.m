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
	NSDictionary * saveDict		= [NSMutableDictionary dictionary];
	NSData * archive	=	[NSKeyedArchiver archivedDataWithRootObject:saveDict];
	[self setItemData:archive];
}

-(void) loadFromObjData{
	NSDictionary * decodedValues	=	[NSKeyedUnarchiver unarchiveObjectWithData:[self itemData]];
	for (NSString * key in decodedValues.allKeys){
		if ([[decodedValues valueForKey:key] isKindOfClass:[NSNull class]] == NO){
			if ([key isEqualToString:@"personName"]){
				[self setPersonImage:[decodedValues valueForKey:key]];
			}else if ([key isEqualToString:@"personRank"]){
				[self setPersonRank:[decodedValues valueForKey:key]];				
			}
		}
	}
}

@end
