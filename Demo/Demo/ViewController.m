//
//  ViewController.m
//  Demo
//
//  Created by sho on 2015/01/15.
//  Copyright (c) 2015年 sTogu. All rights reserved.
//

#import "ViewController.h"

#import "STImagePickerController.h"

@interface ViewController ()
<STImagePickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)showImagePickerController:(id)sender {
    STImagePickerController *imagePickerController = [[STImagePickerController alloc] initWithStyle:UITableViewStylePlain];
    imagePickerController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)imagePickerController:(STImagePickerController *)picker didFinishPickingAssets:(NSMutableArray *)assets {
    NSLog(@"%@", assets);
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(STImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
