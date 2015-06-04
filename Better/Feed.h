#import <UIKit/UIKit.h>
#import "Definitions.h"

@interface Feed : UIViewController <UIGestureRecognizerDelegate>

// Left and right container views (for left/right menus)

// Gesture recognizers
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *leftEdgePanRecognizer;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *rightEdgePanRecognizer;

// Instance methods
- (void)swipeGestureLeft:(UIGestureRecognizer *)gesture;
- (void)swipeGestureRight:(UIGestureRecognizer *)gesture;

@end
