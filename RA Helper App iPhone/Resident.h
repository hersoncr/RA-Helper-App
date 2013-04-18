//
//  Resident.h
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/15/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CurfewCheck, Room;

@interface Resident : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSNumber * residentId;
@property (nonatomic, retain) NSSet *checkouts;
@property (nonatomic, retain) Room *room;
@end

@interface Resident (CoreDataGeneratedAccessors)

- (void)addCheckoutsObject:(CurfewCheck *)value;
- (void)removeCheckoutsObject:(CurfewCheck *)value;
- (void)addCheckouts:(NSSet *)values;
- (void)removeCheckouts:(NSSet *)values;

@end
