//
//  PostLayoutViewController.m
//  Better
//
//  Created by Peter on 7/8/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "PostLayoutViewController.h"

@interface PostLayoutViewController ()

// Images to display within the UIScrollViews
@property (strong, nonatomic) UIImageView *imageA;
@property (strong, nonatomic) UIImageView *imageB;

@end

@implementation PostLayoutViewController

#pragma mark - Initialization, setup
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set up the navigation bar for Create Post area
    [[[self navigationController] navigationBar] setBarTintColor:COLOR_BETTER_DARK];
    [[[self navigationController] navigationBar] setTintColor:[UIColor whiteColor]];
    [[[self navigationController] navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:FONT_RALEWAY_SEMIBOLD size:FONT_SIZE_NAVIGATION_BAR]}];
    [[[self navigationController] navigationBar] setTranslucent:NO];
    
    // Set up image ScrollViews
    [[self scrollViewA] setDelegate:self];
    [[self scrollViewA] setMinimumZoomScale:1];
    [[self scrollViewA] setMaximumZoomScale:5];
    
    [[self scrollViewB] setDelegate:self];
    [[self scrollViewB] setMinimumZoomScale:1];
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
    [[self scrollViewATrailing] setConstant:0];
    [[self scrollViewBLeading] setConstant:CGRectGetWidth([[[self scrollViewB] superview] frame])];
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
    UIImage *firstPostImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    // Save a UIImageView with this image
    [self setImageA:[[UIImageView alloc] initWithImage:firstPostImage]];
    
    // Put it in the scrollview
    [[self scrollViewA] addSubview:[self imageA]];
    [[self scrollViewA] setContentSize:[self imageA].frame.size];

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

#pragma mark - UIScrollViewDelegate methods
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    NSLog(@"viewforzooming");
    
    // Provide different imageviews based on `scrollView`
    if(scrollView == [self scrollViewA])
        return [self imageA];
    else if(scrollView == [self scrollViewB])
        return [self imageB];
    else
        return nil;
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

@end
