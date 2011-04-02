//
//  BeeExtensions.m
//  KDClient
//
//  Created by Tair Sabirgaliev on 31.03.11.
//  Copyright 2011 BEE Software. All rights reserved.
//

#import "NSManagedObject+BeeExtensions.h"


@implementation NSManagedObject (BeeExtensions)

- (NSDictionary *)propertiesDictionary
{
    NSMutableDictionary *properties = [[[NSMutableDictionary alloc] init] autorelease];
    
    for (id property in [[self entity] properties])
    {
        if ([property isKindOfClass:[NSAttributeDescription class]])
        {
            NSAttributeDescription *attributeDescription = (NSAttributeDescription *)property;
            NSString *name = [attributeDescription name];
            [properties setValue:[[self valueForKey:name] description] forKey:name];
        }
        
        if ([property isKindOfClass:[NSRelationshipDescription class]])
        {
            NSRelationshipDescription *relationshipDescription = (NSRelationshipDescription *)property;
            NSString *name = [relationshipDescription name];
            
            if ([relationshipDescription isToMany])
            {
                NSMutableArray *arr = [properties valueForKey:name];
                if (!arr)
                {
                    arr = [[[NSMutableArray alloc] init] autorelease];
                    [properties setValue:arr forKey:name];
                }
                
                for (NSManagedObject *o in [self mutableSetValueForKey:name])
                    [arr addObject:[o propertiesDictionary]];
            }
            else
            {
                NSManagedObject *o = [self valueForKey:name];
                [properties setValue:[o propertiesDictionary] forKey:name];
            }
        }
    }
    
    return properties;
}  

@end
