//
//  ISSwypHistoryItem.m
//  swyp
//
//  Created by Alexander List on 2/4/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISSwypHistoryItem.h"
#import "ISHistoryCell.h"

@implementation ISSwypHistoryItem

@dynamic dateAdded;
@dynamic itemData;
@dynamic itemPreviewImage;
@dynamic itemTag;
@dynamic itemType;

-(void) awakeFromInsert{
	[super awakeFromInsert];
	[self setDateAdded:[NSDate date]];
}

- (Class)cellClass{
	return [ISHistoryCell class];
}

- (UITableViewCellStyle)cellStyle{
	return UITableViewCellStyleDefault;
}

-(void) addToPasteboard{
	//image type
	if ([[self itemType] isFileType:[NSString imagePNGFileType]]){
		[[UIPasteboard generalPasteboard] setData:[self itemData] forPasteboardType:@"public.png"];
	}else if ([[self itemType] isFileType:[NSString imageJPEGFileType]]){
		[[UIPasteboard generalPasteboard] setData:[self itemData] forPasteboardType:@"public.jpeg"];
	}else{
		[[UIPasteboard generalPasteboard] setData:[self itemPreviewImage] forPasteboardType:@"public.jpeg"];
	}
	
	NSString * textRep	=	[self textRepresentation];
	if (StringHasText(textRep)){
		[[UIPasteboard generalPasteboard] setString:textRep];
	}

}

-(NSString*) textRepresentation{
	NSString * representation = nil;
	
	if ([[self itemType] isFileType:[NSString textPlainFileType]]){
		representation	=	[NSString stringWithCharacters:[[self itemData] bytes] length:[[self itemData] length]];
	}else if ([[self itemType] isFileType:[NSString swypAddressFileType]]){
		representation	=	[NSString stringWithCharacters:[[self itemData] bytes] length:[[self itemData] length]];
	}else if ([[self itemType] isFileType:[NSString swypAddressFileType]]){
		representation	=	[NSString stringWithCharacters:[[self itemData] bytes] length:[[self itemData] length]];
	}
	
	return representation;
}

@end
