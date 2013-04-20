//
//  Room+Create.m
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/18/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import "Room+Create.h"
#import "DormWing+Create.h"
@implementation Room (Create)
+ (Room *) roomWithName:(NSString *) roomName inWing:(DormWing *) dormWing andWithContext:(NSManagedObjectContext *)context
{
    Room *room = nil;
    
    // Query the database to see if name is already stored there
    //  (1) Initialize a NSFetchRequest with the desired Entity defined in the DB schema
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Room"];
    
    //  (2) Add the information for the predicate (matching criteria)
    request.predicate = [NSPredicate predicateWithFormat:@"roomName = %@", roomName];
    //  (3) Add sort keys to the fetch request
    
    //  (4) Execute the fetch  (we'll ignore the errors here)
    NSError *error = nil;
    NSArray *rooms = [context executeFetchRequest:request error:&error];
    
    //  (5) See what we got
    if (!rooms || ([rooms count] > 1)) {
        // if nil, there is some type of problem (would be better to handle this, but ... )
        // Since we are searching for a specific name, there should NOT be more than 1 match.  If count > 1, error!
        if (rooms.count > 1)
        {
            [context deleteObject:[rooms lastObject]];
        }
        NSLog(@"Error!  rooms = %@",rooms);
        
        
    } else if ([rooms count] == 0) {
        // No match found.  Add a photographer entity to the database
        room = [NSEntityDescription insertNewObjectForEntityForName:@"Room"
                                               inManagedObjectContext:context];
        // and set its attribute
        room.roomName = roomName;
        
        room.wing = [DormWing dormWingWithName:[dormWing wingName] AndWithDormName:[dormWing dorm] inContext:context];
    } else {
        // Found matching entry in database.  Return it!
        room = [rooms lastObject];
    }
    
    return room;
}

+ (NSArray *) getAllRoomsWithContext:(NSManagedObjectContext *)context
{
    static NSArray * rooms = nil;
    if(!rooms || rooms.count== 0)
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Room"];
        NSError *error = nil;
        rooms = [context executeFetchRequest:request error:&error];
        
        if (!rooms ) {
            // if nil, there is some type of problem (would be better to handle this, but ... )
            // Since we are searching for a specific name, there should NOT be more than 1 match.  If count > 1, error!
            NSLog(@"Error!  rooms = %@",rooms);
        }else if([rooms count] == 0)
        {
            rooms = [[NSArray alloc] init];
        }
    }
    
    return rooms;
}

@end
