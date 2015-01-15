//
//  STAssetsCollectionController.m
//  Demo
//
//  Created by sho on 2015/01/15.
//  Copyright (c) 2015年 sTogu. All rights reserved.
//

#import "STAssetsCollectionController.h"

#import "STThumbnailCell.h"

#define TOOLBAR_HEIGHT 44

@interface STAssetsCollectionController ()
{
    UIToolbar *toolBar;
    UIButton *barButton;
    NSMutableArray *collectionData;
}

@end

@implementation STAssetsCollectionController

static NSString * const kPHThumnailCellId  = @"kSTThumnailCellId";

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithCollectionViewLayout:layout]) {
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView registerClass:[STThumbnailCell class]
                forCellWithReuseIdentifier:kPHThumnailCellId];
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, TOOLBAR_HEIGHT, 0);
        self.collectionView.allowsMultipleSelection = YES;
    }
    return self;
}

- (void)reloadCollectionData:(NSInteger)index {
    if (index == 0) {
        [self sortCollectionData:PHAssetMediaTypeUnknown];
    } else if (index == 1) {
        [self sortCollectionData:PHAssetMediaTypeImage];
    } else {
        [self sortCollectionData:PHAssetMediaTypeVideo];
    }
    [self.collectionView reloadData];
    [self selectedAssets:self.imagePicker.selectedAssets];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationItem];
    [self setView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateButtonTitle];
    [self reloadCollectionData:0];
}

- (void)createNavigationItem {
    NSArray *items = @[@"ALL", @"ONLY_PHOTO", @"ONLY_VIDEO"];
    
    UISegmentedControl *segmentedContl = [[UISegmentedControl alloc] initWithItems:items];
    segmentedContl.selectedSegmentIndex = 0;
    [segmentedContl addTarget:self action:@selector(didChangeSegment:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:segmentedContl];
    
    self.navigationItem.rightBarButtonItem = right;
}

- (void)setView {
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat y = [[UIScreen mainScreen] bounds].size.height-TOOLBAR_HEIGHT;
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, y, width, TOOLBAR_HEIGHT)];
    
    barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    barButton.frame = toolBar.bounds;
    [barButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [barButton addTarget:self action:@selector(didFinishPickingAssets) forControlEvents:UIControlEventTouchUpInside];
    
    [toolBar addSubview:barButton];
    [self.view addSubview:toolBar];
}

- (void)updateButtonTitle {
    NSString *btnTitle = [NSString stringWithFormat:@"Import %ld photos",(long)self.imagePicker.selectedAssets.count];
    [barButton setTitle:btnTitle forState:UIControlStateNormal];
    
    if (self.imagePicker.selectedAssets.count == 0) {
        toolBar.alpha = 0.5;
    } else {
        toolBar.alpha = 1.0;
    }
}


//////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Actions
//////////////////////////////////////////////////////////////////////////////


- (void)didFinishPickingAssets {
    if (toolBar.alpha == 1.0) {
        [self.stDelegate assetsController:self didFinishPickingAssets:self.imagePicker.selectedAssets];
    }
}

- (void)selectedAssets:(NSMutableArray *)selectedAssets {
    for (PHAsset *selectedAsset in selectedAssets) {
        for (NSInteger i = 0; i < collectionData.count; i++) {
            PHAsset *asset = collectionData[i];
            if ([selectedAsset isEqual:asset]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.collectionView selectItemAtIndexPath:indexPath animated:NO
                                            scrollPosition:UICollectionViewScrollPositionNone];
                break;
            }
        }
    }
}

- (void)didChangeSegment:(UISegmentedControl *)seg {
    NSInteger index = seg.selectedSegmentIndex;
    [self reloadCollectionData:index];
}

- (void)sortCollectionData:(PHAssetMediaType)mediaType {
    collectionData = @[].mutableCopy;
    if (mediaType == PHAssetMediaTypeUnknown) {
        for (PHAsset *asset in self.assetsFetchResults) {
            [collectionData addObject:asset];
        }
        return;
    }
    for (PHAsset *asset in self.assetsFetchResults) {
        if (asset.mediaType == mediaType) {
            [collectionData addObject:asset];
        }
    }
}


//////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UICollectionView Delegate
//////////////////////////////////////////////////////////////////////////////


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *asset = collectionData[indexPath.item];
    
    if (self.stDelegate) {
        [self.stDelegate assetsController:self didSelectedAsset:asset];
        [self updateButtonTitle];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *asset = collectionData[indexPath.item];
    
    if (self.stDelegate) {
        [self.stDelegate assetsController:self didSelectedAsset:asset];
        [self updateButtonTitle];
    }
}


//////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UICollectionView Datasource
//////////////////////////////////////////////////////////////////////////////


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [STThumbnailCell thumbnailRect].size;
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets insets = UIEdgeInsetsMake(2, 2, 2, 2);
    return insets;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return collectionData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    STThumbnailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPHThumnailCellId
                                                                      forIndexPath:indexPath];
    [cell updateThumbnailCell:collectionData[indexPath.item]];
    return cell;
}


@end