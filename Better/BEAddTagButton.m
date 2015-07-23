//
//  BEAddTagButton.m
//  Better
//
//  Created by Peter on 7/22/15.
//  Copyright (c) 2015 Company. All rights reserved.
//
//  ** Most (if not all) of this code is copied from BEPostingHotspotView

#import "BEAddTagButton.h"

@interface BEAddTagButton ()
{
    CGRect savedTextFieldBounds;
}

// The input accessory view (redeclaring from UIResponder.h as read/write)
@property (retain, nonatomic, readwrite) UIView *inputAccessoryView;

// TextField that is stored here and returned as the inputAccessoryView
@property (strong, nonatomic) BETextField *hashtagTextField;

// Common initialization
- (void)commonInit;

// Called when the keyboard is going to reveal itself
- (void)keyboardWillShow:(NSNotification *)notification;

@end

@implementation BEAddTagButton

#pragma mark - Initialization

// Programmatic init
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

// Storyboard/xib init
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        // Common init
        [self commonInit];
    }
    
    return self;
}

// Common init
- (void)commonInit
{
    // Initialize hashtag string
    _hashtagString = @"#";
    
    // Register to be notified when the keyboard shows itself
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    // Create a new textfield if necessary
    _hashtagTextField = [[BETextField alloc] init];
    [[self hashtagTextField] setDelegate:self]; // Get UITextFieldDelegate methods
    [[self hashtagTextField] setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
    [[self hashtagTextField] setTintColor:COLOR_BETTER_DARK]; // Color of cursor and selections
    
    // Set keyboard properties
    [[self hashtagTextField] setReturnKeyType:UIReturnKeyDone]; // "Done" button
    [[self hashtagTextField] setSpellCheckingType:UITextSpellCheckingTypeNo]; // No spell-check
    [[self hashtagTextField] setAutocorrectionType:UITextAutocorrectionTypeNo]; // No autocorrect
    [[self hashtagTextField] setKeyboardType:UIKeyboardTypeASCIICapable]; // No emojis
    
    // Set bounds of the textfield (width is set later)
    CGRect textFieldBounds = CGRectMake(0, 0, 0, HEIGHT_BETEXTFIELD);
    [[self hashtagTextField] setBounds:textFieldBounds];
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
}

#pragma mark - UITextFieldDelegate methods
// Called when editing is finished (resigning first responder)
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // Save the hashtag in this object
    [self setHashtagString:[textField text]];
    
    // Tell delegate that the user is done typing their new hashtag
    if([self delegate])
        if([[self delegate] respondsToSelector:@selector(addTagButton:finishedNewHashtag:)])
            [[self delegate] addTagButton:self finishedNewHashtag:[self hashtagString]];
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

#pragma mark - Keyboard notification
// When keyboard is going to show
- (void)keyboardWillShow:(NSNotification *)notification
{
    // Get the ending frame
    CGRect endingFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // Set the textfield's bounds (correct width)
    CGRect newTextFieldBounds = [[self hashtagTextField] bounds];
    newTextFieldBounds.size.width = CGRectGetWidth(endingFrame);
    
    // Apply bounds
    [[self hashtagTextField] setBounds:newTextFieldBounds];
    
    // Remember the bounds so if they don't change, we don't re-apply the shadow/line
    if(!CGRectEqualToRect(savedTextFieldBounds, newTextFieldBounds))
    {
//        // Set up shadow
//        CGPathRef shadowPath = [[UIBezierPath bezierPathWithRect:[[self hashtagTextField] bounds]] CGPath];
//        CALayer *textFieldLayer = [[self hashtagTextField] layer];
//        [textFieldLayer setMasksToBounds:NO];
//        [textFieldLayer setShadowPath:shadowPath];
//        [textFieldLayer setShadowRadius:3];
//        [textFieldLayer setShadowOpacity:0.4];
//        [textFieldLayer setShadowOffset:CGSizeZero];
        
        // Draw a pixel thin border at the top of the TextField
        CGMutablePathRef topPath = CGPathCreateMutable();
        CGPathMoveToPoint(topPath, NULL, 0, 0);
        CGPathAddLineToPoint(topPath, NULL, CGRectGetWidth(endingFrame), 0);
        
        CALayer *textFieldLayer = [[self hashtagTextField] layer];
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        [lineLayer setPath:topPath];
        [lineLayer setStrokeColor:[[UIColor colorWithWhite:0.75 alpha:1.0] CGColor]];
        [textFieldLayer addSublayer:lineLayer];
        [textFieldLayer setRasterizationScale:[[UIScreen mainScreen] scale]];
        [textFieldLayer setShouldRasterize:YES];
        
        // Save the new bounds
        savedTextFieldBounds = newTextFieldBounds;
    }
}

#pragma mark - Dealloc
- (void)dealloc
{
    // Remove keyboard observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
