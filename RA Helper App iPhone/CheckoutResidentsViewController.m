//
//  CheckoutResidentsViewController.m
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/13/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//
#import <CoreData/CoreData.h>
#import "CheckoutResidentsViewController.h"
#import "Status.h"
#import "Resident.h"
#import "Room.h"
#import "AppDelegate.h"
#import "Status+Status_Create.h"
@interface CheckoutResidentsViewController ()
@property NSArray *statuses;
@end



@implementation CheckoutResidentsViewController
@synthesize residents = _residents;
@synthesize statuses = _statuses;
@synthesize statusDatabase = _statusDatabase;


- (void)setStatusDatabase:(UIManagedDocument *)statusDatabase
{
    // setter for photoDatabase
    if (_statusDatabase != statusDatabase) {
        _statusDatabase = statusDatabase;
        [self useDocument];
    }
}

- (void) populateStatusDatabaseWithDefaults
{
    _statuses = [self getStatuses];
}

- (void)useDocument
{   // Open or create the document here and call setupFetchedResultsController
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:[self.statusDatabase.fileURL path]] ) {
        // document does not exist on disk, so create it (using a BLOCK on a separate thread)
        [self.statusDatabase saveToURL:self.statusDatabase.fileURL
                     forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
                         if (success) {
                             [self populateStatusDatabaseWithDefaults];
                         }
                     }];
        
    } else if (self.statusDatabase.documentState == UIDocumentStateClosed) {
        // document does exist on disk, but we need to open it (again, we use a separate thread)
        [self.statusDatabase openWithCompletionHandler:^(BOOL success) {
            if (success) {
                [self populateStatusDatabaseWithDefaults];
            }
        }];
        
    } else if (self.statusDatabase.documentState == UIDocumentStateNormal) {
        // document is already open and ready to use
        [self populateStatusDatabaseWithDefaults];
    }
    
}

- (NSArray *) getStatuses {
    
    static NSArray  * statuses = nil;
    
    if (statuses == nil)
    {
        statuses = [Status getAllStatusesWithContext:self.statusDatabase.managedObjectContext];
        
    }
    
    return statuses;
}

- (void) setUp
{
    if (!self.statusDatabase) {  // we'll create a default database if none is set
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Default Status Database"];
        // url is now "<Documents Directory>/Default Status Database"
        
        // Now create the document on disk and call the setter for statusDatabase property
        self.statusDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
        
    }
    [self populateStatusDatabaseWithDefaults];
   
    
   
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
    return [self.residents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Check Resident Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Resident * resident = [self.residents objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@",resident.lastName,resident.firstName];
    cell.detailTextLabel.text = resident.room.roomName;
    
    return cell;
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

@end
