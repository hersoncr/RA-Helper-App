//
//  DormWing+Create.m
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/18/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import "DormWing+Create.h"

@implementation DormWing (Create)
+ (DormWing *) dormWingWithName:(NSString *)dormWingName AndWithDormName:(NSString *)dormName inContext:(NSManagedObjectContext *) context
{
    DormWing *dormWing = nil;
    
    // Query the database to see if name is already stored there
    //  (1) Initialize a NSFetchRequest with the desired Entity defined in the DB schema
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DormWing"];
    
    //  (2) Add the information for the predicate (matching criteria)
    request.predicate = [NSPredicate predicateWithFormat:@"wingName = %@", dormWingName];
    //  (3) Add sort keys to the fetch request
    
    //  (4) Execute the fetch  (we'll ignore the errors here)
    NSError *error = nil;
    NSArray *dormWings = [context executeFetchRequest:request error:&error];
    
    //  (5) See what we got
    if (!dormWings || ([dormWings count] > 1)) {
        // if nil, there is some type of problem (would be better to handle this, but ... )
        // Since we are searching for a specific name, there should NOT be more than 1 match.  If count > 1, error!
        if (dormWings.count > 1)
        {
            [context deleteObject:[dormWings lastObject]];
        }
        NSLog(@"Error!  dormWings = %@",dormWings);
        
        
    } else if ([dormWings count] == 0) {
        // No match found.  Add a photographer entity to the database
        dormWing = [NSEntityDescription insertNewObjectForEntityForName:@"DormWing"
                                             inManagedObjectContext:context];
        // and set its attribute
        dormWing.wingName = dormWingName;
        dormWing.dorm = dormName;
        
    } else {
        // Found matching entry in database.  Return it!
        dormWing = [dormWings lastObject];
    }
    
    return dormWing;
}
+ (NSArray *) getAllDormWingsWithContext:(NSManagedObjectContext *)context
{
    static NSArray * dormWings = nil;
    if(!dormWings || dormWings.count == 0)
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DormWing"];
        NSError *error = nil;
        dormWings = [context executeFetchRequest:request error:&error];
        
        if (!dormWings ) {
            // if nil, there is some type of problem (would be better to handle this, but ... )
            // Since we are searching for a specific name, there should NOT be more than 1 match.  If count > 1, error!
            NSLog(@"Error!  dormWings = %@",dormWings);
        }else if([dormWings count] == 0)
        {
            dormWings = [[NSArray alloc] init];
        }else{
            [context save:nil];
        }
    }
    
    return dormWings;
}
@end
