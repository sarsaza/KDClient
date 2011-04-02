//
//  BoxViewController.h
//  KDClient
//
//  Created by Tair Sabirgaliev on 30.01.11.
//  Copyright 2011 BEE Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class RootViewController;

@interface BoxViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSUInteger status;
	RootViewController *rootViewController;

    NSFetchedResultsController *fetchedResultsController;

    UIBarButtonItem *sendButton;
    UIBarButtonItem *addButton;

}

@property(readonly) NSUInteger status;
@property(readonly) NSString *statusString;
@property(nonatomic, assign) RootViewController *rootViewController;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property(nonatomic, retain) IBOutlet UIBarButtonItem *sendButton;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *addButton;

- (id)initWithStatus:(NSUInteger)aStatus;

- (IBAction)sendOutboxReports:(id)sender;
- (IBAction)insertNewObject:(id)sender;

@end
