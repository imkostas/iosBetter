#import <UIKit/UIKit.h>

@interface MainVController : UIViewController <UIGestureRecognizerDelegate>

// Main scroll view
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

// Left and right container views (for left/right menus)

// Gesture recognizers
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *leftEdgePanRecognizer;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *rightEdgePanRecognizer;

// Instance methods
- (void)swipeGestureLeft:(UIGestureRecognizer *)gesture;
- (void)swipeGestureRight:(UIGestureRecognizer *)gesture;

@end
