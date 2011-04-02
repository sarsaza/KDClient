//
//  EditingTableViewCell.m
//  KDClient
//
//  Created by Tair Sabirgaliev on 12.03.11.
//  Copyright 2011 BEE Software. All rights reserved.
//

#import "EditingCell.h"
#import "DetailViewController.h"
#import "RootViewController.h"


@implementation EditingCell

@synthesize textField, detailViewController;

- (void)useField:(NSString *)aField ofManagedObject:(NSManagedObject *)aManagedObject {
	if (managedObject != aManagedObject) {
        [field release];
        field = [aField copy];
		[managedObject release];
        managedObject = [aManagedObject retain];
        textField.text = [managedObject valueForKey:field];
	}
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier])) {
		textField = [[UITextField alloc] initWithFrame: CGRectZero];
        textField.borderStyle = UITextBorderStyleNone;
        textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        textField.userInteractionEnabled = NO;
        textField.textAlignment = UITextAlignmentRight;
        textField.textColor = self.detailTextLabel.textColor;
        textField.delegate = self;
        [self.contentView addSubview:textField];
        [self setNeedsLayout];
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect labelFrame = self.textLabel.frame;
	labelFrame = CGRectMake(10, 11, labelFrame.size.width, labelFrame.size.height);
	self.textLabel.frame = labelFrame;
	self.textField.frame = CGRectMake(labelFrame.size.width + 20, 13, self.contentView.frame.size.width - labelFrame.size.width - 31, 21);
	[self.detailTextLabel removeFromSuperview];
}

#pragma -
#pragma TextField delegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)aTextField {
    [managedObject setValue:textField.text forKey:field];
    NSError *error = nil;
    BOOL success = [managedObject.managedObjectContext save:&error];
    if (!success) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return success;
}

- (void)dealloc {
	[textField release];
	[field release];
    [managedObject release];
    [super dealloc];
}

- (void)startEdit {
    if ([textField isFirstResponder]) {
        NSLog(@"already editing");
        return;
    }
    textField.userInteractionEnabled = YES;
    [textField becomeFirstResponder];
}

- (void)endEdit {
    if (![self isEdit]) {
        return;
    }
    [textField resignFirstResponder];
    textField.userInteractionEnabled = NO;
}

- (BOOL)isEdit {
    return [textField isFirstResponder];
}

@end
