//
//  PasswordViewDelegate.h
//  Encryption
//
//  Created by Запорожченко Александр Михайлович on 24.04.14.
//  Copyright (c) 2014 IDS Outsource. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PasswordViewDelegate <NSObject>

-(void) passwordViewOkayButtonPressed;
-(void) passwordViewCancelButtonPressed;

@end
