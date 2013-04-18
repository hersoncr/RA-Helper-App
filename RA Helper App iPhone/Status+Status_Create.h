//
//  Status+Status_Create.h
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/17/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import "Status.h"

@interface Status (Status_Create)
+ (Status *)statusWithName:(NSString *)name
                inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSArray *) getAllStatusesWithContext:(NSManagedObjectContext *) context;
@end
