//
//  BeeExtensions.h
//  KDClient
//
//  Created by Tair Sabirgaliev on 31.03.11.
//  Copyright 2011 BEE Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NSManagedObject (BeeExtensions)
- (NSDictionary *)propertiesDictionary;
@end
