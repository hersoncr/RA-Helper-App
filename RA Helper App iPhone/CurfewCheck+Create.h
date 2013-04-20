//
//  CurfewCheck+Create.h
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/19/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import "CurfewCheck.h"
#import "Room+Create.h"
#import "Resident+Create.h"
@interface CurfewCheck (Create)
+ (CurfewCheck *) curfewCheckResident:(Resident *) resident andAtDate:(NSDate *)date withStatus:(Status *)status onContext:(NSManagedObjectContext *) context;

+ (NSArray *) getAllCurfewChecksWithContext:(NSManagedObjectContext *)context;
@end
