//
//  PasswordView.h
//  Encryption
//
//  Created by Запорожченко Александр Михайлович on 24.04.14.
//  Copyright (c) 2014 IDS Outsource. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PasswordViewDelegate <NSObject>

-(void) passwordViewOkayButtonPressed;
-(void) passwordViewCancelButtonPressed;

@end


@interface PasswordView : UIView

@property (nonatomic, weak) id <PasswordViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;

- (void) cleanTextField;

@end
