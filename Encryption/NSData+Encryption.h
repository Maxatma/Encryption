//
//  NSData+Encryption.h
//  Encryption
//
//  Created by Запорожченко Александр Михайлович on 30.04.14.
//  Copyright (c) 2014 IDS Outsource. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Encryption)

-(NSData *)encryptContentwithpass:(NSString*)pass andname:(NSString*)name andContent:(NSData*)content;

@end
