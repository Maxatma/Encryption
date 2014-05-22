//
//  NSData+Encryption.m
//  Encryption
//
//  Created by Запорожченко Александр Михайлович on 30.04.14.
//  Copyright (c) 2014 IDS Outsource. All rights reserved.
//

#import "NSData+Encryption.h"

@implementation NSData (Encryption)
-(NSData *)encryptContentwithpass:(NSString*)pass andname:(NSString*)name andContent:(NSData*)content
{
    NSData *contentData = [[NSData alloc]initWithData:content];
    [self transform:contentData withkey:pass];
    content=contentData;
    return content;
}

-(void) transform:(NSData*)data withkey:(NSString*)inputKey
{
    if (![inputKey isEqualToString:@""])
    {
        
        NSData   *inputData = [[NSData alloc] initWithData: data];
        NSString *key       = [[NSString alloc]initWithString:inputKey];
        
        unsigned char* pBytesInput = (unsigned char*)[inputData bytes];
        unsigned char* pBytesKey   = (unsigned char*)[[key dataUsingEncoding:NSUTF8StringEncoding] bytes];
        unsigned int inputlength   = [inputData length];
        unsigned int keylength     = [key length];
        
        unsigned int k = inputlength % keylength;
        unsigned char c;
        
        for (unsigned int v=0; v < inputlength; v++)
        {
            c = pBytesInput[v] ^ pBytesKey[k];
            pBytesInput[v] = c;
            
            k = (++k < keylength ? k : 0);
        }
    }
}

@end
