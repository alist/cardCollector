//
//  ISSwypHistoryItem.h
//  swyp
//
//  Created by Alexander List on 2/4/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NimbusModels.h"

///defines compatable export actions for a swypHistoryItem
typedef enum{
	swypHistoryItemExportActionNone,
	swypHistoryItemExportActionSaveToPhotoRoll,
	swypHistoryItemExportActionSaveToContacts,
	swypHistoryItemExportActionSaveToCalendar,
	swypHistoryItemExportActionOpenInMaps
} swypHistoryItemExportAction;

@interface ISSwypHistoryItem : NSManagedObject <NICellObject,swypContentDataSourceProtocol, swypConnectionSessionDataDelegate>{
	id<swypContentDataSourceDelegate>	_datasourceDelegate;
}

@property (nonatomic, strong) NSDate * dateAdded;
@property (nonatomic, strong) NSData * itemData;
@property (nonatomic, strong) NSData * itemPreviewImage;
@property (nonatomic, strong) NSString * itemTag;
@property (nonatomic, strong) NSString * itemType;

/**  Returns a bidirection dictionary with NSStrings objects by (NSNumbers withIntergers of a swypHistoryItemExportAction)  */
@property (nonatomic, strong) swypBidirectionalMutableDictionary * localizedActionNamesByExportAction;

///Adds whatever representations possible into pastboard
-(void) addToPasteboard;
///Returns a textual representation if possible
-(NSString*) textRepresentation;

/** reuturns NSIndexSet of supported export actions; returns zero or nil if none available.*/
-(NSIndexSet*)supportedExportActions;

/**Performs relevant function for a specific swyp export action
 @param controller :some actions benefit by displaying a modal view of the result, such as contacts or calendars
 */
-(void) performExportAction:(swypHistoryItemExportAction)exportAction withSendingViewController:(UIViewController*)controller;

/** Sets this object as the sharedSwypWorkspace's dataSource
 Displays the sharedSwypWorskapce as a modal view atop the root view controller of the UIWindow 
 */
-(void) displayInSwypWorkspace;

///Returns the biggest image representation available to the framework
-(UIImage*)	biggestImageAvailable;

///returns the dictionary value for the itemData, if available; It's available for maps and contacts, for sure.
-(NSDictionary*) itemDataDictionaryRep;

@end
