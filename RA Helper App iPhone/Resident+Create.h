//
//  Resident+Create.h
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/17/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import "Resident.h"

@interface Resident (Create)
+ (Resident *)residentWithFirstName:(NSString *)firstName  LastName:(NSString *)lastName Phone:(NSString *) phoneNumber ResidentID:(NSString *)residentID inManagedObjectContext:(NSManagedObjectContext *)context;
@end
