//
//  PostLayoutViewController.m
//  Better
//
//  Created by Peter on 7/8/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "PostLayoutViewController.h"
#import <AFNetworking/AFNetworking.h>

#define MAX_ZOOM 2

// A way to tell a method which image you'd like it to work on
typedef enum {
    PostLayoutImageA,
    PostLayoutImageB
} PostLayoutImage;

// A pair of UIScrollView zoom scales to store min and max
typedef struct MinMaxZoomPair {
    CGFloat minZoomScale;
    CGFloat maxZoomScale;
} MinMaxZoomPair;

@interface PostLayoutViewController ()
{
    /**
     An integer that keeps track of the state of the image layout--there are three states:
     (0) image A is fully shown, image B is hidden
     (1) image A is on the left, image B is on the right
     (2) image A is on the top, image B is on the bottom
     */
    enum { LAYOUTSTATE_A_ONLY, LAYOUTSTATE_LEFT_RIGHT, LAYOUTSTATE_TOP_BOTTOM };
    int layoutState;
    
    // An integer that keeps track of which image we are currently picking:
    // (0) choosing image A
    // (1) choosing image B
    enum { TARGETIMAGE_A, TARGETIMAGE_B };
    int targetImageState;
    
    // An integer that keeps track of the state of the posting process for this view controller--it has 2 states:
    // (0) Taking pictures and setting their layout and zoom levels
    // (1) Placing the spotlights and setting their labels
    enum { POSTINGSTATE_PICTURES, POSTINGSTATE_SPOTLIGHTS };
    int postState;
    
    // Boolean to remember if we have already shown the image picker once automatically
    BOOL alreadyOpenedImagePickerAuto;
}

// Reference to a UIImagePickerController
@property (strong, nonatomic) UIImagePickerController *imagePickerController;

// Images to display within the UIScrollViews
@property (strong, nonatomic) UIImageView *imageViewA;
@property (strong, nonatomic) UIImageView *imageViewB;

// CGSizes to remember what the original sizes of the UIImageViews are when taken from the image picker, because
// when they are added to the scrollview, the scrollview changes its frame size to whatever it wants to, and
// we lose track of what the scrollview's original content size should be
@property (nonatomic) CGSize imageViewAOriginalSize;
@property (nonatomic) CGSize imageViewBOriginalSize;

// Two MinMaxZoomScalePair's to remember the min and max zoom scales for each of the ScrollViews -- these
// values are used by -cropToVisible:
// They are updated every time -updateMinimumZoomScaleForImage: is called.
@property (nonatomic) MinMaxZoomPair zoomPairA;
@property (nonatomic) MinMaxZoomPair zoomPairB;

// Gesture recognizers and their action methods for tapping on a UIScrollView to take a new picture
@property (strong, nonatomic) UITapGestureRecognizer *tapScrollViewARecognizer;
- (void)tappedOnScrollViewA:(UITapGestureRecognizer *)gesture;

@property (strong, nonatomic) UITapGestureRecognizer *tapScrollViewBRecognizer;
- (void)tappedOnScrollViewB:(UITapGestureRecognizer *)gesture;

// UIImageViews to serve as spotlights/hotspots and UIPanGestureRecognizers for dragging the hotspots around
@property (strong, nonatomic) UIImageView *hotspotA;
@property (strong, nonatomic) UIImageView *hotspotB;
@property (nonatomic) CGPoint hotspotAStartPanOrigin; // remembers the origin of the hotspot when the pan began
@property (nonatomic) CGPoint hotspotBStartPanOrigin; // remembers the origin of the hotspot when the pan began
@property (strong, nonatomic) UIPanGestureRecognizer *panHotspotARecognizer;
@property (strong, nonatomic) UIPanGestureRecognizer *panHotspotBRecognizer;
- (void)pannedHotspotA:(UIPanGestureRecognizer *)gesture;
- (void)pannedHotspotB:(UIPanGestureRecognizer *)gesture;

// Keep a scrollview's subview centered when zooming out
- (void)keepSubviewCenteredInScrollView:(UIScrollView *)scrollView;

// Update the minimum zoom scale for a given image (either A or B)
- (void)updateMinimumZoomScaleForImage:(PostLayoutImage)image;

// "Lock" and "unlock" a ScrollView -- prevent it from panning or zooming
- (void)lockScrollViewForImage:(PostLayoutImage)image;
- (void)unlockScrollViewForImage:(PostLayoutImage)image;

// Generates an image that is cropped to the portion of it that's visible in the UIScrollView its inside
- (UIImage *)cropToVisible:(PostLayoutImage)image;

// returns TRUE if there is a problem, FALSE if there is no problem
- (BOOL)validateImageLayout;

// Upload an image (for testing)
- (void)uploadImageA:(UIImage *)imageA imageB:(UIImage *)imageB;

@end

@implementation PostLayoutViewController

#pragma mark - Initialization, setup
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialize state variables, see top of file for how these are used
    layoutState = LAYOUTSTATE_A_ONLY;
    targetImageState = TARGETIMAGE_A;
    postState = POSTINGSTATE_PICTURES;
    alreadyOpenedImagePickerAuto = FALSE;
    
    // Set up the navigation bar for Create Post area
    [[[self navigationController] navigationBar] setBarTintColor:COLOR_BETTER_DARK];
    [[[self navigationController] navigationBar] setTintColor:[UIColor whiteColor]];
    [[[self navigationController] navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:FONT_RALEWAY_SEMIBOLD size:FONT_SIZE_NAVIGATION_BAR]}];
    [[[self navigationController] navigationBar] setTranslucent:NO];
    
    // Set up image ScrollViews
    [[self scrollViewA] setDelegate:self];
    [[self scrollViewA] setBounces:NO];
    [[self scrollViewA] setMaximumZoomScale:MAX_ZOOM];
    [[self scrollViewB] setDelegate:self];
    [[self scrollViewB] setBounces:NO];
    [[self scrollViewB] setMaximumZoomScale:MAX_ZOOM];
    
    // Set up hotspots
    [self setHotspotA:[[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_POSTING_HOTSPOT_UNTAGGED]]];
    [self setHotspotB:[[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_POSTING_HOTSPOT_UNTAGGED]]];
    // Set their sizes
    [[self hotspotA] setFrame:CGRectMake(0, 0, WIDTH_HOTSPOT, HEIGHT_HOTSPOT)];
    [[self hotspotB] setFrame:CGRectMake(0, 0, WIDTH_HOTSPOT, HEIGHT_HOTSPOT)];
    // Set them invisible for now
    [[self hotspotA] setAlpha:0];
    [[self hotspotB] setAlpha:0];
    // Make them user-interactable (required for pan gestures to work)
    [[self hotspotA] setUserInteractionEnabled:YES];
    [[self hotspotB] setUserInteractionEnabled:YES];
    
    // Set up hotspot pan gesture recognizers for dragging
    [self setPanHotspotARecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pannedHotspotA:)]];
    [self setPanHotspotBRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pannedHotspotB:)]];
    
    // Add them to the hotspots
    [[self hotspotA] addGestureRecognizer:[self panHotspotARecognizer]];
    [[self hotspotB] addGestureRecognizer:[self panHotspotBRecognizer]];
    
    // Set up initial UI
    [[self plusIconB] setAlpha:0];
    
    // Initialize zoom scale pairs
    MinMaxZoomPair pairA = {0, MAX_ZOOM};
    MinMaxZoomPair pairB = {0, MAX_ZOOM};
    [self setZoomPairA:pairA];
    [self setZoomPairB:pairB];
    
    // Set up tap gesture recognizers
    _tapScrollViewARecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnScrollViewA:)];
    _tapScrollViewBRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnScrollViewB:)];
    // Add them to the ScrollViews
    [[self scrollViewA] addGestureRecognizer:[self tapScrollViewARecognizer]];
    [[self scrollViewB] addGestureRecognizer:[self tapScrollViewBRecognizer]];
    
    /** Set up the UIImagePickerController **/
    
    // Create an image picker
    _imagePickerController = [[UIImagePickerController alloc] init];
    
    // Make this PostLayoutViewController the delegate of the ImagePickerController to get the image it captures/
    // retrieves
    [[self imagePickerController] setDelegate:self];
    
    // If camera is available, use it; otherwise, open up the saved photos list
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [[self imagePickerController] setSourceType:UIImagePickerControllerSourceTypeCamera];
        [[self imagePickerController] setShowsCameraControls:YES];
    }
    else // No camera
        [[self imagePickerController] setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    // More properties
    [[self imagePickerController] setModalPresentationStyle:UIModalPresentationFullScreen];
    [[self imagePickerController] setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    //    [[self imagePickerController] setAllowsEditing:YES];
}

// After the layout has been done
- (void)viewDidLayoutSubviews
{
    // Call super
    [super viewDidLayoutSubviews];
    
    // Set up the correct constants for the ScrollViews
    if(layoutState == LAYOUTSTATE_A_ONLY)
    {
        [[self scrollViewATrailing] setConstant:0]; // Show entire image A
        [[self scrollViewBLeading] setConstant:CGRectGetWidth([[self scrollViewContainer] frame])]; // Hide image B
    }
    
    // Set up the hotspot directions label
    NSString *directionsLineOne = @"Drag spotlights to desired\n";
    NSString *directionsLineTwo = @"positions and double tap to tag.";
    NSString *directionsCombined = [directionsLineOne stringByAppendingString:directionsLineTwo];
    
    // Only increase the line spacing if there's enough vertical space for the label
    // (label's height is less than half of its superview's height)
    [[self hotspotDirectionsLabel] setNumberOfLines:2];
    [[self hotspotDirectionsLabel] setPreferredMaxLayoutWidth:CGRectGetWidth([[self hotspotDirectionsLabel] frame])];
    [[self hotspotDirectionsLabel] setText:directionsCombined];
    
    if(CGRectGetHeight([[self hotspotDirectionsLabel] frame]) < 0.5 * CGRectGetHeight([[[self hotspotDirectionsLabel] superview] frame]))
    {
        // Create an NSRange spanning the second line
        NSRange rangeLineTwo = {[directionsLineOne length], [directionsLineTwo length]};
        
        // Add a negative baseline offset to the 2nd line, which moves it downward
        NSMutableAttributedString *directionsString = [[NSMutableAttributedString alloc] initWithString:directionsCombined];
        [directionsString addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithInt:LINE_SPACING_SPOTLIGHTS_HELPTEXT] range:rangeLineTwo];
        
        // Apply the text
        [[self hotspotDirectionsLabel] setAttributedText:directionsString];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    // Call super
    [super viewDidAppear:animated];
    
    // Have we already opened the image picker automatically the first time
    if(!alreadyOpenedImagePickerAuto)
    {
        // Set status bar to dark color if the image picker is opening the Photo Library
        if([[self imagePickerController] sourceType] == UIImagePickerControllerSourceTypePhotoLibrary)
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        
        // Present the image picker
        [self presentViewController:[self imagePickerController] animated:YES completion:nil];
        
        // Don't show it automatically again
        alreadyOpenedImagePickerAuto = TRUE;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIImagePickerControllerDelegate methods
// Called when the image picker successfully gets an image
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Get the image from the picker
    //    UIImage *capturedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *capturedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Assign and configure the correct image
    switch(targetImageState)
    {
        case TARGETIMAGE_A: // Choosing image A
        {
            // Remove previous UIImageView from the UIScrollView, if necessary
            if([self imageViewA])
            {
                [[self imageViewA] removeFromSuperview];
                _imageViewA = nil;
            }
            
            // Save a UIImageView with this image
            [self setImageViewA:[[UIImageView alloc] initWithImage:capturedImage]];
            
            // Remember what its original size is
            [self setImageViewAOriginalSize:[[self imageViewA] frame].size];
            
            // Put it in the scrollview
            [[self scrollViewA] addSubview:[self imageViewA]];
            [[self scrollViewA] setContentSize:[self imageViewAOriginalSize]];
            
            // Update the minimum zoom scale
            [self updateMinimumZoomScaleForImage:PostLayoutImageA];
            
            // Zoom out all the way
            [[self scrollViewA] setZoomScale:[[self scrollViewA] minimumZoomScale] animated:YES];
            
            break;
        }
        case TARGETIMAGE_B: // Choosing image B
        {
            // Remove previous UIImageView from the UIScrollView, if necessary
            if([self imageViewB])
            {
                [[self imageViewB] removeFromSuperview];
                _imageViewB = nil;
            }
            
            // Save a UIImageView with this image
            [self setImageViewB:[[UIImageView alloc] initWithImage:capturedImage]];
            
            // Remember what its original size is
            [self setImageViewBOriginalSize:[[self imageViewB] frame].size];
            
            // Put it in the scrollview
            [[self scrollViewB] addSubview:[self imageViewB]];
            [[self scrollViewB] setContentSize:[self imageViewBOriginalSize]];
            
            // Update the minimum zoom scale
            [self updateMinimumZoomScaleForImage:PostLayoutImageB];
            
            // Zoom out all the way
            [[self scrollViewB] setZoomScale:[[self scrollViewB] minimumZoomScale] animated:YES];
            
            break;
        }
        default:
            break;
    }
    
    // Dismiss the image picker
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Image picker finished picking image");
        
        // Set status bar style back to light content
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }];
    
    // Set status bar style back to light content
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

// Called when the image picker is cancelled
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // Dismiss the image picker
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Image picker cancelled");
        
        // Set status bar style back to light content
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }];
    
    // Set status bar style back to light content
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

//#pragma mark - UINavigationControllerDelegate methods (from image picker)
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    NSLog(@"hello");
//}

#pragma mark - UIScrollView, delegate methods
// Provides the UIView that the zooming will be based upon
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // Provide different imageviews based on `scrollView`
    if(scrollView == [self scrollViewA])
        return [self imageViewA];
    else if(scrollView == [self scrollViewB])
        return [self imageViewB];
    else
        return nil;
}

// Called when a ScrollView is zooming
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    // Keep the image centered when zooming out
    if(scrollView == [self scrollViewA])
        [self keepSubviewCenteredInScrollView:[self scrollViewA]];
    else if(scrollView == [self scrollViewB])
        [self keepSubviewCenteredInScrollView:[self scrollViewB]];
}

//// Called when zooming is done
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
//{
//    if(scrollView == [self scrollViewA])
//    {
//        [scrollView setContentSize:CGSizeMake(<#CGFloat width#>, <#CGFloat height#>)]
//    }
//}

// Called to keep a scrollview's subview centered when it is zooming out, past the minimum zoom scale
- (void)keepSubviewCenteredInScrollView:(UIScrollView *)scrollView
{
    // Get the ScrollView's contentSize, which shrinks/grows according to the zoom level
    CGSize scrollViewSize = [scrollView frame].size;
    CGSize scrollViewContentSize = [scrollView contentSize];
    UIEdgeInsets newScrollViewInsets = UIEdgeInsetsZero;
    
    // Adjust the subview's frame's origin, if the subview's frame is smaller than the scrollview's frame
    // (means that the ScrollView has been zoomed out far enough so the subview is smaller than the scrollview)
    CGFloat differenceInWidth = scrollViewSize.width - scrollViewContentSize.width;
    if(differenceInWidth > 0)
        newScrollViewInsets.left = differenceInWidth / 2;
    
    CGFloat differenceInHeight = scrollViewSize.height - scrollViewContentSize.height;
    if(differenceInHeight > 0)
        newScrollViewInsets.top = differenceInHeight / 2;
    
    // Set the ScrollView's contentinsets
    [scrollView setContentInset:newScrollViewInsets];
}

- (void)updateMinimumZoomScaleForImage:(PostLayoutImage)image
{
    // Stop if the image is nil (hasn't been selected)
    UIImageView *imageView = (image == PostLayoutImageA) ? [self imageViewA] : [self imageViewB];
    if(imageView == nil)
        return;
    
    // Select the correct ScrollView and ImageView and MinimumZoomScalePair
    UIScrollView *scrollView = (image == PostLayoutImageA) ?  [self scrollViewA] : [self scrollViewB];
    CGSize originalSize = (image == PostLayoutImageA) ? [self imageViewAOriginalSize] : [self imageViewBOriginalSize];
    
    // Calculate the minimum zoom scale in each direction (horizontal,vertical)
    float minZoomScaleHorizontal = CGRectGetWidth([scrollView frame]) / originalSize.width;
    float minZoomScaleVertical = CGRectGetHeight([scrollView frame]) / originalSize.height;
    
    // Pick the larger of the two zoom scales in order to show the image with no empty space around it
    float minZoomScale = fmaxf(minZoomScaleHorizontal, minZoomScaleVertical);
    [scrollView setMinimumZoomScale:minZoomScale];
    
    // save the minimum zoom scale for the correct zoom pair
    MinMaxZoomPair zoomPair = { minZoomScale, MAX_ZOOM };
    // Save it to the correct variable
    if(image == PostLayoutImageA) [self setZoomPairA:zoomPair];
    else if(image == PostLayoutImageB) [self setZoomPairB:zoomPair];
    
    NSLog(@"min zoom scale: %.2f", [scrollView minimumZoomScale]);
    [scrollView setZoomScale:[scrollView minimumZoomScale] animated:YES];
}

// Lock a ScrollView
- (void)lockScrollViewForImage:(PostLayoutImage)image
{
    // Select the correct scrollview
    UIScrollView *scrollView = (image == PostLayoutImageA) ? [self scrollViewA] : [self scrollViewB];
    
    // Disable scrolling
    [scrollView setScrollEnabled:NO];
    
    // Lock the zoom -- set both min and max zoom to the current zoom scale
    CGFloat currentZoom = [scrollView zoomScale];
    [scrollView setMaximumZoomScale:currentZoom];
    [scrollView setMinimumZoomScale:currentZoom];
}

// Unlock a ScrollView
- (void)unlockScrollViewForImage:(PostLayoutImage)image
{
    // Select the correct scrollview
    UIScrollView *scrollView = (image == PostLayoutImageA) ? [self scrollViewA] : [self scrollViewB];
    
    // Enable scrolling
    [scrollView setScrollEnabled:YES];
    
    // Unlock the zoom -- re-set the max and min zoom
    [scrollView setMaximumZoomScale:MAX_ZOOM];
    [self updateMinimumZoomScaleForImage:image]; // Updates the minimum zoom
}

#pragma mark - Navigation
/*
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Image processing
// Crops either the A or B image to the portion that's visible
- (UIImage *)cropToVisible:(PostLayoutImage)image
{
    // Select the correct ScrollView and ImageView based on `image` parameter
    UIScrollView *scrollView = (image == PostLayoutImageA) ? [self scrollViewA] : [self scrollViewB];
    UIImageView *imageView = (image == PostLayoutImageA) ? [self imageViewA] : [self imageViewB];
    CGSize originalImageSize = (image == PostLayoutImageA) ? [self imageViewAOriginalSize] : [self imageViewBOriginalSize];
    MinMaxZoomPair zoomPair = (image == PostLayoutImageA) ? [self zoomPairA] : [self zoomPairB];
    
    // Stop if the image doesn't exist
    if([imageView image] == nil)
        return nil;
    
    // Get the CGImage representation of the current image in the ScrollView
    UIImage *imageInView = [imageView image];
    CGImageRef imageRef = [imageInView CGImage];
    
    NSLog(@"picture orientation: ");
    
    // Crop out the selected portion (rectangle) of the image
    CGPoint scrollViewOffset = [scrollView contentOffset];
    CGFloat scrollViewCurrentZoom = [scrollView zoomScale];
    CGFloat scrollViewMinimumZoom = zoomPair.minZoomScale;
    CGFloat zoomRatio = (scrollViewMinimumZoom / scrollViewCurrentZoom);
    
    // Figure out the cropping region
    CGRect cropRegion;
    cropRegion.origin.x = scrollViewOffset.x / scrollViewCurrentZoom;
    cropRegion.origin.y = scrollViewOffset.y / scrollViewCurrentZoom;
    
    switch([imageInView imageOrientation])
    {
            /// No rotation ///
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
        {
            NSLog(@"   UP orientation");
            
            // Adjust size based on the layout
            switch(layoutState)
            {
                case LAYOUTSTATE_A_ONLY:
                {
                    // Determine size of the region -- we want to take the smallest side of the image and set that
                    // value to the desired image's width and height
                    CGFloat squareSize = fminf(originalImageSize.width * zoomRatio, originalImageSize.height * zoomRatio);
                    cropRegion.size.width = squareSize;
                    cropRegion.size.height = squareSize;
                    
                    break;
                }
                    
                case LAYOUTSTATE_LEFT_RIGHT:
                {
                    // Determine size of the region -- base it on the height of the image
                    cropRegion.size.height = originalImageSize.height * zoomRatio;
                    cropRegion.size.width = cropRegion.size.height / 2;
                    
                    break;
                }
                case LAYOUTSTATE_TOP_BOTTOM:
                {
                    // Determine size of the region -- base it on the width of the image
                    cropRegion.size.width = originalImageSize.width * zoomRatio;
                    cropRegion.size.height = cropRegion.size.width / 2;
                    
                    break;
                }
                default:
                    break;
            }
            
            break;
        }
            
            /// Rotated left 90 degrees (comes out of camera) ///
            /// Translating between coordinate systems is hard...
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
        {
            NSLog(@"   RIGHT orientation");
            
            // Determine region size based on the layout format
            switch(layoutState)
            {
                    // 1 image only
                case LAYOUTSTATE_A_ONLY:
                {
                    cropRegion.size.width = originalImageSize.width * zoomRatio;
                    cropRegion.size.height = cropRegion.size.width;
                    
                    // Flip the x and y values of the origin if the orientation is UIImageOrientationRight, a.k.a. rotated 90 deg left)
                    CGPoint oldOrigin = cropRegion.origin;
                    cropRegion.origin = CGPointMake(oldOrigin.y, originalImageSize.width - cropRegion.size.width - oldOrigin.x);
                    
                    break;
                }
                    
                    // Images left and right
                case LAYOUTSTATE_LEFT_RIGHT:
                {
                    cropRegion.size.width = originalImageSize.height * zoomRatio;
                    cropRegion.size.height = cropRegion.size.width / 2;
                    
                    // Flip the x and y values of the origin if the orientation is UIImageOrientationRight, a.k.a. rotated 90 deg left)
                    CGPoint oldOrigin = cropRegion.origin;
                    cropRegion.origin = CGPointMake(oldOrigin.y, originalImageSize.width - cropRegion.size.height - oldOrigin.x);
                    
                    break;
                }
                    
                    // Images top and bottom
                case LAYOUTSTATE_TOP_BOTTOM:
                {
                    cropRegion.size.height = originalImageSize.width * zoomRatio;
                    cropRegion.size.width = cropRegion.size.height / 2;
                    
                    // Flip the x and y values of the origin if the orientation is UIImageOrientationRight, a.k.a. rotated 90 deg left)
                    CGPoint oldOrigin = cropRegion.origin;
                    cropRegion.origin = CGPointMake(oldOrigin.y, originalImageSize.width - cropRegion.size.height - oldOrigin.x);
                    
                    break;
                }
                    
                default:
                    break;
            }
            
            break;
        }
            
            /// Image is flipped (rotated 180 deg)
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
        {
            NSLog(@"   DOWN orientation");
            
            // Adjust size based on the layout
            switch(layoutState)
            {
                case LAYOUTSTATE_A_ONLY:
                {
                    // Determine size of the region -- we want to take the smallest side of the image and set that
                    // value to the desired image's width and height
                    CGFloat squareSize = fminf(originalImageSize.width * zoomRatio, originalImageSize.height * zoomRatio);
                    cropRegion.size.width = squareSize;
                    cropRegion.size.height = squareSize;
                    
                    break;
                }
                    
                case LAYOUTSTATE_LEFT_RIGHT:
                {
                    // Determine size of the region -- base it on the height of the image
                    cropRegion.size.height = originalImageSize.height * zoomRatio;
                    cropRegion.size.width = cropRegion.size.height / 2;
                    
                    break;
                }
                case LAYOUTSTATE_TOP_BOTTOM:
                {
                    // Determine size of the region -- base it on the width of the image
                    cropRegion.size.width = originalImageSize.width * zoomRatio;
                    cropRegion.size.height = cropRegion.size.width / 2;
                    
                    break;
                }
                default:
                    break;
            }
            
            // Adjust origin (same for all layouts in orientation Down)
            CGPoint oldOrigin = cropRegion.origin;
            cropRegion.origin = CGPointMake(originalImageSize.width - cropRegion.size.width - oldOrigin.x, originalImageSize.height - cropRegion.size.height - oldOrigin.y);
            
            break;
        }
            
            /// Rotataed 90 deg clockwise ///
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        {
            NSLog(@"   LEFT orientation");
            
            // Determine region size based on the layout format
            switch(layoutState)
            {
                    // 1 image only
                case LAYOUTSTATE_A_ONLY:
                {
                    cropRegion.size.width = originalImageSize.width * zoomRatio;
                    cropRegion.size.height = cropRegion.size.width;
                    
                    // Adjust the origin for UIImageOrientationLeft
                    CGPoint oldOrigin = cropRegion.origin;
                    cropRegion.origin = CGPointMake(originalImageSize.height - cropRegion.size.height - oldOrigin.y, oldOrigin.x);
                    
                    break;
                }
                    
                    // Images left and right
                case LAYOUTSTATE_LEFT_RIGHT:
                {
                    cropRegion.size.width = originalImageSize.height * zoomRatio;
                    cropRegion.size.height = cropRegion.size.width / 2;
                    
                    // Adjust the origin for UIImageOrientationLeft
                    CGPoint oldOrigin = cropRegion.origin;
                    cropRegion.origin = CGPointMake(originalImageSize.height - cropRegion.size.width - oldOrigin.y, oldOrigin.x);
                    
                    break;
                }
                    
                    // Images top and bottom
                case LAYOUTSTATE_TOP_BOTTOM:
                {
                    cropRegion.size.height = originalImageSize.width * zoomRatio;
                    cropRegion.size.width = cropRegion.size.height / 2;
                    
                    // Flip the x and y values of the origin if the orientation is UIImageOrientationRight, a.k.a. rotated 90 deg left)
                    CGPoint oldOrigin = cropRegion.origin;
                    cropRegion.origin = CGPointMake(originalImageSize.height - cropRegion.size.width - oldOrigin.y, oldOrigin.x);
                    
                    break;
                }
                    
                default:
                    break;
            }
            
            break;
        }
            
        default:
            break;
    }
    
    CFDictionaryRef cropRegionReadable = CGRectCreateDictionaryRepresentation(cropRegion);
    NSLog(@"%@", cropRegionReadable);
    CFRelease(cropRegionReadable);
    
    // Crop the image using CGImageCreateWithImageInRect
    CGImageRef croppedImageRef = CGImageCreateWithImageInRect(imageRef, cropRegion);
    
    //    UIImage *croppedImage = [UIImage imageWithCGImage:croppedImageRef];
    
    // I think we may need to add code to actually rotate the pixels in the image instead of marking the image
    // as "rotated", because (possibly) some phones will ignore the rotation flag and show the image sideways
    UIImage *croppedImage = [UIImage imageWithCGImage:croppedImageRef
                                                scale:[imageInView scale]
                                          orientation:[imageInView imageOrientation]];
    
    // Get rid of image data
    CGImageRelease(croppedImageRef);
    
    if(!croppedImage)
    {
        NSLog(@"Invalid crop rectangle!!!!");
        return nil;
    }
    else
        return croppedImage;
}

// Returns TRUE if there is a problem with the images, or FALSE if there is no error
- (BOOL)validateImageLayout
{
    // Get pointers to the images in the ImageViews
    UIImage *imageA = [[self imageViewA] image];
    UIImage *imageB = [[self imageViewB] image];
    
    // Error-check the images (i.e. are they missing?)
    BOOL problemExists = FALSE;
    NSString *errorTitle = nil;
    NSString *errorMessage = nil;
    
    // Set different error titles and messages depending on the layout state and which images exist
    if(layoutState == LAYOUTSTATE_A_ONLY && !imageA)
    {
        errorTitle = @"Missing image";
        errorMessage = @"Please add an image to continue your post";
        problemExists = TRUE;
    }
    // 2-image layouts
    else if(layoutState == LAYOUTSTATE_LEFT_RIGHT || layoutState == LAYOUTSTATE_TOP_BOTTOM)
    {
        // No images picked
        if(!imageA && !imageB)
        {
            errorTitle = @"Missing images";
            errorMessage = @"Please add both images to continue your post";
            problemExists = TRUE;
        }
        // One image has been picked
        else if((imageA && !imageB) || (!imageA && imageB))
        {
            errorTitle = @"Missing image";
            errorMessage = @"Please add another image to continue your post";
            problemExists = TRUE;
        }
    }
    
    // Show an error message if there's a problem
    if(problemExists)
    {
        if([UIAlertController class]) // iOS 8+
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:errorTitle
                                                                           message:errorMessage
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil]];
            // Present it
            [self presentViewController:alert animated:YES completion:nil];
            // Set its tint color
            [[alert view] setTintColor:COLOR_BETTER_DARK];
        }
        else // iOS 7
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorTitle
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    
    return problemExists;
}

- (void)uploadImageA:(UIImage *)imageA imageB:(UIImage *)imageB
{
    ////// A temporary way to check how the images look when they are off of the phone -- this code sends the
    // image to a .php file with the following lines:
    /*
     <?php
     
     move_uploaded_file($_FILES["image"]["tmp_name"], "./".$_FILES["image"]["name"]);
     move_uploaded_file($_FILES["image2"]["tmp_name"], "./".$_FILES["image2"]["name"]);
     
     ?>
     */
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
    // Turn on network indicator
    [[UserInfo user] setNetworkActivityIndicatorVisible:YES];
    
    [manager POST:@"http://10.1.0.144/imageupload.php"
       parameters:nil
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    
    [formData appendPartWithFileData:UIImageJPEGRepresentation(imageA, 0.8) // 0.8 out of 1 is the quality
                                name:@"image"
                            fileName:@"image.jpg"
                            mimeType:@"image/jpeg"];
    if(imageB != nil)
        [formData appendPartWithFileData:UIImageJPEGRepresentation(imageB, 0.8)
                                    name:@"image2"
                                fileName:@"image2.jpg"
                                mimeType:@"image/jpeg"];
}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"Upload success!!");
              
              // Turn off network indicator
              [[UserInfo user] setNetworkActivityIndicatorVisible:NO];
              
              // Change state
              postState = POSTINGSTATE_SPOTLIGHTS;
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"**!!** Network error! %@", error);
              
              // Turn off network indicator
              [[UserInfo user] setNetworkActivityIndicatorVisible:NO];
          }];
}

#pragma mark - Gesture recognizer handling
// Scroll View A tap
- (void)tappedOnScrollViewA:(UITapGestureRecognizer *)gesture
{
    // Set the image that we are picking
    targetImageState = TARGETIMAGE_A;
    
    // Set status bar to dark color if the image picker is opening the Photo Library
    if([[self imagePickerController] sourceType] == UIImagePickerControllerSourceTypePhotoLibrary)
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    // Show the image picker
    [self presentViewController:[self imagePickerController] animated:YES completion:nil];
}

// Scroll View B tap
- (void)tappedOnScrollViewB:(UITapGestureRecognizer *)gesture
{
    // Set the image that we are picking
    targetImageState = TARGETIMAGE_B;
    
    // Set status bar to dark color if the image picker is opening the Photo Library
    if([[self imagePickerController] sourceType] == UIImagePickerControllerSourceTypePhotoLibrary)
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    // Show the image picker
    [self presentViewController:[self imagePickerController] animated:YES completion:nil];
}

// Panning hotspot A
- (void)pannedHotspotA:(UIPanGestureRecognizer *)gesture
{
    // Get translation of the gesture within the scrollViewContainer
    CGPoint touchPoint = [gesture translationInView:[self scrollViewContainer]];
    
    // Perform different actions based on the state of the gesture
    switch([gesture state])
    {
        case UIGestureRecognizerStateBegan:
        {
            // Save the origin of the hotspot at the beginning of the gesture
            [self setHotspotAStartPanOrigin:[[self hotspotA] frame].origin];
            
            break;
        }
        case UIGestureRecognizerStateChanged: // User is moving finger
        {
            // Keep the hotspot within certain bounds, based on the layoutState
            switch(layoutState)
            {
                case LAYOUTSTATE_A_ONLY: // Image A only
                {
                    // Make sure the hotspot stays inside the scrollViewContainer and not overlapping the other
                    // hotspot:
                    
                    // We always calculate the new position, but don't apply it if the hotspot shouldn't
                    // move to this new position
                    CGRect newFrame = [[self hotspotA] frame];
                    newFrame.origin.x = [self hotspotAStartPanOrigin].x + touchPoint.x;
                    newFrame.origin.y = [self hotspotAStartPanOrigin].y + touchPoint.y;
                    
                    // Calculate the center of this newFrame
                    CGPoint newFrameCenter;
                    newFrameCenter.x = newFrame.origin.x + (newFrame.size.width / 2);
                    newFrameCenter.y = newFrame.origin.y + (newFrame.size.height / 2);
                    
                    // Calculate distance between the hotspots using this "candidate" frame and center
                    CGVector hotspotToHotspot;
                    hotspotToHotspot.dx = newFrameCenter.x - [[self hotspotB] center].x;
                    hotspotToHotspot.dy = newFrameCenter.y - [[self hotspotB] center].y;
                    
                    CGFloat hotspotDistance = sqrt(pow(hotspotToHotspot.dx, 2) + pow(hotspotToHotspot.dy, 2));
                    BOOL isNotOverlapping = hotspotDistance > WIDTH_HOTSPOT;
                    // ^^ **Assumes the hotspots are square (width == height)
                    
                    // Is the hotspot within the bounds of scrollViewContainer?
                    BOOL isInsideContainer = CGRectContainsRect([[self scrollViewContainer] frame], newFrame);
                    
                    // Check the conditions and set the new position if possible
                    if(isInsideContainer && isNotOverlapping)
                        // Apply the position change
                        [[self hotspotA] setFrame:newFrame];
                    
                    break;
                }
            }
            
            break;
        }
            
        default:
            break;
    }
}

// Panning hotspot B
- (void)pannedHotspotB:(UIPanGestureRecognizer *)gesture
{
    
}

#pragma mark - Button handling
- (IBAction)pressedBackArrow:(id)sender
{
    // Perform different actions based on which posting state we're in:
    switch(postState)
    {
        case POSTINGSTATE_PICTURES: // Selecting images and moving them around
        {
            // Dismiss this, go back to the Feed
            NSString *errorTitle = @"Discard this post?";
            NSString *errorMessage = @"Are you sure you want to quit the posting process? Your images will not be saved.";
            
            if([UIAlertController class]) // UIAlertController is not available before iOS 8
            {
                UIAlertController *dismissAlert = [UIAlertController alertControllerWithTitle:errorTitle
                                                                                      message:errorMessage
                                                                               preferredStyle:UIAlertControllerStyleAlert];
                [dismissAlert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:nil]];
                [dismissAlert addAction:[UIAlertAction actionWithTitle:@"Quit"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action) {
                                                                   // Show Feed again
                                                                   [self dismissViewControllerAnimated:YES completion:nil];
                                                               }]];
                // Show the alert
                [self presentViewController:dismissAlert animated:YES completion:nil];
                
                // Set its tint color (changes the font color of the buttons)
                [[dismissAlert view] setTintColor:COLOR_BETTER_DARK];
            }
            else // iOS 7
            {
                UIAlertView *dismissAlert = [[UIAlertView alloc] initWithTitle:errorTitle
                                                                       message:errorMessage
                                                                      delegate:self
                                                             cancelButtonTitle:nil
                                                             otherButtonTitles:@"Cancel", @"Quit", nil];
                [dismissAlert show];
            }
            
            break;
        }
        case POSTINGSTATE_SPOTLIGHTS: // Going back from moving hotspots and adding hashtags to them
        {
            // Show layout buttons, hide hotspot help label
            [UIView animateWithDuration:ANIM_DURATION_POST_LAYOUT_CHANGE
                             animations:^{
                                 [[self hotspotDirectionsLabel] setAlpha:0];
                                 [[self hotspotA] setAlpha:0];
                                 [[self hotspotB] setAlpha:0];
                                 [[self layoutButtonSingle] setAlpha:1];
                                 [[self layoutButtonLeftRight] setAlpha:1];
                                 [[self layoutButtonTopBottom] setAlpha:1];
                             }
             completion:^(BOOL finished) {
                 // Remove hotspots from the scrollview(s)
                 [[self hotspotA] removeFromSuperview];
                 [[self hotspotB] removeFromSuperview];
                 
                 // Unlock ScrollViews
                 [self unlockScrollViewForImage:PostLayoutImageA];
                 [self unlockScrollViewForImage:PostLayoutImageB];
                 
                 // Enable tap gesture recognizers
                 [[self tapScrollViewARecognizer] setEnabled:YES];
                 [[self tapScrollViewBRecognizer] setEnabled:YES];
             }];
            
            // Set state
            postState = POSTINGSTATE_PICTURES;
            
            break;
        }
    }
}

// (for testing only)
- (IBAction)uploadButtonPressed:(id)sender
{
    // Run the cropping in the background, since it can take a bit of time
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
        // Get the images cropped to their visible regions
        UIImage *croppedImageA = [self cropToVisible:PostLayoutImageA];
        UIImage *croppedImageB = [self cropToVisible:PostLayoutImageB];
        
        // Upload the pictures
        if(croppedImageA != nil)
            [self uploadImageA:croppedImageA imageB:croppedImageB];
    });
}


- (IBAction)pressedNextButton:(id)sender
{
    // Perform different actions based on which posting state we're in:
    switch(postState)
    {
        case POSTINGSTATE_PICTURES: // Selecting images and moving them around
        {
            // Error-check the image layout and display an alert dialog if there is a problem
            BOOL problemExists = [self validateImageLayout];
            
            // Continue if there's no problem
            if(!problemExists)
            {
                // Lock the ScrollViews
                [self lockScrollViewForImage:PostLayoutImageA];
                [self lockScrollViewForImage:PostLayoutImageB];
                
                // Disable tap gesture recognizers
                [[self tapScrollViewARecognizer] setEnabled:NO];
                [[self tapScrollViewBRecognizer] setEnabled:NO];
                
                // Add the hotspots to scrollViewContainer.
                // It would be nice to add the hotspots as subviews of the scrollviews themselves, but
                // even if you disable scrolling and zooming, the hotspot's origin would be affected if
                // the user had scrolled/panned/zoomed the scrollview at all.
                [[self scrollViewContainer] addSubview:[self hotspotA]];
                [[self scrollViewContainer] addSubview:[self hotspotB]];
                
                // Determine the hotspots' position
                switch(layoutState)
                {
                    case LAYOUTSTATE_A_ONLY: // Only image A is visible
                    case LAYOUTSTATE_LEFT_RIGHT: // Image A and B side-by-side
                    {
                        
                        // Place them vertically centered and next to each other
                        // e.g.
                        // ---------
                        // |   |   |
                        // |   |   |
                        // | O | O |<- vertical center
                        // |   |   |
                        // |   |   |
                        // |   |   |
                        // ---------
                        //     ^ horiz. center
                        
                        CGSize scrollViewContainerSize = [[self scrollViewContainer] frame].size;
                        CGRect hotspotAFrame = [[self hotspotA] frame];
                        CGRect hotspotBFrame = [[self hotspotB] frame];
                        
                        hotspotAFrame.origin.x = (scrollViewContainerSize.width / 4) - (hotspotAFrame.size.width / 2);
                        hotspotAFrame.origin.y = (scrollViewContainerSize.height / 2) - (hotspotAFrame.size.height / 2);
                        hotspotBFrame.origin.x = (scrollViewContainerSize.width / 4 * 3) - (hotspotBFrame.size.width / 2);
                        hotspotBFrame.origin.y = (scrollViewContainerSize.height / 2) - (hotspotBFrame.size.height / 2);
                        
                        // Apply these positions
                        [[self hotspotA] setFrame:hotspotAFrame];
                        [[self hotspotB] setFrame:hotspotBFrame];
                        
                        break;
                    }
                    case LAYOUTSTATE_TOP_BOTTOM: // Image A upper, image B lower
                    {
                        // ---------
                        // |       |
                        // |   O   |
                        // |       |
                        // |-------|<- vertical center
                        // |       |
                        // |   O   |
                        // |       |
                        // ---------
                        //     ^ horiz. center
                        
                        // Place them centered in each scrollview
                        CGSize scrollViewContainerSize = [[self scrollViewContainer] frame].size;
                        CGRect hotspotAFrame = [[self hotspotA] frame];
                        CGRect hotspotBFrame = [[self hotspotB] frame];
                        
                        hotspotAFrame.origin.x = (scrollViewContainerSize.width / 2) - (hotspotAFrame.size.width / 2);
                        hotspotAFrame.origin.y = (scrollViewContainerSize.height / 4) - (hotspotAFrame.size.height / 2);
                        hotspotBFrame.origin.x = (scrollViewContainerSize.width / 2) - (hotspotBFrame.size.width / 2);
                        hotspotBFrame.origin.y = (scrollViewContainerSize.height / 4 * 3) - (hotspotBFrame.size.height / 2);
                        
                        // Apply these positions
                        [[self hotspotA] setFrame:hotspotAFrame];
                        [[self hotspotB] setFrame:hotspotBFrame];
                        
                        break;
                    }
                }
                
                // Hide layout buttons
                [UIView animateWithDuration:ANIM_DURATION_POST_LAYOUT_CHANGE
                                 animations:^{
                                     [[self hotspotDirectionsLabel] setAlpha:1];
                                     [[self hotspotA] setAlpha:1];
                                     [[self hotspotB] setAlpha:1];
                                     [[self layoutButtonSingle] setAlpha:0];
                                     [[self layoutButtonLeftRight] setAlpha:0];
                                     [[self layoutButtonTopBottom] setAlpha:0];
                                 }];
                
                // Change state
                postState = POSTINGSTATE_SPOTLIGHTS;
            }
            
            break;
        }
    }
}

// For iOS7's UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Quit"])
    {
        // Go back to the Feed
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)pressedAOnlyLayoutButton:(id)sender
{
    // Change the layout
    if(layoutState != LAYOUTSTATE_A_ONLY)
    {
        // Change state
        layoutState = LAYOUTSTATE_A_ONLY;
        
        // Change layout button states (changes their images)
        [[self layoutButtonSingle] setSelected:YES];
        [[self layoutButtonLeftRight] setSelected:NO];
        [[self layoutButtonTopBottom] setSelected:NO];
        
        // Set constraints
        [[self scrollViewContainer] layoutIfNeeded];
        [UIView animateWithDuration:ANIM_DURATION_POST_LAYOUT_CHANGE
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             // Update constraints
                             [[self scrollViewABottom] setConstant:0];
                             [[self scrollViewATrailing] setConstant:0];
                             [[self scrollViewBLeading] setConstant:CGRectGetWidth([[self scrollViewContainer] frame])];
                             [[self scrollViewBTop] setConstant:0];
                             
                             // Fade out (+) icon B
                             [[self plusIconB] setAlpha:0];
                             
                             // Apply changes
                             [[self scrollViewContainer] layoutIfNeeded];
                             
                             // Update zoom
                             [self updateMinimumZoomScaleForImage:PostLayoutImageA];
                         }
                         completion:nil];
    }
}

- (IBAction)pressedLeftRightLayoutButton:(id)sender
{
    // Change the layout
    if(layoutState != LAYOUTSTATE_LEFT_RIGHT)
    {
        // Change state
        layoutState = LAYOUTSTATE_LEFT_RIGHT;
        
        // Change layout button states (changes their images)
        [[self layoutButtonSingle] setSelected:NO];
        [[self layoutButtonLeftRight] setSelected:YES];
        [[self layoutButtonTopBottom] setSelected:NO];
        
        // Set constraints
        [[self scrollViewContainer] layoutIfNeeded];
        [UIView animateWithDuration:ANIM_DURATION_POST_LAYOUT_CHANGE
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             // Update constraints
                             [[self scrollViewABottom] setConstant:0];
                             [[self scrollViewATrailing] setConstant:(CGRectGetWidth([[self scrollViewContainer] frame]) / 2)];
                             [[self scrollViewBLeading] setConstant:(CGRectGetWidth([[self scrollViewContainer] frame]) / 2)];
                             [[self scrollViewBTop] setConstant:0];
                             
                             // Fade in (+) icon B
                             [[self plusIconB] setAlpha:1];
                             
                             // Apply changes
                             [[self scrollViewContainer] layoutIfNeeded];
                             
                             // Update zooms
                             [self updateMinimumZoomScaleForImage:PostLayoutImageA];
                             [self updateMinimumZoomScaleForImage:PostLayoutImageB];
                         }
                         completion:nil];
    }
}

- (IBAction)pressedTopBottomLayoutButton:(id)sender
{
    // Change the layout
    if(layoutState != LAYOUTSTATE_TOP_BOTTOM)
    {
        // Change state
        layoutState = LAYOUTSTATE_TOP_BOTTOM;
        
        // Change layout button states (changes their images)
        [[self layoutButtonSingle] setSelected:NO];
        [[self layoutButtonLeftRight] setSelected:NO];
        [[self layoutButtonTopBottom] setSelected:YES];
        
        // Set constraints
        [[self scrollViewContainer] layoutIfNeeded];
        [UIView animateWithDuration:ANIM_DURATION_POST_LAYOUT_CHANGE
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             // Update constraints
                             [[self scrollViewABottom] setConstant:(CGRectGetHeight([[self scrollViewContainer] frame]) / 2)];
                             [[self scrollViewATrailing] setConstant:0];
                             [[self scrollViewBLeading] setConstant:0];
                             [[self scrollViewBTop] setConstant:(CGRectGetHeight([[self scrollViewContainer] frame]) / 2)];
                             
                             // Fade in (+) icon B
                             [[self plusIconB] setAlpha:1];
                             
                             // Apply changes
                             [[self scrollViewContainer] layoutIfNeeded];
                             
                             // Update zooms
                             [self updateMinimumZoomScaleForImage:PostLayoutImageA];
                             [self updateMinimumZoomScaleForImage:PostLayoutImageB];
                         }
                         completion:nil];
    }
}
@end
