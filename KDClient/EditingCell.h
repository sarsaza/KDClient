//
//  EditingTableViewCell.h
//  KDClient
//
//  Created by Tair Sabirgaliev on 12.03.11.
//  Copyright 2011 BEE Software. All rights reserved.
//

#import "UITableViewCell+BeeExtensions.h"
#import <CoreData/CoreData.h>

@class DetailViewController;

@interface EditingCell : UITableViewCell <UITextFieldDelegate> {
    DetailViewController *detailViewController;
    UITextField *textField;
    NSString *field;
    NSManagedObject *managedObject;
}

@property(nonatomic, readonly) UITextField *textField;
@property(nonatomic, assign) DetailViewController *detailViewController;

- (void)useField:(NSString *)aField ofManagedObject:(NSManagedObject *)aManagedObject;

@end
