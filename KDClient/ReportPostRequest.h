//
//  ReportPostRequest.h
//  KDClient
//
//  Created by Tair Sabirgaliev on 30.03.11.
//  Copyright 2011 BEE Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ASIHTTPRequest.h"

@interface ReportPostRequest : ASIHTTPRequest {
@private
    NSManagedObject *_report;
}

@property(nonatomic, readonly) NSManagedObject *report;

- (id)initWithURL:(NSURL *)newURL andReport:(NSManagedObject *)report;
@end
