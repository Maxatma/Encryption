//
//  PasswordView.h
//  Encryption
//
//  Created by Запорожченко Александр Михайлович on 24.04.14.
//  Copyright (c) 2014 IDS Outsource. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasswordViewDelegate.h"

@interface PasswordView : UIView
@property (nonatomic, assign) id <PasswordViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *passTextField;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)okayButtonPressed:(id)sender;

- (void) cleanTextField;

@end
