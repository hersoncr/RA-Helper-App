//
//  AddNewRoomViewController.m
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/18/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import "AddNewRoomViewController.h"
#import "Room+Create.h"
#import "DormWing+Create.h"
@interface AddNewRoomViewController ()
@property (nonatomic, strong) UIManagedDocument * wingsDataSource;
@end

@implementation AddNewRoomViewController
@synthesize roomsDatabase = _roomsDatabase;
@synthesize wingsPickerViewOutlet = _wingsPickerViewOutlet;
@synthesize roomNameTextField = _roomNameTextField;
@synthesize wingsArray = _wingsArray;
@synthesize wingsDataSource = _wingsDataSource;

- (void) setRoomsDatabase:(UIManagedDocument *)roomsDatabase
{
    if (_roomsDatabase!= roomsDatabase) {
        _roomsDatabase = roomsDatabase;
        [self useDocument:roomsDatabase];
    }
}

- (void) setWingsDataSource:(UIManagedDocument *)wingsDataSource
{
    if (_wingsDataSource!= wingsDataSource) {
        _wingsDataSource = wingsDataSource;
        [self useDocument:wingsDataSource];
    }
}
- (void) setUp
{
    self.wingsPickerViewOutlet.delegate = self;
    self.wingsPickerViewOutlet.dataSource = self;
    
    if (!self.roomsDatabase) {  // we'll create a default database if none is set
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Default Rooms Database"];
        // url is now "<Documents Directory>/Default Status Database"
        
        // Now create the document on disk and call the setter for statusDatabase property
        self.roomsDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
        
    }
    
    if (!self.wingsDataSource) {  // we'll create a default database if none is set
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Default Wings Database"];
        // url is now "<Documents Directory>/Default Status Database"
        
        // Now create the document on disk and call the setter for statusDatabase property
        self.wingsDataSource = [[UIManagedDocument alloc] initWithFileURL:url];
        self.wingsArray = [DormWing getAllDormWingsWithContext:self.wingsDataSource.managedObjectContext];
    }
}

- (void)useDocument:(UIManagedDocument *) document
{   // Open or create the document here and call setupFetchedResultsController
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:[document.fileURL path]] ) {
        // document does not exist on disk, so create it (using a BLOCK on a separate thread)
        [document saveToURL:document.fileURL
                     forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
                         if (success) {
                             //[self populateStatusDatabaseWithDefaults];
                         }
                     }];
        
    } else if (document.documentState == UIDocumentStateClosed) {
        // document does exist on disk, but we need to open it (again, we use a separate thread)
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                //[self populateStatusDatabaseWithDefaults];
            }
        }];
        
    } else if (document.documentState == UIDocumentStateNormal) {
        // document is already open and ready to use
        //[self populateStatusDatabaseWithDefaults];
    }
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setUp];
    }
    return self;
}
- (IBAction)addNewRoomAction:(id)sender {
    NSString *message = nil;
    
    //[NSString stringWithFormat:@"You selected: %@",];
    
    if (!self.roomNameTextField.text || ![self.roomNameTextField.text isEqualToString:@""])
    {
        int selectedIndex = [self.wingsPickerViewOutlet selectedRowInComponent:0];

        Room * room = [Room roomWithName:self.roomNameTextField.text inWing:[self.wingsArray objectAtIndex:selectedIndex] andWithContext:self.roomsDatabase.managedObjectContext];
        message = [NSString stringWithFormat:@"You added successfully a new dorm wing: %@",room.roomName];
    }else {
        message = @"Your room name must not be empty.";
    }
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
    [alert show];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)cancelNewRoomAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setUp];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.wingsArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.wingsArray objectAtIndex:row];
}

@end
