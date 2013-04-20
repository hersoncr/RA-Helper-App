 //
//  Resident+Create.m
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/17/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import "Resident+Create.h"

@implementation Resident (Create)
+ (Resident *)residentWithFirstName:(NSString *)firstName  LastName:(NSString *)lastName Phone:(NSString *) phoneNumber ResidentID:(NSString *)residentID room:(Room *)room inManagedObjectContext:(NSManagedObjectContext *)context
{
    Resident *resident = nil;
    
    // Query the database to see if name is already stored there
    //  (1) Initialize a NSFetchRequest with the desired Entity defined in the DB schema
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Resident"];
    
    //  (2) Add the information for the predicate (matching criteria)
    request.predicate = [NSPredicate predicateWithFormat:@"firstName = %@", firstName];
    //  (3) Add sort keys to the fetch request
    
    //  (4) Execute the fetch  (we'll ignore the errors here)
    NSError *error = nil;
    NSArray *residents = [context executeFetchRequest:request error:&error];
    
    //  (5) See what we got
    if (!residents || ([residents count] > 1)) {
        // if nil, there is some type of problem (would be better to handle this, but ... )
        // Since we are searching for a specific name, there should NOT be more than 1 match.  If count > 1, error!
        NSLog(@"Error!  residents = %@",residents);
        
        
    } else if ([residents count] == 0) {
        // No match found.  Add a photographer entity to the database
        resident = [NSEntityDescription insertNewObjectForEntityForName:@"Resident"
                                               inManagedObjectContext:context];
        // and set its attribute
        resident.firstName = firstName;
        resident.lastName = lastName;
        resident.phone = phoneNumber;
        resident.room = room;
        resident.residentId = [NSNumber numberWithInteger:[residentID integerValue]];
        
    } else {
        // Found matching entry in database.  Return it!
        resident = [residents lastObject];
    }
    
    return resident;
}

+ (NSArray *) getAllResidentsInContext:(NSManagedObjectContext *)context
{
    NSArray * residents = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Resident"];
    NSError *error = nil;
    residents = [context executeFetchRequest:request error:&error];
    
    if (!residents ) {
        // if nil, there is some type of problem (would be better to handle this, but ... )
        // Since we are searching for a specific name, there should NOT be more than 1 match.  If count > 1, error!
        NSLog(@"Error!  residents = %@",residents);
    }else if([residents count] == 0)
    {
        residents = [[NSArray alloc] init];
    }
    
    
    return residents;
}
@end
