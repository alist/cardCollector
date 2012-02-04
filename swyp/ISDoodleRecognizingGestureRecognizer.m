//
//  ISDoodleRecognizingGestureRecognizer.m
//  swyp
//
//  Created by Alexander List on 2/3/12.
//  Copyright (c) 2012 ExoMachina. All rights reserved.
//

#import "ISDoodleRecognizingGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation ISDoodleRecognizingGestureRecognizer
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{	
	[super touchesBegan:touches withEvent:event];
	startPoint	=	[self locationInView:self.view];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesMoved:touches withEvent:event];
	
	if (([self locationInView:self.view].y - startPoint.y) < -100){
		self.state	=	UIGestureRecognizerStateFailed;
	}else{
		self.state = UIGestureRecognizerStatePossible; 
	}

}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{	
	self.state	=	UIGestureRecognizerStateRecognized;
	[super touchesEnded:touches withEvent:event];
}

- (void)reset{

	startPoint	=	CGPointZero;
	
	[super reset];
}



@end
