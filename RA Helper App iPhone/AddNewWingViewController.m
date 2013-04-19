//
//  AddNewWingViewController.m
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/18/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import "AddNewWingViewController.h"
#import "DormWing+Create.h"
@interface AddNewWingViewController ()

@end

@implementation AddNewWingViewController
@synthesize wingsDatabase = _wingsDatabase;
@synthesize wingNameTextField = _wingNameTextField;


- (void) setWingsDatabase:(UIManagedDocument *)wingsDatabase
{
    if (wingsDatabase!= _wingsDatabase) {
        _wingsDatabase = wingsDatabase;
        [self useDocument];
    }
}

- (void)useDocument
{   // Open or create the document here and call setupFetchedResultsController
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:[self.wingsDatabase.fileURL path]] ) {
        // document does not exist on disk, so create it (using a BLOCK on a separate thread)
        [self.wingsDatabase saveToURL:self.wingsDatabase.fileURL
                      forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
                          if (success) {
                              //[self populateStatusDatabaseWithDefaults];
                          }
                      }];
        
    } else if (self.wingsDatabase.documentState == UIDocumentStateClosed) {
        // document does exist on disk, but we need to open it (again, we use a separate thread)
        [self.wingsDatabase openWithCompletionHandler:^(BOOL success) {
            if (success) {
                //[self populateStatusDatabaseWithDefaults];
            }
        }];
        
    } else if (self.wingsDatabase.documentState == UIDocumentStateNormal) {
        // document is already open and ready to use
        //[self populateStatusDatabaseWithDefaults];
    }
    
}

- (void) setUp
{
    
    if (!self.wingsDatabase) {  // we'll create a default database if none is set
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Default Wings Database"];
        // url is now "<Documents Directory>/Default Status Database"
        
        // Now create the document on disk and call the setter for statusDatabase property
        self.wingsDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
        
    }
}
- (IBAction)addNewWingAction:(id)sender {
    NSString *message = nil;
    
    //[NSString stringWithFormat:@"You selected: %@",];
    
    if (!self.wingNameTextField.text || ![self.wingNameTextField.text isEqualToString:@""])
    {
        DormWing * dormWing = [DormWing dormWingWithName:self.wingNameTextField.text inContext:self.wingsDatabase.managedObjectContext];
        if([self.wingsDatabase.managedObjectContext save:nil])
        {
            message = [NSString stringWithFormat:@"You added successfully a new dorm wing: %@",dormWing.wingName];
        }else{
            message = @"An error ocurred while inserting record";
        }
    }else {
        message = @"Your wing name must not be empty.";
    }
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
    [alert show];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)cancelAddNewWing:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
	// Do any additional setup after loading the view.
    [self setUp];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
