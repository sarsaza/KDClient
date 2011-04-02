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

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> {

}


@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) NSManagedObject *detailItem;

@property (nonatomic, assign) IBOutlet RootViewController *rootViewController;

@property (nonatomic, retain) IBOutlet UIBarItem *outboxBarItem;
@property (nonatomic, retain) IBOutlet UIBarItem *draftsBarItem;
@property (nonatomic, retain) IBOutlet UIBarItem *trashBarItem;

@property (nonatomic, retain) IBOutlet DetailTableViewController *tableViewController;

- (IBAction)moveToDrafts:(id)sender;
- (IBAction)moveToOutbox:(id)sender;
- (IBAction)moveToTrash:(id)sender;

@end
