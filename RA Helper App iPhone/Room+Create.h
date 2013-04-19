//
//  Room+Create.h
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/18/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import "Room.h"

@interface Room (Create)
+ (Room *) roomWithName:(NSString *) roomName inWing:(NSString *) wingName andWithContext:(NSManagedObjectContext *) context;


@end
