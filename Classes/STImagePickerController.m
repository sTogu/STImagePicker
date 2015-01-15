//
//  STImagePickerController.m
//  Demo
//
//  Created by sho on 2015/01/15.
//  Copyright (c) 2015年 sTogu. All rights reserved.
//

#import "STImagePickerController.h"

#import "STImagePickerCell.h"

#import "STAssetsCollectionController.h"
#import "STAssetsCollectionViewLayout.h"

#import <Photos/Photos.h>

@interface STImagePickerController ()
<STAssetsControllerDelegate>
{
    STAssetsCollectionController *assetCollectionController;
    PHFetchResult *assetsFetchResults;
    NSArray *collectionsFetchResults;
}


@end

@implementation STImagePickerController


////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark View Lifecycle
////////////////////////////////////////////////////////////////////////////


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    [self setView];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationItem.rightBarButtonItem.enabled = self.selectedAssets.count;
}

- (void)setView{
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
}

- (void)createNavigationItems {
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                          target:self
                                                                          action:@selector(leftBarButtonItemAction:)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                           target:self
                                                                           action:@selector(rightBarButtonItemAction:)];
    self.navigationItem.rightBarButtonItem = right;
}


////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Initialize
////////////////////////////////////////////////////////////////////////////


- (void)initialize {
    self.selectedAssets = @[].mutableCopy;
    
    PHFetchResult *favoriteAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                             subtype:PHAssetCollectionSubtypeSmartAlbumFavorites
                                                                             options:nil];
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    collectionsFetchResults = @[favoriteAlbums,topLevelUserCollections];
}


////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Actions
////////////////////////////////////////////////////////////////////////////


- (void)leftBarButtonItemAction:(UIBarButtonItem *)sender {
    [self.delegate imagePickerControllerDidCancel:self];
}

- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender {
    [self assetsController:assetCollectionController didFinishPickingAssets:self.selectedAssets];
}

- (void)assetsController:(STAssetsCollectionController *)controller didSelectedAsset:(PHAsset *)asset {
    if ([self.selectedAssets indexOfObject:asset] == NSNotFound) {
        [self.selectedAssets addObject:asset];
    }
}

- (void)assetsController:(STAssetsCollectionController *)controller didDeselectedAsset:(PHAsset *)asset {
    if ([self.selectedAssets indexOfObject:asset] != NSNotFound) {
        [self.selectedAssets removeObject:asset];
    }
}

- (void)assetsController:(STAssetsCollectionController *)controller didFinishPickingAssets:(NSMutableArray *)assets {
    if (self.delegate) {
        [self.delegate imagePickerController:self didFinishPickingAssets:self.selectedAssets];
    }
}


//////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITableView Datasource
//////////////////////////////////////////////////////////////////////////////


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 + collectionsFetchResults.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger numberOfRows = 0;
    if (section == 0) {
        numberOfRows = 1; // "All Photos" section
    } else {
        PHFetchResult *fetchResult = collectionsFetchResults[section - 1];
        numberOfRows = fetchResult.count;
    }
    return numberOfRows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title = @"from Device";
    if (section == 0) {
        title = @"全ての写真";
    } else if (section == 1) {
        title = @"スマートアルバム";
    } else {
        title = @"アルバム";
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = nil;
    STImagePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STImagePickerCell"];
    
    if (cell == nil) {
        cell = [[STImagePickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STImagePickerCell"];
    }
    
    if (indexPath.section == 0) {
        title = NSLocalizedString(@"CAMERA_ROLL", nil);
        [cell updateCell:[self assetForCameraRoll] withTitle:title];
    } else {
        PHFetchResult *fetchResult = collectionsFetchResults[indexPath.section - 1];
        PHCollection *collection = fetchResult[indexPath.row];
        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        title = collection.localizedTitle;
        [cell updateCell:assetsFetchResult.lastObject withTitle:title];
    }
    
    return cell;
}

- (PHAsset *)assetForCameraRoll{
    PHFetchOptions *options = [PHFetchOptions new];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *rsult = [PHAsset fetchAssetsWithOptions:options];
    PHAsset *asset = rsult.lastObject;
    return asset;
}


////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITableView Delegate
////////////////////////////////////////////////////////////////


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    assetCollectionController = [[STAssetsCollectionController alloc] initWithCollectionViewLayout:[STAssetsCollectionViewLayout layout]];
    assetCollectionController.imagePicker = self;
    assetCollectionController.stDelegate = self;
    
    if (indexPath.section == 0) {
        [self allPhotos];
    }else{
        [self albumAssets:indexPath];
    }
    [self.navigationController pushViewController:assetCollectionController animated:YES];
}

- (void)allPhotos{
    PHFetchOptions *options = [PHFetchOptions new];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    assetCollectionController.assetsFetchResults = assetsFetchResults;
}

- (void)albumAssets:(NSIndexPath *)indexPath{
    PHFetchResult *fetchResult = collectionsFetchResults[indexPath.section - 1];
    PHCollection *collection = fetchResult[indexPath.row];
    if ([collection isKindOfClass:[PHAssetCollection class]]) {
        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        assetCollectionController.assetsFetchResults = assetsFetchResult;
        assetCollectionController.assetCollection = assetCollection;
    }
}


@end
