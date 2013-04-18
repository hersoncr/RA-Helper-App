//
//  DormWing.h
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/15/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Room;

@interface DormWing : NSManagedObject

@property (nonatomic, retain) NSString * dorm;
@property (nonatomic, retain) NSString * wingName;
@property (nonatomic, retain) NSSet *rooms;
@end

@interface DormWing (CoreDataGeneratedAccessors)

- (void)addRoomsObject:(Room *)value;
- (void)removeRoomsObject:(Room *)value;
- (void)addRooms:(NSSet *)values;
- (void)removeRooms:(NSSet *)values;

@end
