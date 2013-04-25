//
//  CurfewCheckStatusTableViewController.m
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/20/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import "CurfewCheckStatusTableViewController.h"

@interface CurfewCheckStatusTableViewController ()

@end

@implementation CurfewCheckStatusTableViewController
@synthesize statusDatabase = _statusDatabase;
@synthesize curfewCheck = _curfewCheck;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setUp];
    }
    return self;
}

- (void)setStatusDatabase:(UIManagedDocument *)statusDatabase
{
    // setter for statusDatabase
    if (_statusDatabase != statusDatabase) {
        _statusDatabase = statusDatabase;
        [self useDocument];
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

- (void)useDocument
{   // Open or create the document here and call setupFetchedResultsController
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:[self.statusDatabase.fileURL path]] ) {
        // document does not exist on disk, so create it (using a BLOCK on a separate thread)
        [self.statusDatabase saveToURL:self.statusDatabase.fileURL
                      forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
                          if (success) {
                              
                              [self setupFetchedResultsController];
                              // In case the app should shut down before AUTOSAVING kicks in
                              [self.statusDatabase saveToURL:self.statusDatabase.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
                              
                          }
                      }];
        
    } else if (self.statusDatabase.documentState == UIDocumentStateClosed) {
        // document does exist on disk, but we need to open it (again, we use a separate thread)
        [self.statusDatabase openWithCompletionHandler:^(BOOL success) {
            if (success) {
                
                [self setupFetchedResultsController];
                // In case the app should shut down before AUTOSAVING kicks in
                [self.statusDatabase saveToURL:self.statusDatabase.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
                
            }
        }];
        
    } else if (self.statusDatabase.documentState == UIDocumentStateNormal) {
        // document is already open and ready to use
        
        [self setupFetchedResultsController];
        // In case the app should shut down before AUTOSAVING kicks in
        [self.statusDatabase saveToURL:self.statusDatabase.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
       
    }
    
}


- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    
    // Query the database to see if Resident's first name is already stored there
    //  (1) Initialize a NSFetchRequest with the desired Entity defined in the DB schema
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Status"];
    
    //  (2) predicate
    
    //  (3) Add sort keys to the fetch request
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"statusName" ascending:YES];
    
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    //  (4) Attach the request to this tableViewController (see Apple Docs)
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.statusDatabase.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    Status * status = (Status *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    self.curfewCheck.status = status;
    
    NSError * error = nil;
    if (![self.curfewCheck.managedObjectContext save:&error])
    {
        NSLog(@"Error occurred while updating status: %@",error.description);
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Status Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Status * status = (Status *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = status.statusName;
    
    return cell;
}
@end
