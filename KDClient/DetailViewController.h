//
//  DetailViewController.h
//  KDClient
//
//  Created by Tair Sabirgaliev on 02.04.11.
//  Copyright 2011 BEE Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@class RootViewController;
@class DetailTableViewController;

@interface DetailViewController : UITableViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> {

}


@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) NSManagedObject *detailItem;

@property (nonatomic, assign) IBOutlet RootViewController *rootViewController;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *outboxBarItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *draftsBarItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *trashBarItem;

@property (nonatomic, retain) IBOutlet DetailTableViewController *tableViewController;

- (IBAction)moveToDrafts:(id)sender;
- (IBAction)moveToOutbox:(id)sender;
- (IBAction)moveToTrash:(id)sender;

@end
