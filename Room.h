//
//  Room.h
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/13/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DormWing, Resident;

@interface Room : NSManagedObject

@property (nonatomic, retain) NSString * roomName;
@property (nonatomic, retain) DormWing *wing;
@property (nonatomic, retain) NSSet *residents;
@end

@interface Room (CoreDataGeneratedAccessors)

- (void)addResidentsObject:(Resident *)value;
- (void)removeResidentsObject:(Resident *)value;
- (void)addResidents:(NSSet *)values;
- (void)removeResidents:(NSSet *)values;

@end
