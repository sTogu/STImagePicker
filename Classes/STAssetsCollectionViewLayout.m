//
//  STAssetsCollectionViewLayout.m
//  Demo
//
//  Created by sho on 2015/01/15.
//  Copyright (c) 2015年 sTogu. All rights reserved.
//

#import "STAssetsCollectionViewLayout.h"

@implementation STAssetsCollectionViewLayout

+ (instancetype)layout{
    return [[self alloc] init];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.minimumLineSpacing = 2.0;
        self.minimumInteritemSpacing = 2.0;
    }
    return self;
}


@end
