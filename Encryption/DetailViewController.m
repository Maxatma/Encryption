//
//  DetailViewController.m
//  Encryption
//
//  Created by Запорожченко Александр Михайлович on 23.04.14.
//  Copyright (c) 2014 IDS Outsource. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic,strong) PasswordView *passView;

@property (nonatomic,strong) UIBarButtonItem *doneRightButton;

@end



@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:self.view.window];
    
    [center addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:self.view.window];
    
    self.title=self.noteTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    self.textView = [[UITextView alloc] init];
    self.textView.delegate=self;
    
    NSString *contentString = [[NSString alloc]initWithData:self.noteContent encoding:NSUTF8StringEncoding];
    self.textView.text = contentString;
    
   // self.textView.frame=CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    self.textView.backgroundColor= [UIColor grayColor];
    [self.textView setFont:[UIFont systemFontOfSize:20]];
    //[self.view addSubview:self.textView];
    [self.view makeConstraintsFromTextView:self.textView ToView:self.view];
    self.passView=[[[NSBundle mainBundle] loadNibNamed:@"passwordView" owner:self options:nil] objectAtIndex:0];
    self.passView.delegate=self;

    

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self action:@selector(doneRightButtonPressed)];
    self.doneRightButton =doneButton;
    if (self.isNewNote)
    {
        self.navigationItem.rightBarButtonItem=self.doneRightButton;
        [self.textView becomeFirstResponder];
    }
    
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

-(void) viewWillDisappear:(BOOL)animated
{
    self.isNewNote=NO;
    self.navigationItem.rightBarButtonItem=nil;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self ];
}

#pragma mark Buttons

-(void) doneRightButtonPressed
{
    [self.textView resignFirstResponder];
    [self.view makeConstraintsFromView:self.passView ToView:self.view];
   // [self.view addSubview:self.passView];
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
    NSData *contentData = [self.textView.text dataUsingEncoding:NSUTF8StringEncoding ];
    self.noteContent =contentData;
    
    self.noteContent=[self.noteContent encryptContentwithpass:self.passView.passTextField.text andname:self.noteTitle andContent:self.noteContent];
    [self saveNoteInDocumentsWithName:self.noteTitle andContent:self.noteContent];
    
    [self.passView cleanTextField];
    [self.passView removeFromSuperview];
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}

#pragma mark File Methods
-(void) saveNoteInDocumentsWithName: (NSString*)name andContent:(NSData*)content;
{
    NSString *documentsDirectory =[self getDocumentsDirectory];
    NSString *noteName = name;
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, noteName];
    
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            NSLog(@"file not exist");
        }
    
        [content writeToFile:filePath atomically:YES];
        if ([[NSFileManager defaultManager] isWritableFileAtPath:filePath])
        {
            NSLog(@"Writable %@", noteName);
        }
        else
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
    for (int i=0; i<fileNamesArray.count; i++)
    {
        NSLog(@"%@",[fileNamesArray objectAtIndex:i]);
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
