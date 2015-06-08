#import <UIKit/UIKit.h>
#import "Definitions.h"
#import "Menu.h"
#import "Filter.h"

@interface Feed : UIViewController <UIGestureRecognizerDelegate, FilterDelegate>

// Left and right container views (for left/right menus)
- (IBAction)menuButtonPressed:(id)sender;
- (IBAction)filterButtonPressed:(id)sender;

// Gesture recognizers
@property (strong, nonatomic) UIScreenEdgePanGestureRecognizer *leftEdgePanRecognizer;
@property (strong, nonatomic) UIScreenEdgePanGestureRecognizer *rightEdgePanRecognizer;
@property (strong, nonatomic) UIPanGestureRecognizer *panMenuDrawerGesture;
@property (strong, nonatomic) UIPanGestureRecognizer *panFilterDrawerGesture;

// Constraints for the Menu and Filter drawers (for sliding in and out)
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterTrailingConstraint;

// The transparent black view that appears behind the drawers
// when they are brought out
@property (weak, nonatomic) IBOutlet UIView *transparencyView;

// Outlets to the two container views that hold the drawers
@property (weak, nonatomic) IBOutlet UIView *menuDrawer;
@property (weak, nonatomic) IBOutlet UIView *filterDrawer;

// Outlets to the two UIBarButtonItems
// *strong* because we set [[self navigationItem] leftBarButtonItem] to nil in the code to hide the buttons
// but we don't want to actually trash the buttons
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *filterBarButtonItem;

// Instance methods
- (void)swipeFromLeftEdge:(UIGestureRecognizer *)gesture;
- (void)swipeFromRightEdge:(UIGestureRecognizer *)gesture;

- (void)swipeOnMenuDrawer:(UIPanGestureRecognizer *)gesture;
- (void)swipeOnFilterDrawer:(UIPanGestureRecognizer *)gesture;

@end
