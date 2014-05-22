//
//  DetailViewController.h
//  Encryption
//
//  Created by Запорожченко Александр Михайлович on 23.04.14.
//  Copyright (c) 2014 IDS Outsource. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasswordView.h"
#import "MasterViewController.h"

@interface DetailViewController : UIViewController<PasswordViewDelegate>

@property (nonatomic,assign) BOOL isNewNote;
@property (nonatomic,strong) NSString *noteTitle;
@property (nonatomic,strong) NSData *noteContent;

@end
