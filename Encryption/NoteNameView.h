//
//  NoteNameView.h
//  Encryption
//
//  Created by Запорожченко Александр Михайлович on 24.04.14.
//  Copyright (c) 2014 IDS Outsource. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteNameDelegate.h"

@interface NoteNameView : UIView
@property (nonatomic, assign) id <NoteNameDelegate> delegate;

- (IBAction)noteCancelButtonPressed:(id)sender;
- (IBAction)noteOkayButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
- (void) cleanTextField;
@end
