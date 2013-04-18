//
//  Status.h
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/15/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CurfewCheck;

@interface Status : NSManagedObject

@property (nonatomic, retain) NSString * statusName;
@property (nonatomic, retain) NSSet *curfewChecks;
@end

@interface Status (CoreDataGeneratedAccessors)

- (void)addCurfewChecksObject:(CurfewCheck *)value;
- (void)removeCurfewChecksObject:(CurfewCheck *)value;
- (void)addCurfewChecks:(NSSet *)values;
- (void)removeCurfewChecks:(NSSet *)values;

@end
