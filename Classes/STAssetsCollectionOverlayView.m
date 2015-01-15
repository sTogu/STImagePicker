//
//  STAssetsCollectionOverlayView.m
//  Demo
//
//  Created by sho on 2015/01/15.
//  Copyright (c) 2015年 sTogu. All rights reserved.
//

#import "STAssetsCollectionOverlayView.h"

#import "STAssetsCollectionCheckmarkView.h"

#import <QuartzCore/QuartzCore.h>

@interface STAssetsCollectionOverlayView ()

@property (nonatomic, strong) STAssetsCollectionCheckmarkView *checkmarkView;

@end

@implementation STAssetsCollectionOverlayView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
        
        STAssetsCollectionCheckmarkView *checkmarkView = [[STAssetsCollectionCheckmarkView alloc] initWithFrame:CGRectMake(self.bounds.size.width - (4.0 + 24.0), self.bounds.size.height - (4.0 + 24.0), 24.0, 24.0)];
        checkmarkView.autoresizingMask = UIViewAutoresizingNone;
        
        checkmarkView.layer.shadowColor = [[UIColor grayColor] CGColor];
        checkmarkView.layer.shadowOffset = CGSizeMake(0, 0);
        checkmarkView.layer.shadowOpacity = 0.6;
        checkmarkView.layer.shadowRadius = 2.0;
        
        [self addSubview:checkmarkView];
        self.checkmarkView = checkmarkView;
    }
    return self;
}

@end
