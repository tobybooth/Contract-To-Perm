//
//  TOBContractView.m
//  Contract To Perm
//
//  Created by Toby Booth on 7/17/14.
//  Copyright (c) 2014 Toby Booth. All rights reserved.
//

#import "TOBContractView.h"

@implementation TOBContractView

- (id)initWithFrame:(CGRect)frame
//- (instancetype)initWithFrame:(CGRect)frame // modern ObjC
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
