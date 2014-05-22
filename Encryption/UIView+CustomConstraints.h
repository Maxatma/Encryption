//
//  UIView+CustomConstraits.h
//  Encryption
//
//  Created by Запорожченко Александр Михайлович on 30.04.14.
//  Copyright (c) 2014 IDS Outsource. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CustomConstraints)

-(void) makeConstraintsFromView: (UIView*)subview ToView: (UIView *)superview;
-(void) makeConstraintsFromTextView: (UITextView*)subview ToView: (UIView *)superview;
-(void) makeConstraintsFromView: (UIView*)subview ToView: (UIView *)superview witTopConstant: (CGFloat)topConstant withLeftConstant: (CGFloat)leftConstant withRightConstant: (CGFloat)rightConstant;
@end
