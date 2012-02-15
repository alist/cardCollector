//
//  ISContactView.m
//  swyp
//
//  Created by Ethan Sherbondy on 2/14/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISContactCardVC.h"
#import <QuartzCore/QuartzCore.h>

static const NSInteger kNameField = 0;
static const NSInteger kNumberField = 1;
static const NSInteger kEmailField = 2;

@interface UIView (Recurse)
    - (NSString *)recursiveDescription;
@end

@implementation ISContactCardVC

- (id)init {
    self = [super init];
    if (self){
        NSArray* tableContents =
        [NSArray arrayWithObjects:
         [NITextInputFormElement textInputElementWithID:kNameField placeholderText:@"Name" value:nil delegate:self],
         [NITextInputFormElement textInputElementWithID:kNumberField placeholderText:@"Phone Number" value:nil delegate:self],
         [NITextInputFormElement textInputElementWithID:kEmailField placeholderText:@"Email" value:nil delegate:self],
         nil];
        
        _model = [[NITableViewModel alloc] initWithSectionedArray:tableContents
                                                    delegate:(id)[NICellFactory class]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.view.frame = CGRectMake(0, 0, 300, 200);
    self.view.autoresizingMask = UIViewAutoresizingFlexibleMargins;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"handmadepaper"]];
    self.view.clipsToBounds = NO;
    CALayer *layer = self.view.layer;
    layer.shadowRadius = 8;
    layer.shadowColor = [UIColor whiteColor].CGColor;
    layer.shadowOffset = CGSizeMake(0, 20);
    layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    
    self.tableView.frame = self.view.frame;
    self.tableView.clipsToBounds = YES;
    self.tableView.scrollEnabled = NO;
    
    self.tableView.dataSource = _model;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Customize the presentation of certain types of cells.
    if ([cell isKindOfClass:[NITextInputFormElementCell class]]) {
        NITextInputFormElementCell* textInputCell = (NITextInputFormElementCell *)cell;
    }
}

- (NSString *)nameForTag:(NSInteger)tag{
    switch (tag) {
        case 0:
            return @"Name";
            break;
        case 1:
            return @"Number";
            break;
        case 2:
            return @"Email";
            break;
    }
    return nil;
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    UITableViewCell* selectedCell = [self.tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([selectedCell isKindOfClass:[NIButtonFormElementCell class]]) {
        NIButtonFormElementCell* buttonCell = (NIButtonFormElementCell*)selectedCell;
        [buttonCell buttonWasTapped:selectedCell];
    }
    // Clear the selection state when we're done.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag != 2){
        NITextInputFormElementCell* cell = (NITextInputFormElementCell *)[self.tableView viewWithTag:(textField.tag+1)];
        [cell.textField becomeFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    switch (textField.tag) {
        case kNumberField:
            textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case kEmailField:
            textField.keyboardType = UIKeyboardTypeEmailAddress;
            break;
        default:
            textField.keyboardType = UIKeyboardTypeDefault;
            break;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[NSUserDefaults standardUserDefaults] 
     setObject:textField.text forKey:[self nameForTag:textField.tag]];
}


@end
