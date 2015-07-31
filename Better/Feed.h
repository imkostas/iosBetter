#import <UIKit/UIKit.h>
#import "Definitions.h"
#import "Menu.h"
#import "Filter.h"
#import "FeedTableViewController.h"

@interface Feed : UIViewController <UIGestureRecognizerDelegate, FilterDelegate, UINavigationBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

// Left and right container views (for left/right menus)
- (IBAction)menuButtonPressed:(id)sender;
- (IBAction)filterButtonPressed:(id)sender;

// Constraints for the Menu and Filter drawers (for sliding in and out)
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterWidthConstraint;

// The transparent black view that appears behind the drawers
// when they are brought out
@property (weak, nonatomic) IBOutlet UIView *transparencyView;

// The center view which slides left and right, inside of which is the Feed
@property (weak, nonatomic) IBOutlet UIView *centerView;
// The UIView container for a FeedTableViewController (we use this to enable and disable interaction with
// the feed, when necessary -- e.g. opening the Menu or Filter drawers)
@property (weak, nonatomic) IBOutlet UIView *feedContainer;

// The constraint that determines the offset of `centerView` from the left of the screen
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerViewLeadingConstraint;

// Outlets to the two container views that hold the drawers
@property (weak, nonatomic) IBOutlet UIView *menuDrawer;
@property (weak, nonatomic) IBOutlet UIView *filterDrawer;

// Outlet to the UINavigationBar (not controlled by a UINavigationController)
// and its UINavigationItem
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBarCustom;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItemCustom;

// Outlets to the two UIBarButtonItems
// *strong* because we set [[self navigationItem] leftBarButtonItem] to nil in the code to hide the buttons
// but we don't want to actually trash the buttons
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *filterBarButtonItem;

// Outlet to the "take picture" / create post Android-style button
@property (weak, nonatomic) IBOutlet UIButton *createPostButton;

// Instance methods
- (void)swipeFromLeftEdge:(UIGestureRecognizer *)gesture;
- (void)swipeFromRightEdge:(UIGestureRecognizer *)gesture;

//- (void)swipeOnMenuDrawer:(UIPanGestureRecognizer *)gesture;
//- (void)swipeOnFilterDrawer:(UIPanGestureRecognizer *)gesture;

@end
