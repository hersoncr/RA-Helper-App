//
//  Status+Status_Create.m
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/17/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import "Status+Status_Create.h"

@implementation Status (Status_Create)
+ (Status *)statusWithName:(NSString *)name
                inManagedObjectContext:(NSManagedObjectContext *)context
{
    Status *status = nil;
    
    // Query the database to see if name is already stored there
    //  (1) Initialize a NSFetchRequest with the desired Entity defined in the DB schema
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Status"];
    
    //  (2) Add the information for the predicate (matching criteria)
     request.predicate = [NSPredicate predicateWithFormat:@"statusName = %@", name];
    //  (3) Add sort keys to the fetch request
    
    //  (4) Execute the fetch  (we'll ignore the errors here)
    NSError *error = nil;
    NSArray *statuses = [context executeFetchRequest:request error:&error];
    
    //  (5) See what we got
    if (!statuses || ([statuses count] > 1)) {
        // if nil, there is some type of problem (would be better to handle this, but ... )
        // Since we are searching for a specific name, there should NOT be more than 1 match.  If count > 1, error!
        if (statuses.count > 1) {
            [context deleteObject:[statuses lastObject]];
        }
        NSLog(@"Error!  statuses = %@",statuses);
        
        
    } else if ([statuses count] == 0) {
        // No match found.  Add a photographer entity to the database
        status = [NSEntityDescription insertNewObjectForEntityForName:@"Status"
                                                     inManagedObjectContext:context];
        // and set its attribute
        status.statusName = name;
        
    } else {
        // Found matching entry in database.  Return it!
        status = [statuses lastObject];
    }
    
    return status;
}



+ (NSArray *) getAllStatusesWithContext:(NSManagedObjectContext *)context
{
    static NSArray * statusesNames = nil;
    static NSArray * statusesStatic = nil;
    
    if (statusesStatic == nil)
    {        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Status"];
        NSError *error = nil;
        statusesStatic = [context executeFetchRequest:request error:&error];
        
        if (!statusesStatic ) {
            // if nil, there is some type of problem (would be better to handle this, but ... )
            // Since we are searching for a specific name, there should NOT be more than 1 match.  If count > 1, error!
            NSLog(@"Error!  statuses = %@",statusesStatic);
        }else if([statusesStatic count] == 0)
        {
            NSMutableArray * statuses = [[NSMutableArray alloc] init];
            if (statusesNames == nil) {
                statusesNames = [[NSArray alloc] initWithObjects:@"Present",@"Absent",@"Excused", nil];
            }
            for (NSString * name in statusesNames) {
               [statuses  addObject:[Status statusWithName:name inManagedObjectContext:context]];
               [context save:nil];
            }
            statusesStatic = statuses;
        }
    }
    
    return statusesStatic;
}
@end
