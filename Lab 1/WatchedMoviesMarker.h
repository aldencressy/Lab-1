//
//  WatchedMoviesMarker.h
//  Lab 1
//
//  Created by William Epperly on 9/22/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WatchedMoviesMarker : NSObject

@property (nonatomic, strong) NSTimer *blinker;
@property (nonatomic, strong) UILabel *hasBeenWatched;

- (instancetype)initWithLabel:(UILabel *)label;
- (void)startBlinking;
- (void)stopBlinking;

@end

NS_ASSUME_NONNULL_END
