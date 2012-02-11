//
//  ISPasteboardObject.m
//  swyp
//
//  Created by Ethan Sherbondy on 2/10/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISPasteboardObject.h"
#import "UIImage+Resize.h"

@implementation ISPasteboardObject

@synthesize delegate = _delegate;
@synthesize image = _image;
@synthesize text = _text;
@synthesize address = _address;
@synthesize itemType = _itemType;

- (void)setDelegate:(id)delegete {
    NSLog(@"Setting delegate.");
    _delegate = delegete;
    [_delegate setDatasource:self];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.itemType = [NSString imageJPEGFileType];
    
    if (self.delegate && image){
        [self.delegate setImage:image];
    }
}

- (void)setText:(NSString *)text {
    _text = text;
    self.itemType = [NSString textPlainFileType];
    
    if (self.delegate && text){
        [self.delegate setText:text];
    }
}

- (void)setAddress:(NSString *)address {
    self.text = address;
    _address = address;
    self.itemType = [NSString swypAddressFileType];
    
    if (self.delegate && address){
        [self.delegate setAddress:address];
    }
}

- (NSData *)itemData {
    if (self.itemType == [NSString textPlainFileType]){
        return [self.text dataUsingEncoding:NSUTF8StringEncoding];
    } else if (self.itemType == [NSString swypAddressFileType]){
        NSDictionary *theData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 self.address, @"address", 
                                 [self.delegate getThumbnail], @"thumbnail", nil];
        return [NSKeyedArchiver archivedDataWithRootObject:theData];
    } else {
        NSLog(@"Unexpected itemType. Could not come up with item data.");
        return nil;
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Text: %@ Address: %@ Image: %@", self.text, self.address, self.image];
}

- (void)displayInSwypWorkspace:(id)sender {
    NSLog(@"%@", self.description);
    swypWorkspaceViewController * swypWorkspace	= [swypWorkspaceViewController sharedSwypWorkspace];
	[swypWorkspace setContentDataSource:self];
	[_datasourceDelegate datasourceSignificantlyModifiedContent:self];
	[swypWorkspace presentContentWorkspaceAtopViewController:[[[UIApplication sharedApplication] keyWindow] rootViewController]];
}


#pragma mark - delegation
#pragma mark <swypContentDataSourceProtocol, swypConnectionSessionDataDelegate>
- (NSArray*)	idsForAllContent{
	return [NSArray arrayWithObject:@"PREVIEW_DISPLAYED_ITEM"];
}
- (UIImage *)	iconImageForContentWithID: (NSString*)contentID ofMaxSize:(CGSize)maxIconSize{	
	return [self.delegate getThumbnail];
}

- (NSArray*)		supportedFileTypesForContentWithID: (NSString*)contentID{
	return [NSArray arrayWithObjects:self.itemType,
                                     [NSString imageJPEGFileType],
                                     [NSString imagePNGFileType], nil];
}

- (NSData*)	dataForContentWithID: (NSString*)contentID fileType:	(swypFileTypeString*)type{
	NSData *	sendData	=	nil;	
	
	if ([type isFileType:[NSString swypAddressFileType]] || [type isFileType:[NSString textPlainFileType]]){
		sendData = [self itemData];
	} else if ([type isFileType:[NSString imagePNGFileType]]){
		if ([self.itemType isFileType:[NSString imageJPEGFileType]]){
			sendData	=	UIImagePNGRepresentation(self.image);
		} else{
			sendData	=	UIImagePNGRepresentation([self.delegate getThumbnail]);
		}
	} else if ([type isFileType:[NSString imageJPEGFileType]]){
		if ([self.itemType isFileType:[NSString imageJPEGFileType]]){
			sendData	=	 UIImageJPEGRepresentation(self.image, 1);
        }
        else{
			sendData	=	UIImageJPEGRepresentation([self.delegate getThumbnail], 0.8);
		}
	} else{
		EXOLog(@"No data coverage for content type %@ of ID %@", type,contentID);
	}
	
	
	return sendData;
}



-(void)	setDatasourceDelegate:			(id<swypContentDataSourceDelegate>)theDelegate{
	_datasourceDelegate	=	theDelegate;
}
-(id<swypContentDataSourceDelegate>)	datasourceDelegate{
	return _datasourceDelegate;
}

-(void)	contentWithIDWasDraggedOffWorkspace:(NSString*)contentID{
	[_datasourceDelegate datasourceRemovedContentWithID:contentID withDatasource:self];
}

#pragma mark -
-(NSArray*)supportedFileTypesForReceipt{
	return nil;
}
-(void) yieldedData:(NSData *)streamData ofType:(NSString *)streamType fromDiscernedStream:(swypDiscernedInputStream *)discernedStream inConnectionSession:(swypConnectionSession *)session{
	
}

@end
