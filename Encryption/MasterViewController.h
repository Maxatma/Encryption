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
#import "NSData+Encryption.h"
#import "DetailViewController.h"
#import "UIView+CustomConstraints.h"

@interface MasterViewController : UIViewController <PasswordViewDelegate,NoteNameDelegate,UITableViewDelegate,UITableViewDataSource>

@end
