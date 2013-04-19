//
//  AddResidentViewController.m
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/18/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import "AddResidentViewController.h"
#import "Room+Create.h"
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

- (void) setUp
{
    if (!self.roomsDatabase) {  // we'll create a default database if none is set
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Default Rooms Database"];
        // url is now "<Documents Directory>/Default Status Database"
        
        // Now create the document on disk and call the setter for statusDatabase property
        self.roomsDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
        self.pickerViewDataSource = [Room getAllRoomsWithContext:self.roomsDatabase.managedObjectContext];
    }

    
    self.pickerViewDataSource = [[NSArray alloc] initWithObjects:@"218",@"217",@"216",@"318", nil];
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
- (IBAction)addNewResidentAction:(id)sender {
    int selectedIndex = [self.pickerViewOutlet selectedRowInComponent:0];
    NSString *message = [NSString stringWithFormat:@"You selected: %@",[self.pickerViewDataSource objectAtIndex:selectedIndex]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
    [alert show];
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
    return [self.pickerViewDataSource objectAtIndex:row];
}
@end
