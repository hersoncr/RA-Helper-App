 //
//  CheckoutResidentsViewController.m
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/13/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//
#import <CoreData/CoreData.h>
#import "CheckRoomsViewController.h"
#import "CurfewCheckStatusTableViewController.h"
#import "Resident+Create.h"
#import "Room+Create.h"
#import "AppDelegate.h"
#import "Status+Status_Create.h"
#import "CurfewCheck+Create.h"
#import <AVFoundation/AVFoundation.h>

@interface CheckRoomsViewController ()
@property (nonatomic,strong) NSArray *statuses;
@property (nonatomic,strong) AVCaptureSession * AVSession;
@end



@implementation CheckRoomsViewController
@synthesize curfewChecks = _curfewChecks;
@synthesize statuses = _statuses;
@synthesize statusDatabase = _statusDatabase;
@synthesize AVSession = _AVSession;

- (NSArray *) curfewChecks
{
    if (!_curfewChecks || _curfewChecks.count == 0) {
        _curfewChecks = [CurfewCheck getAllCurfewChecksWithContext:self.statusDatabase.managedObjectContext AtDate:[self getTodayDate]];
    }
    return _curfewChecks;
}

- (NSDate *) getTodayDate{

    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    [comps setHour:0];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
    
}

- (void)setStatusDatabase:(UIManagedDocument *)statusDatabase
{
    // setter for statusDatabase
    if (_statusDatabase != statusDatabase) {
        _statusDatabase = statusDatabase;
        [self useDocument];
    }
}
- (void) viewWillAppear:(BOOL)animated
{
    [self updateTableView];
}

- (void) populateStatusDatabaseWithDefaults
{
    _statuses = [self getStatuses];
}

- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    
    // Query the database to see if Resident's first name is already stored there
    //  (1) Initialize a NSFetchRequest with the desired Entity defined in the DB schema
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CurfewCheck"];
    
    //  (2) predicate: we only want today's records
    request.predicate = [NSPredicate predicateWithFormat:@"date = %@", [self getTodayDate]];
    
    //  (3) Add sort keys to the fetch request 
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    //  (4) Attach the request to this tableViewController (see Apple Docs)
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.statusDatabase.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (void)useDocument
{   // Open or create the document here and call setupFetchedResultsController
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:[self.statusDatabase.fileURL path]] ) {
        // document does not exist on disk, so create it (using a BLOCK on a separate thread)
        [self.statusDatabase saveToURL:self.statusDatabase.fileURL
                     forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
                         if (success) {
                             [self populateStatusDatabaseWithDefaults];
                             [self setupFetchedResultsController];
                             // In case the app should shut down before AUTOSAVING kicks in
                             [self.statusDatabase saveToURL:self.statusDatabase.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
                             [self populateCheckCurfewForAllResidentsIn:[self getTodayDate]];
                             [self updateTableView];
                         }
                     }];
        
    } else if (self.statusDatabase.documentState == UIDocumentStateClosed) {
        // document does exist on disk, but we need to open it (again, we use a separate thread)
        [self.statusDatabase openWithCompletionHandler:^(BOOL success) {
            if (success) {
                [self populateStatusDatabaseWithDefaults];
                [self setupFetchedResultsController];
                // In case the app should shut down before AUTOSAVING kicks in
                [self.statusDatabase saveToURL:self.statusDatabase.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
                [self populateCheckCurfewForAllResidentsIn:[self getTodayDate]];
                [self updateTableView];
                
            }
        }];
        
    } else if (self.statusDatabase.documentState == UIDocumentStateNormal) {
        // document is already open and ready to use
        [self populateStatusDatabaseWithDefaults];
        [self setupFetchedResultsController];
        // In case the app should shut down before AUTOSAVING kicks in
        [self.statusDatabase saveToURL:self.statusDatabase.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
        [self populateCheckCurfewForAllResidentsIn:[self getTodayDate]];
        [self updateTableView];
    }
    
}

- (NSArray *) getStatuses
{
        
    if (self.statuses == nil || self.statuses.count == 0)
    {
        self.statuses = [Status getAllStatusesWithContext:self.statusDatabase.managedObjectContext];
    }
    
    return self.statuses;
}
- (int) getNumberOfAbsenteesInCurfewChecks:(NSArray *) curfewChecks
{
    int result = 0;
    for (CurfewCheck * curfewCheck in curfewChecks)
    {
        if ([curfewCheck.status.statusName isEqualToString:@"Absent"]) {
            result++;
        }
    }
    return result;
}
- (void) updateTableView
{
    
    if (!self.statusDatabase) {
        [self setUp];
    }else {
        [self populateCheckCurfewForAllResidentsIn:[self getTodayDate]];
    }
    
    [self.statusDatabase.managedObjectContext processPendingChanges];
    self.curfewChecks = [CurfewCheck getAllCurfewChecksWithContext:self.statusDatabase.managedObjectContext AtDate:[self getTodayDate]];
    
    [self.tableView reloadData];
    int result = [self getNumberOfAbsenteesInCurfewChecks:self.curfewChecks];
    [UIApplication sharedApplication].applicationIconBadgeNumber = result;
}

- (void) populateCheckCurfewForAllResidentsIn:(NSDate *) date
{
    
    Status * absentStatus = [Status statusWithName:@"Absent" inManagedObjectContext:self.statusDatabase.managedObjectContext];
    NSArray * residents = [Resident getAllResidentsInContext:self.statusDatabase.managedObjectContext];
    if (absentStatus) {
    
        for (Resident * resident in residents)
        {
            
            CurfewCheck * curfewCheck = [CurfewCheck curfewCheckResident:resident andAtDate:[self getTodayDate] withStatus:absentStatus onContext:self.statusDatabase.managedObjectContext];
            NSError * error = nil;
            if (![self.statusDatabase.managedObjectContext save:&error]) {
                NSLog(@"Error occurred when inserting default status of check out to residents: %@",error.description);
            }else{
                NSLog(@" Resident: %@ Date: %@",resident.firstName,curfewCheck.date);
                
            }
        }
        
    }else{
        NSError * error = nil;
        if (![self.statusDatabase.managedObjectContext save:&error]) {
            NSLog(@"Error occurred when inserting default status of check out to residents: %@",error.description);
        }
    }
}

- (void) setUp
{
   
    if (!self.statusDatabase) {  // we'll create a default database if none is set
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Default APP Database"];
        // url is now "<Documents Directory>/Default Status Database"
        
        // Now create the document on disk and call the setter for statusDatabase property
        self.statusDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
        
    }
   
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.curfewChecks count];
}
- (IBAction)flashButton:(id)sender {
  
        
    [self toggleFlashlight];
    
}
- (void)toggleFlashlight
{
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device){
        
    
        if (device.torchMode == AVCaptureTorchModeOff)
        {
            // Create an AV session
            AVCaptureSession *session = [[AVCaptureSession alloc] init];
        
            // Create device input and add to current session
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device    error: nil];
            [session addInput:input];
        
            // Create video output and add to current session
            AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
            [session addOutput:output];
        
            // Start session configuration
            [session beginConfiguration];
            [device lockForConfiguration:nil];
        
            // Set torch to on
            [device setTorchMode:AVCaptureTorchModeOn];
            
            [device unlockForConfiguration];
            [session commitConfiguration];
        
            // Start the session
            [session startRunning];
        
            // Keep the session around
            [self setAVSession:session];
        
            
        }
        else
        {   
            [self.AVSession stopRunning];
            self.AVSession = nil;
        }
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Check Resident Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    CurfewCheck * curfewCheck = (CurfewCheck *)[self.curfewChecks objectAtIndex:indexPath.row];
    
    if ([curfewCheck.status.statusName isEqualToString:@"Absent"]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark; 
    }
    Resident * resident = curfewCheck.residentId;
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@",resident.lastName,resident.firstName];
    cell.detailTextLabel.text = curfewCheck.status.statusName;
    
    return cell;
}
- (IBAction)refreshCurfewChecks:(id)sender {
    //self.curfewChecks = [CurfewCheck getAllCurfewChecksWithContext:self.statusDatabase.managedObjectContext];
    [self updateTableView];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Check Rooms Status"])
    {
        // Get reference to the destination view controller
        CurfewCheckStatusTableViewController * tableViewController = [segue destinationViewController];
        UITableViewCell * cell = (UITableViewCell *) sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        tableViewController.curfewCheck = [self.curfewChecks objectAtIndex:indexPath.row];
        tableViewController.statusDatabase = self.statusDatabase;
        tableViewController.title = [NSString stringWithFormat:@"Status for %@, %@",tableViewController.curfewCheck.residentId.firstName,tableViewController.curfewCheck.residentId.lastName];
    }
}
@end
