//
//  PostLayoutViewController.m
//  Better
//
//  Created by Peter on 7/8/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "PostLayoutViewController.h"

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
}

// Images to display within the UIScrollViews
@property (strong, nonatomic) UIImageView *imageViewA;
@property (strong, nonatomic) UIImageView *imageViewB;

// CGSizes to remember what the original sizes of the UIImageViews are when taken from the image picker, because
// when they are added to the scrollview, the scrollview changes its frame size to whatever it wants to, and
// we lose track of what the scrollview's original content size should be
@property (nonatomic) CGSize imageViewAOriginalSize;
@property (nonatomic) CGSize imageViewBOriginalSize;

// Keep a scrollview's subview centered when zooming out
- (void)keepSubviewCenteredInScrollView:(UIScrollView *)scrollView;

// Update the minimum zoom scale for a given image (either A or B)
- (void)updateMinimumZoomScaleForImage:(PostLayoutImage)image;

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
    
    // Set up the navigation bar for Create Post area
    [[[self navigationController] navigationBar] setBarTintColor:COLOR_BETTER_DARK];
    [[[self navigationController] navigationBar] setTintColor:[UIColor whiteColor]];
    [[[self navigationController] navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:FONT_RALEWAY_SEMIBOLD size:FONT_SIZE_NAVIGATION_BAR]}];
    [[[self navigationController] navigationBar] setTranslucent:NO];
    
    // Set up image ScrollViews
    [[self scrollViewA] setDelegate:self];
    [[self scrollViewA] setBounces:NO];
    [[self scrollViewA] setMaximumZoomScale:5];
    
    [[self scrollViewB] setDelegate:self];
    [[self scrollViewB] setBounces:NO];
    [[self scrollViewB] setMaximumZoomScale:5];
    
    // Show image picker
    [self showImagePicker];
}

- (void)showImagePicker
{
    // Create an image picker
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // Make this PostLayoutViewController the delegate of the ImagePickerController to get the image it captures/
    // retrieves
    [imagePicker setDelegate:self];
    
    // If camera is available, use it; otherwise, open up the saved photos list
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePicker setShowsCameraControls:YES];
    }
    else // No camera
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    // More properties
    [imagePicker setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [imagePicker setAllowsEditing:YES];
    
    // Present the image picker
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)viewDidLayoutSubviews
{
    // Call super
    [super viewDidLayoutSubviews];
    
    // Set up the correct constants for the ScrollViews
    [[self scrollViewATrailing] setConstant:0]; // Show entire image A
    [[self scrollViewBLeading] setConstant:CGRectGetWidth([[self scrollViewContainer] frame])]; // Hide image B
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
    UIImage *capturedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
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
            
            break;
        }
        case TARGETIMAGE_B: // Choosing image B
        {
            // Remove previous UIImageView from the UIScrollView, if necessary
            if([self imageViewB])
            {
                [[self imageViewA] removeFromSuperview];
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
            
            break;
        }
        default:
            break;
    }

    // Dismiss the image picker
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Image picker finished picking image");
    }];
}

// Called when the image picker is cancelled
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // Dismiss the image picker
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Image picker cancelled");
    }];
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
    
    // Select the correct ScrollView and ImageView
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
    switch(layoutState)
    {
        case LAYOUTSTATE_A_ONLY:
            [scrollView setMinimumZoomScale:fminf(minZoomScaleHorizontal, minZoomScaleVertical)];
            break;
            
        case LAYOUTSTATE_LEFT_RIGHT:
            [scrollView setMinimumZoomScale:minZoomScaleVertical];
            break;
            
        case LAYOUTSTATE_TOP_BOTTOM:
            [scrollView setMinimumZoomScale:minZoomScaleHorizontal];
            break;
            
        default:
            break;
    }
    
    NSLog(@"min zoom scale: %.2f", [scrollView minimumZoomScale]);
    [scrollView setZoomScale:[scrollView minimumZoomScale] animated:YES];
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
