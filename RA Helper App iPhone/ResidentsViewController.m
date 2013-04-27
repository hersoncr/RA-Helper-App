//
//  ResidentsViewController.m
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/17/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import "ResidentsViewController.h"
#import "Resident.h"
#import "Room.h"
#import "Resident+Create.h"

@interface ResidentsViewController () <UpdateTableView>

@end

@implementation ResidentsViewController
@synthesize residentsDatabase = _residentsDatabase;

- (void) updateTableView
{
    [self.tableView reloadData];
}
- (void) viewWillAppear:(BOOL)animated
{
    [self updateTableView];
}

- (void) setUp
{
    if (!self.residentsDatabase) {  // we'll create a default database if none is set
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Default APP Database"];
        // url is now "<Documents Directory>/Default Residents Database"
        
        // Now create the document on disk and call the setter for photoDatabase property
        self.residentsDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }
    
}
/*
- (IBAction)addResident:(id)sender {
    [Resident residentWithFirstName:@"Default" LastName:@"DefaultLastName" Phone:@"000-000-0000" ResidentID:@"00000000" inManagedObjectContext:self.residentsDatabase.managedObjectContext];
    [self.residentsDatabase.managedObjectContext save:nil];
}*/

- (void)setResidentsDatabase:(UIManagedDocument *)residentsDatabase
{
    // setter for photoDatabase
    if (_residentsDatabase != residentsDatabase) {
        _residentsDatabase = residentsDatabase;
        [self useDocument];
    }
}


- (void)useDocument
{   // Open or create the document here and call setupFetchedResultsController
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:[self.residentsDatabase.fileURL path]] ) {
        // document does not exist on disk, so create it (using a BLOCK on a separate thread)
        [self.residentsDatabase saveToURL:self.residentsDatabase.fileURL
                     forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
                         if (success) {
                             [self setupFetchedResultsController];
                             // In case the app should shut down before AUTOSAVING kicks in
                             [self.residentsDatabase saveToURL:self.residentsDatabase.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
                             

                             
                         }
                     }];
        
    } else if (self.residentsDatabase.documentState == UIDocumentStateClosed) {
        // document does exist on disk, but we need to open it (again, we use a separate thread)
        [self.residentsDatabase openWithCompletionHandler:^(BOOL success) {
            if (success) {
                [self setupFetchedResultsController];
                [self.residentsDatabase saveToURL:self.residentsDatabase.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
            }
        }];
        
    } else if (self.residentsDatabase.documentState == UIDocumentStateNormal) {
        // document is already open and ready to use
        [self setupFetchedResultsController];
        [self.residentsDatabase saveToURL:self.residentsDatabase.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
    }
    
}


// The following method will create an NSFetchRequest to get all Residents and
// hook it up to our table via an NSFetchedResultsController

- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    // Query the database to see if Resident's first name is already stored there
    //  (1) Initialize a NSFetchRequest with the desired Entity defined in the DB schema
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Resident"];
    
    //  (2) Since we want ALL of the residents for this tableView,
    //      we don't want to specify a predicate
    
    
    //  (3) Add sort keys to the fetch request  (Note the use of "CaseInsensitiveCompare")
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    //  (4) Attach the request to this tableViewController (see Apple Docs)
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.residentsDatabase.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
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
    return [self.fetchedResultsController.fetchedObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Resident Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Resident * resident = [self.fetchedResultsController objectAtIndexPath:indexPath];
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
