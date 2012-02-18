//
//  ISContactView.h
//  swyp
//
//  Created by Ethan Sherbondy on 2/14/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NimbusModels.h"

@interface ISContactCardVC : UITableViewController <UITextFieldDelegate> {
    NITableViewModel* _model;
    UITextField* _activeField;
}

@end
