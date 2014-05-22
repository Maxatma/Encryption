//
//  MasterViewController.m
//  Encryption
//
//  Created by Запорожченко Александр Михайлович on 23.04.14.
//  Copyright (c) 2014 IDS Outsource. All rights reserved.
//

#import "MasterViewController.h"
@interface MasterViewController ()
{
    NSString *currentName;
    NSData   *currentContent;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NoteNameView  *noteNameView;
@property (nonatomic, strong) PasswordView  *passView;

@property (nonatomic, strong) NSMutableArray *noteNamesArray;
@property (nonatomic, strong) UIBarButtonItem *addButton;


-  (IBAction)addButtonPressed:(id)sender;
-  (void) passwordViewOkayButtonPressed;


@end


@implementation MasterViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.noteNamesArray=[NSMutableArray arrayWithArray:[self getFileNamesInDocuments]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.noteNameView=[[[NSBundle mainBundle] loadNibNamed:@"noteNameView" owner:self options:nil] objectAtIndex:0];
    self.noteNameView.delegate=self;
    
    self.passView=[[[NSBundle mainBundle] loadNibNamed:@"passwordView" owner:self options:nil] objectAtIndex:0];
    self.passView.delegate=self;

    UIBarButtonItem *barButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                 target:self
                                                                                 action:@selector(editButtonPressed)];
    

    self.navigationItem.leftBarButtonItem = barButtonItem;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _noteNamesArray=[NSMutableArray arrayWithArray:[self getFileNamesInDocuments]];
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
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.noteNameView removeFromSuperview];
    [self.view makeConstraintsFromView:self.passView ToView:self.view];

    NSString *filePath = [NSString stringWithFormat:@"%@/%@", [self getDocumentsDirectory], _noteNamesArray[indexPath.row]];
    currentName=_noteNamesArray[indexPath.row];
    currentContent= [NSData dataWithContentsOfFile:filePath];
    [self.passView.passTextField becomeFirstResponder];
    
}
#pragma mark Buttons

-(void)editButtonPressed{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
    if (self.tableView.editing)
        [self.navigationItem.leftBarButtonItem setTitle:@"Done"];
    else
        [self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
}

- (IBAction)addButtonPressed:(id)sender
{
    [self.passView removeFromSuperview];
    [self.view makeConstraintsFromView:self.noteNameView ToView:self.view];
    [self.noteNameView.nameTextfield becomeFirstResponder];
}

#pragma mark PASS Buttons Methods

-(void)passwordViewOkayButtonPressed
{
    NSString *passtext = self.passView.passTextField.text;
    NSData *content = currentContent;
    NSString *name = currentName;
    [self.passView cleanTextField];
    [self.passView removeFromSuperview];

    content=[content encryptContentwithpass:passtext andname:name andContent:content];
    
    DetailViewController *detail = [[DetailViewController alloc]init];
    detail.noteContent=content;
    detail.noteTitle=currentName;
    [self.navigationController pushViewController:detail animated:YES];
  
}

-(void)passwordViewCancelButtonPressed
{
    [self.passView cleanTextField];
    [self.passView removeFromSuperview];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated: YES];
}

#pragma mark NewNote Buttons Methods

-(void)noteNameCancelButtonPressed
{
    [self.noteNameView removeFromSuperview];
    [self.noteNameView cleanTextField];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated: YES];
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

-(NSArray *) getFileNamesInDocuments
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager  *fileManager = [[NSFileManager alloc] init];
    NSArray *filenames= [NSMutableArray arrayWithArray:[fileManager contentsOfDirectoryAtPath:documentsDirectory
                                                                                        error:nil]];
    return filenames;
}

-(void) createFilesInDocuments: (int)numberOfNotes
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    for (int i=1; i<=numberOfNotes; i++)
    {
    
        NSString *noteName = [NSString stringWithFormat:@"note %i",i];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, noteName];

        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
          // if file is not exist, create it
         NSString *contentString = [NSString stringWithFormat:@"hello, this is my %i note, glad to  see u",i];
          NSError *error;
          [contentString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        }
        
            if ([[NSFileManager defaultManager] isWritableFileAtPath:filePath])
            {
                NSLog(@"Writable %@", noteName);
            }
            else
            {
                NSLog(@"Not Writable %@",noteName);
            }

    }
}

-(void) deleteFromDocumentsDirectrory:(NSString*)filename
{
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


@end
