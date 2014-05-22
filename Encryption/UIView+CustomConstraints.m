//
//  UIView+CustomConstraits.m
//  Encryption
//
//  Created by Запорожченко Александр Михайлович on 30.04.14.
//  Copyright (c) 2014 IDS Outsource. All rights reserved.
//

#import "UIView+CustomConstraints.h"

@implementation UIView (CustomConstraints)

-(void) makeConstraintsFromView: (UIView*)subview ToView: (UIView *)superview
{
    
    subview.translatesAutoresizingMaskIntoConstraints=NO;
    [superview addSubview:subview];
    
    NSLayoutConstraint  *top = [NSLayoutConstraint constraintWithItem: subview
                                                            attribute: NSLayoutAttributeTop
                                                            relatedBy: NSLayoutRelationEqual
                                                               toItem: superview
                                                            attribute: NSLayoutAttributeTop
                                                           multiplier: 1.0f
                                                             constant: 80.f
                                ];
    
    NSLayoutConstraint *pinToRight = [NSLayoutConstraint constraintWithItem: subview
                                                                  attribute: NSLayoutAttributeTrailing
                                                                  relatedBy: NSLayoutRelationEqual
                                                                     toItem: superview
                                                                  attribute: NSLayoutAttributeRight
                                                                 multiplier: 1.0f
                                                                   constant: -10.0f
                                      ];
    NSLayoutConstraint *pinToLeft =[NSLayoutConstraint constraintWithItem:subview
                                                                attribute:NSLayoutAttributeLeading
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:superview
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0
                                                                 constant:10.0];
    
    
    [superview addConstraint:top];
    [superview addConstraint:pinToRight];
    [superview addConstraint:pinToLeft];
    
}

-(void) makeConstraintsFromTextView: (UITextView*)subview ToView: (UIView *)superview
{
    
    subview.translatesAutoresizingMaskIntoConstraints=NO;
    [superview addSubview:subview];
    
    NSLayoutConstraint  *top = [NSLayoutConstraint constraintWithItem: subview
                                                            attribute: NSLayoutAttributeTop
                                                            relatedBy: NSLayoutRelationEqual
                                                               toItem: superview
                                                            attribute: NSLayoutAttributeTop
                                                           multiplier: 1.0f
                                                             constant: 0.f
                                ];
    
    NSLayoutConstraint *pinToRight = [NSLayoutConstraint constraintWithItem: subview
                                                                  attribute: NSLayoutAttributeTrailing
                                                                  relatedBy: NSLayoutRelationEqual
                                                                     toItem: superview
                                                                  attribute: NSLayoutAttributeRight
                                                                 multiplier: 1.0f
                                                                   constant: 0.0f
                                      ];
    NSLayoutConstraint *pinToLeft =[NSLayoutConstraint constraintWithItem:subview
                                                                attribute:NSLayoutAttributeLeading
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:superview
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0
                                                                 constant:0.0];
    NSLayoutConstraint  *bot = [NSLayoutConstraint constraintWithItem: subview
                                                            attribute: NSLayoutAttributeBottom
                                                            relatedBy: NSLayoutRelationEqual
                                                               toItem: superview
                                                            attribute: NSLayoutAttributeBottom
                                                           multiplier: 1.0f
                                                             constant: 0.f];
    
    
    [superview addConstraint:top];
    [superview addConstraint:pinToRight];
    [superview addConstraint:pinToLeft];
    [superview addConstraint:bot];
    
}
-(void) makeConstraintsFromView: (UIView*)subview ToView: (UIView *)superview witTopConstant: (CGFloat)topConstant withLeftConstant: (CGFloat)leftConstant withRightConstant: (CGFloat)rightConstant
{
    subview.translatesAutoresizingMaskIntoConstraints=NO;
    [superview addSubview:subview];
    
    NSLayoutConstraint  *top = [NSLayoutConstraint constraintWithItem: subview
                                                            attribute: NSLayoutAttributeTop
                                                            relatedBy: NSLayoutRelationEqual
                                                               toItem: superview
                                                            attribute: NSLayoutAttributeTop
                                                           multiplier: 1.0f
                                                             constant: topConstant
                                ];
    
    NSLayoutConstraint *pinToRight = [NSLayoutConstraint constraintWithItem: subview
                                                                  attribute: NSLayoutAttributeTrailing
                                                                  relatedBy: NSLayoutRelationEqual
                                                                     toItem: superview
                                                                  attribute: NSLayoutAttributeRight
                                                                 multiplier: 1.0f
                                                                   constant: rightConstant
                                      ];
    NSLayoutConstraint *pinToLeft =[NSLayoutConstraint constraintWithItem:subview
                                                                attribute:NSLayoutAttributeLeading
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:superview
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0
                                                                 constant:leftConstant
                                    ];
//    NSLayoutConstraint  *bot = [NSLayoutConstraint constraintWithItem: subview
//                                                            attribute: NSLayoutAttributeBottom
//                                                            relatedBy: NSLayoutRelationEqual
//                                                               toItem: superview
//                                                            attribute: NSLayoutAttributeBottom
//                                                           multiplier: 1.0f
//                                                             constant: 0.f
//                                ];
    
    
    [superview addConstraint:top];
    [superview addConstraint:pinToRight];
    [superview addConstraint:pinToLeft];
//    [superview addConstraint:bot];

}


@end
