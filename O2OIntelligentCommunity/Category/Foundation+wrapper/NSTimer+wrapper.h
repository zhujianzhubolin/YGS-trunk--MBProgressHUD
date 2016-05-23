#import <Foundation/Foundation.h>

@interface NSTimer (wrapper)

- (void)pauseTimer;

- (void)resumeTimer;

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
