//
//  NoteNameView.h
//  Encryption
//
//  Created by Запорожченко Александр Михайлович on 24.04.14.
//  Copyright (c) 2014 IDS Outsource. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoteNameDelegate <NSObject>


-(void) noteNameOkayButtonPressed;
-(void) noteNameCancelButtonPressed;


@end


@interface NoteNameView : UIView

@property (nonatomic, weak) id <NoteNameDelegate> delegate;
@property (nonatomic,weak) IBOutlet UITextField *nameTextfield;

- (void) cleanTextField;


@end
