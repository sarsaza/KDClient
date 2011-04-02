//
//  SelectOneCell.h
//  KDClient
//
//  Created by Tair Sabirgaliev on 18.03.11.
//  Copyright 2011 BEE Software. All rights reserved.
//

#import "UITableViewCell+BeeExtensions.h"

@interface SelectOneCell : UITableViewCell {
    UIViewController *detailViewController;
    BOOL hasFocus;
}

@property(nonatomic, assign) UIViewController *detailViewController;

@end
