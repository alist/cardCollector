//
//  ISContactVC.h
//  swyp
//
//  Created by Ethan Sherbondy on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISTabVC.h"
#import "ISContactCardVC.h"

@interface ISContactVC : ISTabVC {
    ISContactCardVC *contactCard;
}

@end
