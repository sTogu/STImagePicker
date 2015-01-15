//
//  STAssetsCollectionController.h
//  Demo
//
//  Created by sho on 2015/01/15.
//  Copyright (c) 2015年 sTogu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Photos/Photos.h>

#import "STImagePickerController.h"

@class STAssetsCollectionController;

@protocol STAssetsControllerDelegate <NSObject>


- (void)assetsController:(STAssetsCollectionController *)controller didSelectedAsset:(PHAsset *)asset;
- (void)assetsController:(STAssetsCollectionController *)controller didDeselectedAsset:(PHAsset *)asset;
- (void)assetsController:(STAssetsCollectionController *)controller didFinishPickingAssets:(NSMutableArray *)assets;


@end
@interface STAssetsCollectionController : UICollectionViewController


@property (nonatomic, weak) id<STAssetsControllerDelegate>stDelegate;

@property (nonatomic, weak) STImagePickerController *imagePicker;

@property (nonatomic, strong) PHAssetCollection *assetCollection;
@property (nonatomic, strong) PHFetchResult *assetsFetchResults;

- (void)selectedAssets:(NSMutableArray *)selectedAssets;


@end
