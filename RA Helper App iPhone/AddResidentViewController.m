//
//  AddResidentViewController.m
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/18/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import "AddResidentViewController.h"
#import "Room+Create.h"
#import "Resident+Create.h"

@interface AddResidentViewController ()
@property (strong,nonatomic) UIManagedDocument * roomsDatabase;
@end

@implementation AddResidentViewController
@synthesize scrollViewOutlet = _scrollViewOutlet;
@synthesize pickerViewOutlet = _pickerViewOutlet;
@synthesize pickerViewDataSource = _pickerViewDataSource;
@synthesize firstNameOutlet = _firstNameOutlet;
@synthesize lastNameOutlet = _lastNameOutlet;
@synthesize phoneOutlet = _phoneOutlet;
@synthesize studentIDOutlet = _studentIDOutlet;
@synthesize roomsDatabase = _roomsDatabase;


- (void) setRoomsDatabase:(UIManagedDocument *)roomsDatabase
{
    if (_roomsDatabase!= roomsDatabase) {
        _roomsDatabase = roomsDatabase;
        [self useDocument:roomsDatabase];
    }
}

- (void)useDocument:(UIManagedDocument *) document
{   // Open or create the document here and call setupFetchedResultsController
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:[document.fileURL path]] ) {
        // document does not exist on disk, so create it (using a BLOCK on a separate thread)
        [document saveToURL:document.fileURL
           forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
               if (success) {
                   self.pickerViewDataSource = [Room getAllRoomsWithContext:self.roomsDatabase.managedObjectContext];
                   [self.pickerViewOutlet reloadAllComponents];
                   [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];

               }
           }];
        
    } else if (document.documentState == UIDocumentStateClosed) {
        // document does exist on disk, but we need to open it (again, we use a separate thread)
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                self.pickerViewDataSource = [Room getAllRoomsWithContext:self.roomsDatabase.managedObjectContext];
                [self.pickerViewOutlet reloadAllComponents];
                [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];

            }
        }];
        
    } else if (document.documentState == UIDocumentStateNormal) {
        self.pickerViewDataSource = [Room getAllRoomsWithContext:self.roomsDatabase.managedObjectContext];
        [self.pickerViewOutlet reloadAllComponents];
        // document is already open and ready to use
        [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];

    }
    
}

- (void) setUp
{
    if (!self.roomsDatabase) {  // we'll create a default database if none is set
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Default APP Database"];
        // url is now "<Documents Directory>/Default Status Database"
        
        // Now create the document on disk and call the setter for statusDatabase property
        self.roomsDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
        
    }

    
    self.pickerViewDataSource = [Room getAllRoomsWithContext:self.roomsDatabase.managedObjectContext];
    self.pickerViewOutlet.dataSource = self;
    self.pickerViewOutlet.delegate = self;
    
    UIView * subView = [self.scrollViewOutlet.subviews objectAtIndex:0];
    self.scrollViewOutlet.contentSize = CGSizeMake(subView.bounds.size.width, subView.bounds.size.height);
    NSLog(@"height = %g, width = %g ",subView.bounds.size.height, subView.bounds.size.width);
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
	// Do any additional setup after loading the view.
}
- (IBAction)cancelNewResidentAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)addNewResidentAction:(id)sender {
    NSString * firstName = self.firstNameOutlet.text;
    NSString * lastName = self.lastNameOutlet.text;
    NSString * phone = self.phoneOutlet.text;
    int selectedIndex = [self.pickerViewOutlet selectedRowInComponent:0];
    Room * room =[self.pickerViewDataSource objectAtIndex:selectedIndex];
    NSString * studentID = self.studentIDOutlet.text;
    
    
    NSString * message = nil;
    if (![@"" isEqualToString:firstName] && ![@"" isEqualToString:lastName] && ![@"" isEqualToString:phone] && ![@"" isEqualToString:room.roomName] && ![@"" isEqualToString:studentID]) {
        Resident * resident = [Resident residentWithFirstName:firstName LastName:lastName Phone:phone ResidentID:studentID room:room inManagedObjectContext:self.roomsDatabase.managedObjectContext];
        NSError * error = nil;
        if (!resident || [self.roomsDatabase.managedObjectContext save:&error]) {
            message = [NSString stringWithFormat:@"A new Resident was sucessfully added: %@, %@ in room(%@) ",resident.lastName,resident.firstName,resident.room.roomName];
        }else{
            message = [NSString stringWithFormat: @"Error while inserting new resident. Error: %@",error.description ];
        }
        
    }else
    {
        message = @"Fields must not be empty";
    }
    
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
    [alert show];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    return self.pickerViewDataSource.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[self.pickerViewDataSource objectAtIndex:row] roomName];
}
@end
