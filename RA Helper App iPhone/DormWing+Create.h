//
//  DormWing+Create.h
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/18/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import "DormWing.h"

@interface DormWing (Create)
+ (DormWing *) dormWingWithName:(NSString *)dormWingName inContext:(NSManagedObjectContext *) context;

+ (NSArray *) getAllDormWingsWithContext:(NSManagedObjectContext *) context;

@end
