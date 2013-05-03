//
//  CurfewCheck+Create.m
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/19/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import "CurfewCheck+Create.h"


@implementation CurfewCheck (Create)
+ (CurfewCheck *) curfewCheckResident:(Resident *) resident andAtDate:(NSDate *)date withStatus:(Status *)status onContext:(NSManagedObjectContext *) context
{
    CurfewCheck * curfewCheck = nil;
    
    // Query the database to see if name is already stored there
    //  (1) Initialize a NSFetchRequest with the desired Entity defined in the DB schema
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CurfewCheck"];
    
    //  (2) Add the information for the predicate (matching criteria)
    request.predicate = [NSPredicate predicateWithFormat:@"date = %@ AND residentId = %@ ", date,resident];
    //  (3) Add sort keys to the fetch request
   
    //  (4) Execute the fetch  (we'll ignore the errors here)
    NSError *error = nil;
    NSArray *curfewChecks = [context executeFetchRequest:request error:&error];
    
    //  (5) See what we got
    if (!curfewChecks || ([curfewChecks count] > 1)) {
        // if nil, there is some type of problem (would be better to handle this, but ... )
        // Since we are searching for a specific name, there should NOT be more than 1 match.  If count > 1, error!
        if (curfewChecks.count > 1)
        {
            [context deleteObject:[curfewChecks lastObject]];
        }
        NSLog(@"Error!  curfew checks = %@",curfewChecks);
        
        
    } else if ([curfewChecks count] == 0) {
        // No match found.  Add a photographer entity to the database
        curfewCheck = [NSEntityDescription insertNewObjectForEntityForName:@"CurfewCheck"
                                             inManagedObjectContext:context];
        curfewCheck.residentId = resident;
        
        curfewCheck.date = date;
        curfewCheck.status = status;
        
    } else {
        // Found matching entry in database.  Return it!
        curfewCheck = [curfewChecks lastObject];
    }

    
    return curfewCheck;
}

+ (NSArray *) getAllCurfewChecksWithContext:(NSManagedObjectContext *)context AtDate:(NSDate *)date 
{
    NSArray * curfewChecks = [NSArray new];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CurfewCheck"];
    request.predicate = [NSPredicate predicateWithFormat:@"date = %@ ", date];
    NSError *error = nil;
    curfewChecks = [context executeFetchRequest:request error:&error];
    
    if (!curfewChecks ) {
        // if nil, there is some type of problem (would be better to handle this, but ... )
        // Since we are searching for a specific name, there should NOT be more than 1 match.  If count > 1, error!
        NSLog(@"Error!  curfew checks = %@",curfewChecks);
    }else if([curfewChecks count] == 0)
    {
        curfewChecks = [[NSArray alloc] init];
    }

    return curfewChecks;
}

@end
