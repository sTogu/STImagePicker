//
//  STImagePickerCell.m
//  Demo
//
//  Created by sho on 2015/01/15.
//  Copyright (c) 2015年 sTogu. All rights reserved.
//

#import "STImagePickerCell.h"

@interface STImagePickerCell () {
    PHCachingImageManager *imageManager;
    UIImageView *cellImageView;
    UILabel *titleLabelCell;
}

@end

@implementation STImagePickerCell

static CGSize AssetThumbnailSize;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat scale = [UIScreen mainScreen].scale;
        CGFloat imageSize = ASIMAGEPICKER_CELL_HEIGHT-6;
        AssetThumbnailSize = CGSizeMake(imageSize * scale, imageSize * scale);
        
        imageManager = [[PHCachingImageManager alloc] init];
        cellImageView = [[UIImageView alloc] init];
        titleLabelCell = [[UILabel alloc] init];
        
        cellImageView.clipsToBounds = YES;
        cellImageView.contentMode = UIViewContentModeScaleAspectFill;
        cellImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.contentView addSubview:cellImageView];
        [self.contentView addSubview:titleLabelCell];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = ASIMAGEPICKER_CELL_HEIGHT;
    cellImageView.frame = CGRectMake(3, 3, height-6, height-6);
    titleLabelCell.frame = CGRectMake(height+3, 3, width-height, height-6);
}

- (void)updateCell:(PHAsset *)asset withTitle:(NSString *)title{
    titleLabelCell.text = title;
    [imageManager requestImageForAsset:asset
                            targetSize:AssetThumbnailSize
                           contentMode:PHImageContentModeAspectFill
                               options:nil
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             cellImageView.image = result;
                         }
     ];
}

@end
