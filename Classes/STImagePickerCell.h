//
//  STImagePickerCell.h
//  Demo
//
//  Created by sho on 2015/01/15.
//  Copyright (c) 2015年 sTogu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Photos/Photos.h>

#define ASIMAGEPICKER_CELL_HEIGHT 50

@interface STImagePickerCell : UITableViewCell

- (void)updateCell:(PHAsset *)asset withTitle:(NSString *)title;

@end
