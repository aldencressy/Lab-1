//
//  WatchedMoviesMarker.m
//  Lab 1
//
//  Created by William Epperly on 9/22/24.
//

#import "WatchedMoviesMarker.h"

@implementation WatchedMoviesMarker

- (instancetype)initWithLabel:(UILabel *)label {
    self = [super init];
    if (self) {
        self.hasBeenWatched = label;
    }
    return self;
}

- (void)startBlinking {
    self.blinker = [NSTimer scheduledTimerWithTimeInterval:1.0
                    target:self
                    selector:@selector(toggleIndicatorVisibility)
                    userInfo:nil
                    repeats:YES];
}

- (void)stopBlinking {
    [self.blinker invalidate];
    self.hasBeenWatched.hidden = NO;
}

- (void)toggleIndicatorVisibility {
    self.hasBeenWatched.hidden = !self.hasBeenWatched.hidden;
}

@end
