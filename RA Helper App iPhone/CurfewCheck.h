//
//  CurfewCheck.h
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/15/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Resident, Status;

@interface CurfewCheck : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Resident *residentId;
@property (nonatomic, retain) NSSet *status;
@end

@interface CurfewCheck (CoreDataGeneratedAccessors)

- (void)addStatusObject:(Status *)value;
- (void)removeStatusObject:(Status *)value;
- (void)addStatus:(NSSet *)values;
- (void)removeStatus:(NSSet *)values;

@end