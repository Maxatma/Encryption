//
//  PasswordView.m
//  Encryption
//
//  Created by Запорожченко Александр Михайлович on 24.04.14.
//  Copyright (c) 2014 IDS Outsource. All rights reserved.
//

#import "PasswordView.h"

@implementation PasswordView

- (IBAction)cancelButtonPressed:(id)sender
{
    [self.delegate passwordViewCancelButtonPressed];
}

- (IBAction)okayButtonPressed:(id)sender
{
    [self.delegate passwordViewOkayButtonPressed];
}

- (void) cleanTextField
{
    self.passTextField.text =@"";
}

@end
