//
//  CurfewCheck.h
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/19/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Resident, Status;

@interface CurfewCheck : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Resident *residentId;
@property (nonatomic, retain) Status *status;

@end
