//
//  SelectOneController.h
//  KDClient
//
//  Created by Tair Sabirgaliev on 08.03.11.
//  Copyright 2011 BEE Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SelectOneController;

@protocol SelectOneDelegate <NSObject>
- (void)didCancel:(SelectOneController *)selectOneController;
- (void)didAccept:(SelectOneController *)selectOneController;
@end

@interface SelectOneController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	id<SelectOneDelegate> delegate;
	NSString *key;
	NSArray* rows;

	UITableView *selectionTable;
}

@property (nonatomic, assign) IBOutlet id<SelectOneDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableView *selectionTable;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign) NSArray *rows;

- (IBAction)didCancel:(id)sender;
- (IBAction)didAccept:(id)sender;

@end

