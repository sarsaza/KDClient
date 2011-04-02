//
//  ReportPostRequest.m
//  KDClient
//
//  Created by Tair Sabirgaliev on 30.03.11.
//  Copyright 2011 BEE Software. All rights reserved.
//

#import "ReportPostRequest.h"
#import "NSManagedObject+BeeExtensions.h"
#import "JSONKit.h"


@implementation ReportPostRequest

@synthesize report = _report;

- (id)initWithURL:(NSURL *)newURL andReport:(NSManagedObject *)report {
    self = [super initWithURL:newURL];
    if (self) {
        _report = [report retain];
        [self addRequestHeader:@"Content-Type" value:@"application/json; charset=utf-8"];
        [self appendPostData:[[_report propertiesDictionary] JSONData]]; 
    }
    return self;
}

- (void)dealloc {
    [_report release];
    [super dealloc];
}

@end
