//
//  BEPostingHotspotView.m
//  Better
//
//  Created by Peter on 7/17/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "BEPostingHotspotView.h"

@interface BEPostingHotspotView ()

// The input accessory view (redeclaring from UIResponder.h as read/write)
@property (retain, nonatomic, readwrite) UIView *inputAccessoryView;

// TextField that is stored here and returned as the inputAccessoryView
@property (strong, nonatomic) BETextField *hashtagTextField;

// Common initialization
- (void)commonInit;

@end

@implementation BEPostingHotspotView

#pragma mark - Initialization overriding

// Programmatic initialization
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        // Common init
        [self commonInit];
    }
    
    return self;
}

// Image init
- (instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if(self)
    {
        // Common init
        [self commonInit];
    }
    
    return self;
}

// Image init highlighted
- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    self = [super initWithImage:image highlightedImage:highlightedImage];
    if(self)
    {
        // Common init
        [self commonInit];
    }
    
    return self;
}

// Initialization common to all inits
- (void)commonInit
{
    // Initialize hashtag string
    _hashtagString = @"#";
}

#pragma mark - UIResponder overriding
// We want to be able to become and resign first responder
- (BOOL)canBecomeFirstResponder
{
    return TRUE;
}
- (BOOL)canResignFirstResponder
{
    return TRUE;
}

// Override -becomeFirstResponder and -resignFirstResponder to hand off the first responder status to the
// inputAccessoryView
- (BOOL)becomeFirstResponder
{
    // Make ourselves the responder first
    [super becomeFirstResponder]; // Don't call [self becomeFirstResponder] --> infinite loop!!
    
    // Prefill the hashtag text (set by another object)
    if([self hashtagTextField])
        [[self hashtagTextField] setText:[self hashtagString]];
    
    // Now make the textfield the responder
    return [[self inputAccessoryView] becomeFirstResponder];
}
- (BOOL)resignFirstResponder
{
    // Resign first responder on the textfield
    [[self inputAccessoryView] resignFirstResponder];
    
    // Resign ourselves as first responder
    return [super resignFirstResponder];
}

// Override -isFirstResponder to be a "proxy" for isFirstResponder for the input accessory textfield
- (BOOL)isFirstResponder
{
    // Is this object or the textfield input accessory view the first responder?
    return ([super isFirstResponder] || [[self hashtagTextField] isFirstResponder]);
}

#pragma mark - Input accessory view
// Provides an inputAccessoryView to show above the keyboard
- (UIView *)inputAccessoryView
{
    // This method can be tricky -- if you refer to inputAccessoryView in this method as [self inputAccessoryView],
    // the method calls itself forever and crashes the app. Referring to inputAccessoryView as _inputAccessoryView,
    // however, doesn't have this problem --> so, we're going to try to avoid referring to inputAccessoryView as much
    // as possible.
    if(![self hashtagTextField])
    {
        // Create a new textfield if necessary
        _hashtagTextField = [[BETextField alloc] init];
        [[self hashtagTextField] setTranslatesAutoresizingMaskIntoConstraints:NO]; // Use our own constraints
        [[self hashtagTextField] setDelegate:self]; // Get UITextFieldDelegate methods
        [[self hashtagTextField] setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.9]];
        [[self hashtagTextField] setTintColor:COLOR_BETTER_DARK]; // Color of cursor and selections
        
        // Set keyboard properties
        [[self hashtagTextField] setReturnKeyType:UIReturnKeyDone]; // "Done" button
        [[self hashtagTextField] setSpellCheckingType:UITextSpellCheckingTypeNo]; // No spell-check
        [[self hashtagTextField] setAutocorrectionType:UITextAutocorrectionTypeNo]; // No autocorrect
        [[self hashtagTextField] setKeyboardType:UIKeyboardTypeASCIICapable]; // No emojis
        
        // Assign a height constraint
        NSLayoutConstraint *textFieldHeight = [NSLayoutConstraint constraintWithItem:[self hashtagTextField]
                                                                           attribute:NSLayoutAttributeHeight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1 constant:HEIGHT_BETEXTFIELD];
        // Assign a width constraint
        NSLayoutConstraint *textFieldWidth = [NSLayoutConstraint constraintWithItem:[self hashtagTextField]
                                                                          attribute:NSLayoutAttributeWidth
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1 constant:CGRectGetWidth([[UIScreen mainScreen] bounds])];
 
        // Add the constraints
        [[self hashtagTextField] addConstraint:textFieldHeight];
        [[self hashtagTextField] addConstraint:textFieldWidth];
    }
    
    // Return the BETextField
    return [self hashtagTextField];
}

#pragma mark - Custom setter for hashtag
- (void)setHashtagString:(NSString *)hashtagString
{
    // Save the given hashtag string
    _hashtagString = hashtagString;
    
    // If the input accessory view textfield is not nil, apply the string to it
    if(_inputAccessoryView)
        [[self hashtagTextField] setText:[self hashtagString]];
    
    // Set image depending on empty/non-blank hashtag string
    if(hashtagString == nil || [hashtagString isEqualToString:@"#"])
        [self setImage:[UIImage imageNamed:IMAGE_POSTING_HOTSPOT_UNTAGGED]];
    else // Non-empty
        [self setImage:[UIImage imageNamed:IMAGE_POSTING_HOTSPOT_TAGGED]];
}

#pragma mark - UITextFieldDelegate methods
// Called when editing is finished (resigning first responder)
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // Save the hashtag in this object
    [self setHashtagString:[textField text]];
    
    // Set image depending on empty/non-blank hashtag string
    if([textField text] == nil || [[textField text] isEqualToString:@"#"])
        [self setImage:[UIImage imageNamed:IMAGE_POSTING_HOTSPOT_UNTAGGED]];
    else // Non-empty
        [self setImage:[UIImage imageNamed:IMAGE_POSTING_HOTSPOT_TAGGED]];
}

// Called when Return/Done button is pressed on keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Dismiss ourselves
    [self resignFirstResponder];
    
    return TRUE;
}

// Called every time the user types or deletes a character; or pastes or deletes a selected range of text
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Enforce a maximum character limit
    NSUInteger newLength = [[textField text] length] + [string length] - range.length;
    if(newLength > MAX_LENGTH_HASHTAG)
        return FALSE;
    
    // No spaces
    if([string isEqualToString:@" "])
        return FALSE;
    
    // Also, we want to keep the user from deleting the first character ("#")
    if(range.location == 0) // Starts with first char
    {
        if(range.length == 0 || range.length == 1) // User is changing only the first character (e.g. deleting it)
            return FALSE; // Forbidden!! >:-O
        else if(range.length > 1) // User has selected a bunch of text, including the first char
        {
            // Create new range, starting at index 1
            NSRange newRange = range;
            newRange.location = 1;
            newRange.length -= 1;
            
            // If the range is out of bounds, the app crashes, so prevent this operation from going through if
            // the range is not in bounds
            if(newRange.location + newRange.length > [[textField text] length])
                return FALSE;
            
            // Create new string that contains the "#" but not the other selected characters
            NSString *newString = [[textField text] stringByReplacingCharactersInRange:newRange withString:@""];
            [textField setText:newString];
            
            return FALSE;
        }
    }
    
    // OK, you're fine
    return TRUE;
}

@end
