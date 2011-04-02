//
//  SelectOneCell.m
//  KDClient
//
//  Created by Tair Sabirgaliev on 18.03.11.
//  Copyright 2011 BEE Software. All rights reserved.
//

#import "SelectOneCell.h"
#import "SelectOneController.h"
#import "DetailViewController.h"
@interface SelectOneCell () <SelectOneDelegate>
- (void)startEdit;
- (void)endEdit;
@end

@implementation SelectOneCell

@synthesize detailViewController;

- (void)didCancel:(SelectOneController *)selectOneController {
    [self endEdit];
}

- (void)didAccept:(SelectOneController *)selectOneController {
    [self endEdit];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)startEdit {
    if ([self isEdit]) {
        return;
    }
    NSLog(@"SelectOneCell.startEdit");
    hasFocus = YES;
    SelectOneController *selectOneController = [[SelectOneController alloc] initWithNibName:@"SelectOneController" bundle:nil];
	selectOneController.key = @"driller";
	selectOneController.delegate = self;
//	selectOneController.rows = [detailViewController.mockData objectForKey:@"drillers"];
	selectOneController.modalPresentationStyle = UIModalPresentationFormSheet;
	selectOneController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	
	[self.detailViewController presentModalViewController:selectOneController animated:YES];
	[selectOneController release];
}

- (void)endEdit {
    if (![self isEdit]) {
        return;
    }
    [self.detailViewController dismissModalViewControllerAnimated:YES];
    hasFocus = NO;
}

- (BOOL)isEdit {
    return hasFocus;
}

- (void)dealloc
{
    [super dealloc];
}

@end
