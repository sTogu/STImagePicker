//
//  STImagePickerController.h
//  Demo
//
//  Created by sho on 2015/01/15.
//  Copyright (c) 2015年 sTogu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STImagePickerController;

@protocol STImagePickerControllerDelegate <NSObject>


- (void)imagePickerController:(STImagePickerController *)picker didFinishPickingAssets:(NSMutableArray *)assets;
- (void)imagePickerControllerDidCancel:(STImagePickerController *)picker;


@end
@interface STImagePickerController : UITableViewController


@property (nonatomic, weak) id<STImagePickerControllerDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *selectedAssets;


@end
