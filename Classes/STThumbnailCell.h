//
//  STThumbnailCell.h
//  Demo
//
//  Created by sho on 2015/01/15.
//  Copyright (c) 2015年 sTogu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Photos/Photos.h>

@interface STThumbnailCell : UICollectionViewCell

+ (CGRect)thumbnailRect;
- (void)updateThumbnailCell:(PHAsset *)asset;

@end
