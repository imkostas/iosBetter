#import <UIKit/UIKit.h>
#import "Definitions.h"
#import "Menu.h"
#import "Filter.h"

@interface Feed : UIViewController <UIGestureRecognizerDelegate, FilterDelegate>

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
- (void)swipeFromLeftEdge:(UIGestureRecognizer *)gesture;
- (void)swipeFromRightEdge:(UIGestureRecognizer *)gesture;

@end
