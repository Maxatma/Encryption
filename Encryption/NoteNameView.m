//
//  NoteNameView.m
//  Encryption
//
//  Created by Запорожченко Александр Михайлович on 24.04.14.
//  Copyright (c) 2014 IDS Outsource. All rights reserved.
//

#import "NoteNameView.h"

@implementation NoteNameView

- (IBAction)noteCancelButtonPressed:(id)sender {
    [self.delegate noteNameCancelButtonPressed];
}

- (IBAction)noteOkayButtonPressed:(id)sender {
    [self.delegate noteNameOkayButtonPressed];
}

- (void) cleanTextField{
    self.nameTextfield.text =@"";
}
@end
