//
//  MasterViewController.m
//  Encryption
//
//  Created by Запорожченко Александр Михайлович on 23.04.14.
//  Copyright (c) 2014 IDS Outsource. All rights reserved.
//

#import "MasterViewController.h"

@implementation MasterViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _noteNamesArray=[self getFileNamesInDocuments];
   // [self createFilesInDocuments:23];
    
    self.noteNameView=[[[NSBundle mainBundle] loadNibNamed:@"noteNameView" owner:self options:nil] objectAtIndex:0];
    self.noteNameView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.noteNameView.frame.size.width, self.noteNameView.frame.size.height);
    self.noteNameView.delegate=self;
    
    self.passView=[[[NSBundle mainBundle] loadNibNamed:@"passwordView" owner:self options:nil] objectAtIndex:0];
    self.passView.frame = CGRectMake(8, 100, self.passView.frame.size.width, self.passView.frame.size.height);
    self.passView.delegate=self;

    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _noteNamesArray=[self getFileNamesInDocuments];
    [self.tableView reloadData];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithTitle:@"Add"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self action:@selector(addButtonPressed:)];
    self.addButton =addButton;
    self.navigationItem.rightBarButtonItem=self.addButton;
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _noteNamesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    cell.textLabel.text = _noteNamesArray[indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //deleting note from documents
        [self deleteFromDocumentsDirectrory:_noteNamesArray[indexPath.row]];
        [_noteNamesArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        

        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.noteNameView removeFromSuperview];
    self.passView.frame = CGRectMake([self.tableView bounds].origin.x+8, [self.tableView bounds].origin.y+100, self.passView.frame.size.width, self.passView.frame.size.height);
    
    NSError *error;
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", [self getDocumentsDirectory], _noteNamesArray[indexPath.row]];
    currentName=_noteNamesArray[indexPath.row];
    currentContent=[NSString stringWithContentsOfFile:filePath
                                             encoding:NSUTF8StringEncoding
                                                error:&error];
    
	[self.view addSubview:self.passView];
    [self.passView.passTextField becomeFirstResponder];
    
}
#pragma mark Buttons
- (IBAction)addButtonPressed:(id)sender
{
    [self.passView removeFromSuperview];
    self.noteNameView.frame = CGRectMake([self.tableView bounds].origin.x+8, [self.tableView bounds].origin.y+100, self.noteNameView.frame.size.width, self.noteNameView.frame.size.height);
    [self.view addSubview:self.noteNameView];
    
    [self.noteNameView.nameTextfield becomeFirstResponder];
}

#pragma mark PASS Buttons Methods

-(void)passwordViewOkayButtonPressed
{
    NSString *passtext = self.passView.passTextField.text;
    NSString *content = currentContent;
    NSString *name = currentName;
    [self.passView cleanTextField];
    [self.passView removeFromSuperview];
    
    
    content=[self encryptContentwithpass:passtext andname:name andContent:content];
    DetailViewController *detail = [[DetailViewController alloc]init];
    detail.noteContent=content;
    detail.noteTitle=currentName;
    [self.navigationController pushViewController:detail animated:YES];
  
}

-(void)passwordViewCancelButtonPressed
{
    [self.passView cleanTextField];
    [self.passView removeFromSuperview];

}

#pragma mark NewNote Buttons Methods

-(void)noteNameCancelButtonPressed
{
    [self.noteNameView removeFromSuperview];
    [self.noteNameView cleanTextField];
}

-(void)noteNameOkayButtonPressed
{
    [self.noteNameView removeFromSuperview];
   
    DetailViewController *detail = [[DetailViewController alloc]init];
    detail.noteTitle =self.noteNameView.nameTextfield.text;
    detail.isNewNote=YES;
    [self.noteNameView cleanTextField];
    [self.navigationController pushViewController:detail animated:YES];

}

#pragma mark File Methods

-(NSMutableArray *) getFileNamesInDocuments
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager  *fileManager = [[NSFileManager alloc] init];
    NSMutableArray *filenames= [fileManager contentsOfDirectoryAtPath:documentsDirectory
                                                                error:nil];
    return filenames;
}

-(void) createFilesInDocuments: (int)numberOfNotes
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    for (int i=1; i<=numberOfNotes; i++) {
    
    NSString *noteName = [NSString stringWithFormat:@"note %i",i];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, noteName];

    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
      // if file is not exist, create it
     NSString *contentString = [NSString stringWithFormat:@"hello, this is my %i note, glad to  see u",i];
      NSError *error;
      [contentString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    }
    
  if ([[NSFileManager defaultManager] isWritableFileAtPath:filePath]) {
      NSLog(@"Writable %@", noteName);
   }else {
      NSLog(@"Not Writable %@",noteName);}

  }
}

-(void) deleteFromDocumentsDirectrory:(NSString*)filename{
    NSString *documentsDirectory =[self getDocumentsDirectory];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, filename];
    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath])
    {
        [manager removeItemAtPath:filePath error:&error];
        NSLog(@"File %@ deleted",filename);
    }
    
    
}

-(NSString*) getDocumentsDirectory
{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        return documentsDirectory;
}

-(void) saveNoteInDocumentsWithName: (NSString*)name andContent:(NSString*)content;
{
    NSString *documentsDirectory =[self getDocumentsDirectory];
    NSString *noteName = name;
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", [self getDocumentsDirectory], noteName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSError *error;
        [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        NSLog(@"file not exist");
    }
    
    if ([[NSFileManager defaultManager] isWritableFileAtPath:filePath])
    {
        NSLog(@"Writable %@", noteName);
    }else
    {
        NSLog(@"Not Writable %@",noteName);
    }
}

#pragma mark Encryption Methods

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

-(NSString *)encryptContentwithpass:(NSString*)pass andname:(NSString*)name andContent:(NSString*)content
{    
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    [self transform:contentData withkey:pass];
    content=@"12";
    NSString *dataString = [[NSString alloc]initWithData:contentData encoding:NSUTF8StringEncoding];
    content = dataString;
    return content;
}

@end
