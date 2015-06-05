#import <UIKit/UIKit.h>
#import "Definitions.h"

@interface Feed : UIViewController <UIGestureRecognizerDelegate>

// Left and right container views (for left/right menus)
- (IBAction)menuButtonPressed:(id)sender;
- (IBAction)filterButtonPressed:(id)sender;

// Gesture recognizers
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *leftEdgePanRecognizer;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *rightEdgePanRecognizer;

// Constraints for the Menu and Filter drawers (for sliding in and out)
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterTrailingConstraint;

// Instance methods
- (void)swipeGestureLeft:(UIGestureRecognizer *)gesture;
- (void)swipeGestureRight:(UIGestureRecognizer *)gesture;

@end
