//
//  DetailViewController.h
//  Encryption
//
//  Created by Запорожченко Александр Михайлович on 23.04.14.
//  Copyright (c) 2014 IDS Outsource. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteNameView.h"
#import "PasswordView.h"
#import "MasterViewController.h"

@interface DetailViewController : UIViewController<NoteNameDelegate,PasswordViewDelegate>
{
     UITabBarController* tabBarController;
}


@property (nonatomic, strong) UITextView *textView;

@property (nonatomic,strong) NoteNameView  *noteNameView;
@property (nonatomic,strong) PasswordView *passView;

@property (nonatomic,strong) UIBarButtonItem *doneRightButton;
@property (nonatomic,assign) BOOL *isNewNote;

@property (nonatomic,strong) NSString *noteTitle;
@property (nonatomic,strong) NSString *noteContent;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomConst;

@end
