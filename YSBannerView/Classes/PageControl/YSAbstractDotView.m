//
//  YSAbstractDotView.m
//  YSBannerView_Example
//
//  Created by Kyson on 2019/3/7.
//  Copyright © 2019 kysonyangs. All rights reserved.
//

#import "YSAbstractDotView.h"

@implementation YSAbstractDotView

- (id)init{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in %@", NSStringFromSelector(_cmd), self.class]
                                 userInfo:nil];
}


- (void)changeActivityState:(BOOL)active{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in %@", NSStringFromSelector(_cmd), self.class]
                                 userInfo:nil];
}

@end
