//
//  UITableViewCell+BeeExtensions.h
//  KDClient
//
//  Created by Tair Sabirgaliev on 23.03.11.
//  Copyright 2011 BEE Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (BeeExtensions) 
- (void)startEdit;
- (BOOL)isEdit;
- (void)endEdit;

@end
