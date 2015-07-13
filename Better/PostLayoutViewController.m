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

@interface PostLayoutViewController ()
{
    // An integer that keeps track of the state of the image layout--there are three states:
    // (0) image A is fully shown, image B is hidden
    // (1) image A is on the left, image B is on the right
    // (2) image A is on the top, image B is on the bottom
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

// Gesture recognizers and their action methods for tapping on a UIScrollView to take a new picture
@property (strong, nonatomic) UITapGestureRecognizer *tapScrollViewARecognizer;
- (void)tappedOnScrollViewA:(UITapGestureRecognizer *)gesture;

@property (strong, nonatomic) UITapGestureRecognizer *tapScrollViewBRecognizer;
- (void)tappedOnScrollViewB:(UITapGestureRecognizer *)gesture;

// Keep a scrollview's subview centered when zooming out
- (void)keepSubviewCenteredInScrollView:(UIScrollView *)scrollView;

// Update the minimum zoom scale for a given image (either A or B)
- (void)updateMinimumZoomScaleForImage:(PostLayoutImage)image;

// "Lock" and "unlock" a ScrollView -- prevent it from panning or zooming
- (void)lockScrollViewForImage:(PostLayoutImage)image;
- (void)unlockScrollViewForImage:(PostLayoutImage)image;

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
    
    // Begin with Plus B icon hidden
    [[self plusIconB] setAlpha:0];
    
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
}

- (void)viewDidAppear:(BOOL)animated
{
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
            [[self scrollViewA] setZoomScale:[[self scrollViewA] minimumZoomScale] animated:NO];
            
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
            [[self scrollViewB] setZoomScale:[[self scrollViewB] minimumZoomScale] animated:NO];
            
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

#pragma mark - UINavigationControllerDelegate methods (from image picker)
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"hello");
}

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
    
    // Reset the ScrollView's contentSize to the original size of the image -- while zooming, the ScrollView
    // changes its contentSize and so it loses track of it after switching between layouts; this resets it
//    CGSize newContentSize;
//    newContentSize.width = originalSize.width * [scrollView zoomScale];
//    newContentSize.height = originalSize.height * [scrollView zoomScale];
//    [scrollView setContentSize:newContentSize];
    
    // Calculate the minimum zoom scale in each direction (horizontal,vertical)
    float minZoomScaleHorizontal = CGRectGetWidth([scrollView frame]) / originalSize.width;
    float minZoomScaleVertical = CGRectGetHeight([scrollView frame]) / originalSize.height;
    
    // Set the zoom scales depending on the current layout state
//    switch(layoutState)
//    {
//        case LAYOUTSTATE_A_ONLY:
//            [scrollView setMinimumZoomScale:fmaxf(minZoomScaleHorizontal, minZoomScaleVertical)];
//            break;
//            
//        case LAYOUTSTATE_LEFT_RIGHT:
//            [scrollView setMinimumZoomScale:fminZoomScaleVertical];
//            break;
//            
//        case LAYOUTSTATE_TOP_BOTTOM:
//            [scrollView setMinimumZoomScale:minZoomScaleHorizontal];
//            break;
//            
//        default:
//            break;
//    }
    
    [scrollView setMinimumZoomScale:fmaxf(minZoomScaleHorizontal, minZoomScaleVertical)];
    
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

#pragma mark - Button handling
- (IBAction)pressedBackArrow:(id)sender
{
    // Dismiss this, go back to the Feed
    
    if([UIAlertController class]) // UIAlertController is not available before iOS 8
    {
        UIAlertController *dismissAlert = [UIAlertController alertControllerWithTitle:@"Are you sure you want to quit the posting process?"
                                                                              message:nil
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
    else
    {
        UIAlertView *dismissAlert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to quit the posting process?"
                                                               message:nil
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"Cancel", @"Quit", nil];
        [dismissAlert show];
    }
}

- (IBAction)pressedNextButton:(id)sender
{
    // Get the CGImage representation of the current image in the ScrollView
    UIImage *imageInView = [[self imageViewA] image];
    CGImageRef image = [imageInView CGImage];
    
    NSLog(@"picture orientation: ");
    switch([imageInView imageOrientation])
    {
        case UIImageOrientationUp:
            NSLog(@"   UP orientation");
            break;
        case UIImageOrientationRight:
            NSLog(@"   RIGHT orientation");
            break;
        default:
            NSLog(@"   Unrecognized orientation: %i", [imageInView imageOrientation]);
            NSLog(@"   ** Choose a different image **");
            return;
    }
    
    // Crop out the selected portion (rectangle) of the image
    CGPoint scrollViewOffset = [[self scrollViewA] contentOffset];
    CGFloat scrollViewCurrentZoom = [[self scrollViewA] zoomScale];
    CGFloat scrollViewMinimumZoom = [[self scrollViewA] minimumZoomScale];
    CGFloat zoomRatio = (scrollViewMinimumZoom / scrollViewCurrentZoom);
    
    // Figure out the cropping region
    CGRect cropRegion;
    cropRegion.origin.x = scrollViewOffset.x / scrollViewCurrentZoom;
    cropRegion.origin.y = scrollViewOffset.y / scrollViewCurrentZoom;
    
    switch([imageInView imageOrientation])
    {
        /// No rotation ///
        case UIImageOrientationUp:
        {
            // Adjust based on the layout
            switch(layoutState)
            {
                case LAYOUTSTATE_A_ONLY:
                {
                    // Determine size of the region -- we want to take the smallest side of the image and set that
                    // value to the desired image's width and height
                    CGFloat squareSize = fminf([self imageViewAOriginalSize].width * zoomRatio, [self imageViewAOriginalSize].height * zoomRatio);
                    cropRegion.size.width = squareSize;
                    cropRegion.size.height = squareSize;
                    
                    break;
                }
                    
                case LAYOUTSTATE_LEFT_RIGHT:
                {
                    // Determine size of the region -- base it on the height of the image
                    cropRegion.size.height = [self imageViewAOriginalSize].height;
                    cropRegion.size.width = cropRegion.size.height;
                    
                    // Adjust for smaller width
                    cropRegion.size.width /= 2;
                    
                    break;
                }
                case LAYOUTSTATE_TOP_BOTTOM:
                {
                    // Determine size of the region -- base it on the width of the image
                    cropRegion.size.width = [self imageViewAOriginalSize].width;
                    cropRegion.size.height = cropRegion.size.width;
                    
                    // Adjust for smaller height
                    cropRegion.size.height /= 2;
                    
                    break;
                }
                default: break;
            }
            
            break;
        }
            
        /// Rotated left 90 degrees (comes out of camera) ///
        /// Translating between coordinate systems is hard...
        case UIImageOrientationRight:
        {
            // Determine region size based on the layout format
            switch(layoutState)
            {
                // 1 image only
                case LAYOUTSTATE_A_ONLY:
                {
                    cropRegion.size.width = [self imageViewAOriginalSize].width * zoomRatio;
                    cropRegion.size.height = cropRegion.size.width;
                    
                    // Flip the x and y values of the origin if the orientation is UIImageOrientationRight, a.k.a. rotated 90 deg left)
                    CGPoint oldOrigin = cropRegion.origin;
                    cropRegion.origin = CGPointMake(oldOrigin.y, [self imageViewAOriginalSize].width - cropRegion.size.width - oldOrigin.x);
                    
                    break;
                }
                    
                // Images left and right
                case LAYOUTSTATE_LEFT_RIGHT:
                {
                    cropRegion.size.width = [self imageViewAOriginalSize].height * zoomRatio;
                    cropRegion.size.height = cropRegion.size.width / 2;
                    
                    // Flip the x and y values of the origin if the orientation is UIImageOrientationRight, a.k.a. rotated 90 deg left)
                    CGPoint oldOrigin = cropRegion.origin;
                    cropRegion.origin = CGPointMake(oldOrigin.y, [self imageViewAOriginalSize].width - cropRegion.size.height - oldOrigin.x);
                    
                    break;
                }
                    
                // Images top and bottom
                case LAYOUTSTATE_TOP_BOTTOM:
                {
                    cropRegion.size.height = [self imageViewAOriginalSize].width * zoomRatio;
                    cropRegion.size.width = cropRegion.size.height / 2;
                    
                    // Flip the x and y values of the origin if the orientation is UIImageOrientationRight, a.k.a. rotated 90 deg left)
                    CGPoint oldOrigin = cropRegion.origin;
                    cropRegion.origin = CGPointMake(oldOrigin.y, [self imageViewAOriginalSize].width - cropRegion.size.height - oldOrigin.x);
                    
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
    
    // old code:
//    cropRegion.origin.x = [[self scrollViewA] contentOffset].x / scrollViewCurrentZoom;
//    cropRegion.origin.y = [[self scrollViewA] contentOffset].y / scrollViewCurrentZoom;
//    cropRegion.size.width = [self imageViewAOriginalSize].width * (scrollViewMinimumZoom / scrollViewCurrentZoom);
//    cropRegion.size.height = [self imageViewAOriginalSize].height * (scrollViewMinimumZoom / scrollViewCurrentZoom);
    
    NSLog(@"   %@", CGRectCreateDictionaryRepresentation(cropRegion));
    
    // Crop the image using CGImageCreateWithImageInRect
    CGImageRef croppedImageRef = CGImageCreateWithImageInRect(image, cropRegion);
    
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
        return;
    }
    
//    // Lock the ScrollViews
//    [self lockScrollViewForImage:PostLayoutImageA];
//    [self lockScrollViewForImage:PostLayoutImageB];
//    
//    // Disable tap gesture recognizers
//    [[self tapScrollViewARecognizer] setEnabled:NO];
//    [[self tapScrollViewBRecognizer] setEnabled:NO];
    
    ////// A temporary way to check how the images look when they are off of the phone -- this code sends the
    // image to a .php file with the following lines:
    /*
     <?php
     if(move_uploaded_file($_FILES["image"]["tmp_name"], "./".$_FILES["image"]["name"]))
         printf("OK");
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
    [formData appendPartWithFileData:UIImageJPEGRepresentation(croppedImage, 0.8) // 0.8 out of 1 is the quality
                                name:@"image"
                            fileName:@"image.jpg"
                            mimeType:@"image/jpeg"];
}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"Upload success!!");
              
              // Turn off network indicator
              [[UserInfo user] setNetworkActivityIndicatorVisible:NO];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"%@", error);
              
              // Turn off network indicator
              [[UserInfo user] setNetworkActivityIndicatorVisible:NO];
          }];
}

// For iOS7's UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Quit"])
    {
        // Show the Feed
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
        
        // Set constraints
        [[self scrollViewContainer] layoutIfNeeded];
        [UIView animateWithDuration:0.3
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
                         }
                         completion:^(BOOL completed) {
                             // Update zoom
                             [self updateMinimumZoomScaleForImage:PostLayoutImageA];
                         }];
    }
}

- (IBAction)pressedLeftRightLayoutButton:(id)sender
{
    // Change the layout
    if(layoutState != LAYOUTSTATE_LEFT_RIGHT)
    {
        // Change state
        layoutState = LAYOUTSTATE_LEFT_RIGHT;
        
        // Set constraints
        [[self scrollViewContainer] layoutIfNeeded];
        [UIView animateWithDuration:0.3
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
                         }
                         completion:^(BOOL completed) {
                             // Update zooms
                             [self updateMinimumZoomScaleForImage:PostLayoutImageA];
                             [self updateMinimumZoomScaleForImage:PostLayoutImageB];
                         }];
    }
}

- (IBAction)pressedTopBottomLayoutButton:(id)sender
{
    // Change the layout
    if(layoutState != LAYOUTSTATE_TOP_BOTTOM)
    {
        // Change state
        layoutState = LAYOUTSTATE_TOP_BOTTOM;
        
        // Set constraints
        [[self scrollViewContainer] layoutIfNeeded];
        [UIView animateWithDuration:0.3
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
                         }
                         completion:^(BOOL completed) {
                             // Update zooms
                             [self updateMinimumZoomScaleForImage:PostLayoutImageA];
                             [self updateMinimumZoomScaleForImage:PostLayoutImageB];
                         }];
    }
}
@end
