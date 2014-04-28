//
//  DetailViewController.m
//  Encryption
//
//  Created by Запорожченко Александр Михайлович on 23.04.14.
//  Copyright (c) 2014 IDS Outsource. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:self.view.window];
    self.title=self.noteTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    self.textView = [[UITextView alloc] init];
    self.textView.delegate=self;
    self.textView.text = self.noteContent;
    self.textView.frame=CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    self.textView.backgroundColor= [UIColor grayColor];
    [self.textView setFont:[UIFont systemFontOfSize:20]];
    
    self.noteNameView=[[[NSBundle mainBundle] loadNibNamed:@"noteNameView" owner:self options:nil] objectAtIndex:0];
    self.noteNameView.frame = CGRectMake(8, 100, self.noteNameView.frame.size.width, self.noteNameView.frame.size.height);
    self.noteNameView.delegate=self;
    
    self.passView=[[[NSBundle mainBundle] loadNibNamed:@"passwordView" owner:self options:nil] objectAtIndex:0];
    self.passView.frame = CGRectMake(8, 100, self.passView.frame.size.width, self.passView.frame.size.height);
    self.passView.delegate=self;

    [self.view addSubview:self.textView];

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self action:@selector(doneRightButtonPressed)];
    self.doneRightButton =doneButton;
    if (self.isNewNote) {
        self.navigationItem.rightBarButtonItem=self.doneRightButton;
        [self.textView becomeFirstResponder];
    }
    
}

-(void) viewWillDisappear:(BOOL)animated{
    self.isNewNote=NO;
   self.navigationItem.rightBarButtonItem=nil;
}


#pragma mark Buttons

-(void) doneRightButtonPressed
{
    [self.textView resignFirstResponder];
    [self.view addSubview:self.passView];
    [self.passView.passTextField becomeFirstResponder];
}

#pragma mark Password

-(void)passwordViewCancelButtonPressed
{
    [self.passView.passTextField resignFirstResponder];
    [self.passView cleanTextField];
    [self.passView removeFromSuperview];
}
-(void)passwordViewOkayButtonPressed
{
    [self.passView.passTextField resignFirstResponder];
    self.noteContent =self.textView.text;
    [self encryptContentwithpass:self.passView.passTextField.text andname:self.noteTitle andContent:self.noteContent];
    
    [self.passView cleanTextField];
    [self.passView removeFromSuperview];
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}

#pragma mark File Methods
-(void) saveNoteInDocumentsWithName: (NSString*)name andContent:(NSString*)content;
{
    NSString *documentsDirectory =[self getDocumentsDirectory];
    NSString *noteName = name;
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, noteName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {

            NSLog(@"file not exist");
        }
        NSError *error;
        [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if ([[NSFileManager defaultManager] isWritableFileAtPath:filePath])
        {
            NSLog(@"Writable %@", noteName);
        }else
        {
            NSLog(@"Not Writable %@",noteName);
        }
    [self showFileNamesInDocuments];
    
}

     
-(NSString*) getDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

-(NSMutableArray *) getFileNamesInDocuments
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager  *fileManager = [[NSFileManager alloc] init];

    NSMutableArray *filenames= [fileManager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    return filenames;
}

-(void) showFileNamesInDocuments
{
    NSMutableArray *fileNamesArray = [self getFileNamesInDocuments];
    for (int i=0; i<fileNamesArray.count; i++) {
        NSLog(@"%@",[fileNamesArray objectAtIndex:i]);
    }
    
}

#pragma mark Encryption Methods

-(void)encryptContentwithpass:(NSString*)pass andname:(NSString*)name andContent:(NSString*)content
{
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    [self transform:contentData withkey:pass];
    NSString *newContent = [[NSString alloc]initWithData:contentData encoding:NSUTF8StringEncoding];
    [self saveNoteInDocumentsWithName:name andContent:newContent];
}

-(void) transform:(NSData*)input withkey:(NSString*)key
{
    if (![key isEqualToString:@""])
    {
        
        unsigned char* pBytesInput = (unsigned char*)[input bytes];
        unsigned char* pBytesKey   = (unsigned char*)[[key dataUsingEncoding:NSUTF8StringEncoding] bytes];
        unsigned int inputlength = [input length];
        unsigned int keylength = [key length];
        
        unsigned int v = 0;
        unsigned int k = inputlength % keylength;
        unsigned char c;
        
        for (v; v < inputlength; v++) {
            c = pBytesInput[v] ^ pBytesKey[k];
            pBytesInput[v] = c;
            
            k = (++k < keylength ? k : 0);
        }
    }
}


#pragma mark Keyboard

- (void)keyboardWillShow:(NSNotification *)notif
{
    self.navigationItem.rightBarButtonItem = self.doneRightButton;
    
    CGSize keyboardSize = [[[notif userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue].size;
    CGRect finalRect = CGRectMake(self.textView.frame.origin.x , self.textView.frame.origin.y , self.textView.frame.size.width, self.textView.frame.size.height-keyboardSize.height);
    self.textView.frame=finalRect;
    
}

- (void)keyboardWillHide:(NSNotification *)notif
{
    CGSize keyboardSize = [[[notif userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue].size;
    CGRect finalRect = CGRectMake(self.textView.frame.origin.x , self.textView.frame.origin.y , self.textView.frame.size.width, self.textView.frame.size.height+keyboardSize.height);
    self.textView.frame=finalRect;
}


@end
