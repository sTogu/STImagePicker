//
//  STThumbnailCell.m
//  Demo
//
//  Created by sho on 2015/01/15.
//  Copyright (c) 2015年 sTogu. All rights reserved.
//

#import "STThumbnailCell.h"

#import "STAssetsCollectionOverlayView.h"
#import "STAssetsCollectionVideoView.h"

@interface STThumbnailCell () {
    STAssetsCollectionOverlayView *overlayView;
    STAssetsCollectionVideoView *videoView;
    PHAsset *asset;
    PHCachingImageManager *imageManager;
    UIImageView *thumbnail;
}

@end

@implementation STThumbnailCell

static CGSize AssetGridThumbnailSize;

+ (CGRect)thumbnailRect{
    CGRect rect = CGRectMake(0, 0, 77.5, 77.5);
    return rect;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize cellSize = [STThumbnailCell thumbnailRect].size;
        AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
        
        imageManager = [[PHCachingImageManager alloc] init];
        
        thumbnail = [[UIImageView alloc] init];
        thumbnail.clipsToBounds = YES;
        thumbnail.contentMode = UIViewContentModeScaleAspectFill;
        thumbnail.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:thumbnail];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    thumbnail.frame = [STThumbnailCell thumbnailRect];
}

- (void)updateThumbnailCell:(PHAsset *)phAsset{
    asset = phAsset;
    
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        [self showVideoView];
    } else {
        [self hideVideoView];
    }
    
    [imageManager requestImageForAsset:asset
                                 targetSize:AssetGridThumbnailSize
                                contentMode:PHImageContentModeAspectFill
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  thumbnail.image = result;
                              }
     ];
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    if (selected) {
        [self showCoverView];
    } else {
        [self hideCoverView];
    }
}


///////////////////////////////////////////////////////////
#pragma mark -
#pragma mark OverlayView
///////////////////////////////////////////////////////////


- (void)showCoverView{
    [self hideCoverView];
    
    overlayView = [[STAssetsCollectionOverlayView alloc] initWithFrame:self.contentView.bounds];
    overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:overlayView];
}

- (void)hideCoverView{
    if (overlayView) {
        [overlayView removeFromSuperview];
        overlayView = nil;
    }
}


///////////////////////////////////////////////////////////
#pragma mark -
#pragma mark VideoView
///////////////////////////////////////////////////////////


- (void)showVideoView{
    CGFloat height = 19.0;
    CGRect frame = CGRectMake(0, CGRectGetHeight(self.bounds) - height, CGRectGetWidth(self.bounds), height);
    
    videoView = [[STAssetsCollectionVideoView alloc] initWithFrame:frame];
    videoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    videoView.duration = asset.duration;
    
    [self.contentView addSubview:videoView];
}

- (void)hideVideoView{
    if (videoView) {
        [videoView removeFromSuperview];
        videoView = nil;
    }
}


@end