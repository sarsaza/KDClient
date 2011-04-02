//
//  UITableViewCell+BeeExtensions.m
//  KDClient
//
//  Created by Tair Sabirgaliev on 23.03.11.
//  Copyright 2011 BEE Software. All rights reserved.
//

#import "UITableViewCell+BeeExtensions.h"


@implementation UITableViewCell (BeeExtensions) 

- (void)startEdit {
    NSLog(@"UITableViewCell.startEdit");
}

- (BOOL)isEdit {
    NSLog(@"UITableViewCell.isEdit");
    return self.selected;
}

- (void)endEdit {
    NSLog(@"UITableViewCell.endEdit");
}

@end

