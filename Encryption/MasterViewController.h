//
//  MasterViewController.h
//  Encryption
//
//  Created by Запорожченко Александр Михайлович on 23.04.14.
//  Copyright (c) 2014 IDS Outsource. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "PasswordView.h"
#import "NoteNameView.h"
#import "DetailViewController.h"

@interface MasterViewController : UITableViewController<PasswordViewDelegate,NoteNameDelegate>
{
    NSString *currentName;
    NSString *currentContent;
}

@property (nonatomic, strong) NoteNameView  *noteNameView;
@property (nonatomic, strong) PasswordView  *passView;

@property (nonatomic, strong) NSMutableArray *noteNamesArray;
@property (nonatomic, strong) UIBarButtonItem *addButton;

-  (IBAction)addButtonPressed:(id)sender;
-  (void) transform:(NSData*)input withkey:(NSString*)key;
-  (void) passwordViewOkayButtonPressed;


@end
