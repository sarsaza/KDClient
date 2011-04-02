//
//  NSObject+BeeExtensions.m
//  KDClient
//
//  Created by Tair Sabirgaliev on 30.03.11.
//  Copyright 2011 BEE Software. All rights reserved.
//

#import "NSObject+BeeExtensions.h"
#import "KDClientAppDelegate.h"

@implementation NSObject (BeeExtensions)

-(KDClientAppDelegate *) app {
    return [UIApplication sharedApplication].delegate;
}

@end
