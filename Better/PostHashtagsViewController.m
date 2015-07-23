//
//  PostHashtagsViewController.m
//  Better
//
//  Created by Peter on 7/8/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "PostHashtagsViewController.h"

@interface PostHashtagsViewController ()
{
    // Is the system iOS 8 or above?
    BOOL isIOS8OrAbove;
    
    // A dummy BELabel that mimics the one within each HashtagCell -> used for sizing the cells
    BELabel *dummyHashtagLabel;
    
    // The height of one line of the above dummy label (for use with the lower collection view in determining
    // a cell's height (same for all cells)
    CGFloat hashtagLabelOneLineHeight;
}

// Array of pairs of strings and BOOLs, loaded from SuggestedTags.plist.
@property (strong, nonatomic) NSArray *suggestedTags;

// Array of currently-selected tags (NSStrings), presented by the upper collectionview (selectedTagsCollectionView)
@property (strong, nonatomic) NSMutableArray *selectedTags;

// Returns whether or not we can add another hashtag to the selectedTags array
- (BOOL)canAddNewHashtag;

// Returns whether or not we can add another hashtag to the selectedTags array
- (BOOL)addNewSelectedHashtag:(NSString *)hashtag;

// test
- (void)uploadImageA:(UIImage *)imageA imageB:(UIImage *)imageB;

@end

@implementation PostHashtagsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Get the system version (used for the collectionviews)
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
        isIOS8OrAbove = TRUE;
    else
        isIOS8OrAbove = FALSE;
    
    // Set background colors
    [[self view] setBackgroundColor:COLOR_LIGHT_LIGHT_GRAY];
    [[self suggestedTagsCollectionView] setBackgroundColor:[UIColor clearColor]];
    
    // Set up first label (Tap to add tags...)
    [[self addTagsLabel] setEmphasized:YES];
    
    // Set the delegate of the Add Tags button to this object
    [[self addTagButton] setDelegate:self];
    
    // Create a dummy BELabel (the only attribute that it needs is a font size of 15 pt)
    dummyHashtagLabel = [[BELabel alloc] init];
    [dummyHashtagLabel setFont:[UIFont fontWithName:FONT_RALEWAY_MEDIUM size:FONT_SIZE_HASHTAG_ADDING_TAGS]];
    
    // Load the suggested tags plist
    NSDictionary *suggestedTagsPlistContents = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SuggestedTags" ofType:@"plist"]];
    
    // Retrieve the "Tags" array from the plist
    NSArray *suggestedTagsArray = [suggestedTagsPlistContents objectForKey:@"Tags"];
    
    // Loop through the array and create SuggestedTagPair structs for each suggested tag
    NSMutableArray *arrayToSave = [[NSMutableArray alloc] initWithCapacity:[suggestedTagsArray count]];
    for(NSString *hashtag in suggestedTagsArray)
    {
        // Create a SuggestedTag and add it to the mutable array
        SuggestedTag *hashtagPair = [[SuggestedTag alloc] initWithHashtag:hashtag selected:NO];
        [arrayToSave addObject:hashtagPair];
    }
    
    // Save this new array of SuggestedTags
    _suggestedTags = [NSArray arrayWithArray:arrayToSave];
    
    // Add the two hashtags from the previous viewcontroller to the selectedTags array
    _selectedTags = [[NSMutableArray alloc] initWithObjects:[self hotspotAHashtag], [self hotspotBHashtag], nil];
    
    // Set collection view datasources and delegates to this object
    [[self selectedTagsCollectionView] setDataSource:self];
    [[self selectedTagsCollectionView] setDelegate:self];
    [[self suggestedTagsCollectionView] setDataSource:self];
    [[self suggestedTagsCollectionView] setDelegate:self];
    
    // Register nib files for the selected tags collection view (needs both types)
    [[self selectedTagsCollectionView] registerNib:[UINib nibWithNibName:NIB_NAME_HASHTAG_COLLECTION_CELL_NO_DELETE bundle:[NSBundle mainBundle]]
                        forCellWithReuseIdentifier:REUSE_ID_HASHTAG_COLLECTION_CELL_NO_DELETE];
    [[self selectedTagsCollectionView] registerNib:[UINib nibWithNibName:NIB_NAME_HASHTAG_COLLECTION_CELL_DELETABLE bundle:[NSBundle mainBundle]]
                        forCellWithReuseIdentifier:REUSE_ID_HASHTAG_COLLECTION_CELL_DELETABLE];
    
    // Register nib file for the available tags collection view (needs the non-deletable type)
    [[self suggestedTagsCollectionView] registerNib:[UINib nibWithNibName:NIB_NAME_HASHTAG_COLLECTION_CELL_NO_DELETE bundle:[NSBundle mainBundle]]
                         forCellWithReuseIdentifier:REUSE_ID_HASHTAG_COLLECTION_CELL_NO_DELETE];
    
    // Layout
    [[self selectedTagsCollectionView] setCollectionViewLayout:[[SelectedHashtagsFlowLayout alloc] init]];
    
    NSLog(@"coord A: (%.1f,%.1f)", [self hotspotACoordinate].x, [self hotspotACoordinate].y);
    NSLog(@"coord B: (%.1f,%.1f)", [self hotspotBCoordinate].x, [self hotspotBCoordinate].y);
    NSLog(@"hashtag A: %@", [self hotspotAHashtag]);
    NSLog(@"hashtag B: %@", [self hotspotBHashtag]);
    NSLog(@"layout: %i", [self imageLayout]);
}

// After layout has been done
- (void)viewDidLayoutSubviews
{
    // Call super
    [super viewDidLayoutSubviews];
    
    // Set up the top label (tap to add tags...)
    [[self addTagsLabel] setPreferredMaxLayoutWidth:CGRectGetWidth([[self addTagsLabel] bounds])];
    
    // Set up the one-line height of a hashtag label (using dummy label)
    [dummyHashtagLabel setText:@"abc"];
    hashtagLabelOneLineHeight = [dummyHashtagLabel intrinsicContentSize].height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Button handling
// Called when user presses "Tap to Add Tags" button
- (IBAction)pressedAddTagButton:(id)sender
{
    // Show the hashtag entry textfield
    if(![[self addTagButton] isFirstResponder])
        [[self addTagButton] becomeFirstResponder];
}

// Called when user presses "Post Your Question"
- (IBAction)pressedPostButton:(id)sender
{
    // test upload
    if([self imageA] != nil)
        [self uploadImageA:_imageA imageB:_imageB];
}

#pragma mark - BEAddTagButtonDelegate method
// Called when the user is done entering their custom hashtag
- (void)addTagButton:(BEAddTagButton *)button finishedNewHashtag:(NSString *)hashtagString
{
    // Clear out the current text in the textfield
    [button setHashtagString:@"#"];
    
    // If the hashtag is valid, add it to the tags list
    if(![hashtagString isEqualToString:@"#"] && ![hashtagString isEqualToString:@""])
        [self addNewSelectedHashtag:[hashtagString substringFromIndex:1]];
}

#pragma mark - UICollectionViewDataSource methods
// Return a new cell for the collection views to use
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Resize to fit contents
    [[self selectedTagsCollectionViewHeight] setConstant:[[self selectedTagsCollectionView] contentSize].height];
    
    // Upper collection view (selected hashtags -- mix of non-deletable and deletable)
    if(collectionView == [self selectedTagsCollectionView])
    {
        // First two cells are from the previous viewcontroller
        if([indexPath item] == 0 || [indexPath item] == 1)
        {
            // Dequeue a cell and return it
            HashtagCellNoDelete *cell = (HashtagCellNoDelete *)[collectionView dequeueReusableCellWithReuseIdentifier:REUSE_ID_HASHTAG_COLLECTION_CELL_NO_DELETE forIndexPath:indexPath];
            
            // Call willDisplayCell for ios 7
            if(!isIOS8OrAbove)
                [self collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
            
            return cell;
        }
        else // Deletable (user-specified or suggested) hashtags
        {
            // Dequeue a cell and return it
            HashtagCellDeletable *cell = (HashtagCellDeletable *)[collectionView dequeueReusableCellWithReuseIdentifier:REUSE_ID_HASHTAG_COLLECTION_CELL_DELETABLE forIndexPath:indexPath];
            
            // Sets its delegate to this object (so we can be notified when the user presses the "X" button
            // on this cell)
            [cell setDelegate:self];
            
            // Call willDisplayCell for ios 7
            if(!isIOS8OrAbove)
                [self collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
            
            return cell;
        }
    }
    // Lower collection view (only non-deletable cells -- suggested hashtags)
    else if(collectionView == [self suggestedTagsCollectionView])
    {
        // Dequeue a cell and return it
        HashtagCellNoDelete *cell = (HashtagCellNoDelete *)[collectionView dequeueReusableCellWithReuseIdentifier:REUSE_ID_HASHTAG_COLLECTION_CELL_NO_DELETE forIndexPath:indexPath];
        
        // Call willDisplayCell for ios 7
        if(!isIOS8OrAbove)
            [self collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
        
        return cell;
    }
    else
        return nil;
}

// How many cells there are in a section
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // Upper collection view (selected tags)
    if(collectionView == [self selectedTagsCollectionView])
        return [[self selectedTags] count];
    
    else if(collectionView == [self suggestedTagsCollectionView])
        return [[self suggestedTags] count];
    
    else
        return 0;
}

// How many sections per collection view
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    // One section only for both
    return 1;
}

#pragma mark - UICollectionViewDelegate methods
// Called when a cell is about to appear, which is when we configure it -- but, this is not available in iOS 7
// so for that OS, we call a method that both systems can use
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Selected tags collectionview
    if(collectionView == [self selectedTagsCollectionView])
    {
        // First two are non-delete, rest are delete
        if([indexPath item] == 0 || [indexPath item] == 1)
        {
            // Cast to correct type of cell
            HashtagCellNoDelete *thisCell = (HashtagCellNoDelete *)cell;
            
            // Set the hashtag text to the corresponding selected/current tag
            NSString *hashtagString = [@"#" stringByAppendingString:[[self selectedTags] objectAtIndex:[indexPath item]]];
            
            // Make the "#" a light gray
            NSMutableAttributedString *hashtagStringAttributed = [[NSMutableAttributedString alloc] initWithString:hashtagString];
            NSRange firstCharRange = {0, 1};
            [hashtagStringAttributed addAttribute:NSForegroundColorAttributeName value:COLOR_CREATEPOST_HASH_CHARACTER range:firstCharRange];
            
            // Apply the text
            [[thisCell hashtagLabel] setAttributedText:hashtagStringAttributed];
        }
        else // Deletable cells
        {
            // Cast to a deletable cell
            HashtagCellDeletable *thisCell = (HashtagCellDeletable *)cell;
            
            // Set background color and radius
            [thisCell setBackgroundColor:COLOR_BETTER_DARK];
            [[thisCell layer] setCornerRadius:(CGRectGetHeight([thisCell bounds]) / 2)];
            
            // Set the hashtag text to the corresponding selected/current tag
            NSString *hashtagString = [@"#" stringByAppendingString:[[self selectedTags] objectAtIndex:[indexPath item]]];
            
            // Make the "#" a light gray
            NSMutableAttributedString *hashtagStringAttributed = [[NSMutableAttributedString alloc] initWithString:hashtagString];
            NSRange firstCharRange = {0, 1};
            [hashtagStringAttributed addAttribute:NSForegroundColorAttributeName value:COLOR_CREATEPOST_HASH_CHARACTER range:firstCharRange];
            
            // Apply the text
            [[thisCell hashtagLabel] setAttributedText:hashtagStringAttributed];
        }
    }
    // Available tags collectionview
    else if(collectionView == [self suggestedTagsCollectionView])
    {
        // All are non-delete
        HashtagCellNoDelete *thisCell = (HashtagCellNoDelete *)cell;
        
        // Set the hashtag text to a suggested tag
        SuggestedTag *thisTag = [[self suggestedTags] objectAtIndex:[indexPath item]];
        NSString *hashtagString = [@"#" stringByAppendingString:[thisTag hashtag]];
        
        // Make the "#" a light gray, and the hashtag a light gray also IF it has been selected
        NSMutableAttributedString *hashtagStringAttributed = [[NSMutableAttributedString alloc] initWithString:hashtagString];
        NSRange firstCharRange = {0, 1};
        [hashtagStringAttributed addAttribute:NSForegroundColorAttributeName value:COLOR_CREATEPOST_HASH_CHARACTER range:firstCharRange];
        
        // If the tag has been selected
        if([thisTag isSelected])
        {
            // Color the whole hashtag a gray color
            NSRange wholeRange = {0, [hashtagString length]};
            [hashtagStringAttributed addAttribute:NSForegroundColorAttributeName value:COLOR_CREATEPOST_HASH_CHARACTER range:wholeRange];
        }
        
        // Apply the text
        [[thisCell hashtagLabel] setAttributedText:hashtagStringAttributed];
    }
    
//    // Resize to fit contents
//    [[self selectedTagsCollectionViewHeight] setConstant:[[self selectedTagsCollectionView] contentSize].height];
//    [[self view] layoutIfNeeded];
}

// Called when the user taps on a cell in a collectionview
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Retrieve the correct SuggestedTag object
    SuggestedTag *thisTag = [[self suggestedTags] objectAtIndex:[indexPath item]];
    
    // Add this tag to the selected tags array if possible
    if([self addNewSelectedHashtag:[thisTag hashtag]])
    {
        [thisTag setSelected:YES]; // Mark this hashtag as 'selected' in _suggestedTags
        [[self suggestedTagsCollectionView] reloadItemsAtIndexPaths:@[indexPath]];
    }
}

// Called when the user taps on a cell in a collectionview, but before -didSelectItemAtIndexPath...
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Lower collection view only (suggested tags)
    if(collectionView == [self suggestedTagsCollectionView])
    {
        // Retrieve the correct SuggestedTag object
        SuggestedTag *thisTag = [[self suggestedTags] objectAtIndex:[indexPath item]];
        
        // Don't proceed if this hashtag has already been selected
        if([thisTag isSelected] || ![self canAddNewHashtag])
            return FALSE;
        else
            return TRUE;
    }
    else if(collectionView == [self selectedTagsCollectionView]) // Upper collection view
        return FALSE;
    else
        return TRUE;
}

// Always return FALSE --> no highlighting or menus
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Same behavior as -shouldSelectItem
    return [self collectionView:collectionView shouldSelectItemAtIndexPath:indexPath];
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return FALSE;
}

#pragma mark - UICollectionViewDelegateFlowLayout methods
#define TAG_EXTRA_HEIGHT 12
#define TAG_EXTRA_WIDTH 8
#define HORIZONTAL_SPACE_LABEL_DELETEBUTTON 0
// Size for an individual cell
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Selected tags (upper collection view)
    if(collectionView == [self selectedTagsCollectionView])
    {
        // Set the dummy label to the real cell's text, then return the intrinsic content size of the dummy label
        NSString *hashtagString = [@"#" stringByAppendingString:[[self selectedTags] objectAtIndex:[indexPath item]]];
        [dummyHashtagLabel setText:hashtagString];
        
        if([indexPath item] == 0 || [indexPath item] == 1) // Non-deletable tags
        {
            CGSize itemSize;
            itemSize.width = [dummyHashtagLabel intrinsicContentSize].width;
            itemSize.height = [dummyHashtagLabel intrinsicContentSize].height + TAG_EXTRA_HEIGHT;
            
            return itemSize;
        }
        else // Deletable tags
        {
            CGSize itemSize;
            itemSize.width = [dummyHashtagLabel intrinsicContentSize].width + [dummyHashtagLabel intrinsicContentSize].height + TAG_EXTRA_WIDTH + TAG_EXTRA_HEIGHT;
            itemSize.height = [dummyHashtagLabel intrinsicContentSize].height + TAG_EXTRA_HEIGHT;
            
            return itemSize;
        }
    }
    // Lower collection view
    else if(collectionView == [self suggestedTagsCollectionView])
    {
        CGSize itemSize;
        itemSize.width = (CGRectGetWidth([collectionView bounds]) - 2*8 - 2*16) / 3;
        itemSize.height = hashtagLabelOneLineHeight + TAG_EXTRA_HEIGHT;
        
        //CGRectGetHeight([collectionView bounds]) / ([[self suggestedTags] count] / 3) / 1.5;
        
        return itemSize;
    }
    else
        return CGSizeZero;
}

// Insets for a section
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets insets;
    
    if(collectionView == [self selectedTagsCollectionView])
        insets = EDGEINSETS_SELECTED_TAGS_COLLECTIONVIEW;
    
    else if(collectionView == [self suggestedTagsCollectionView])
        insets = EDGEINSETS_SUGGESTED_TAGS_COLLECTIONVIEW;
    
    return insets;
}

// Minimum inter-item spacing
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return MINIMUM_INTERITEM_SPACING_SELECTED_TAGS_COLLECTIONVIEW;
}

// Minimum line spacing
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return MINIMUM_INTERITEM_SPACING_SELECTED_TAGS_COLLECTIONVIEW;
}

#pragma mark - HashtagCellDeletableDelegate method
// Called when a deletable hashtag cell has its "X" button pressed
- (void)deleteButtonWasPressedForHashtagCell:(HashtagCellDeletable *)cell
{
    // Remove the corresponding item from the `selectedTags` array -- first find the index of the string
    // to remove
    NSString *hashtagString = [[[cell hashtagLabel] text] substringFromIndex:1]; // Remove "#" at front
    NSUInteger indexToRemove = [[self selectedTags] indexOfObject:hashtagString];
    
    // Remove it
    [[self selectedTags] removeObjectAtIndex:indexToRemove];
    
    // Search through the suggested tags to check if we just removed a suggested tag
    for(unsigned int i = 0; i < [[self suggestedTags] count]; i++)
    {
        SuggestedTag *tag = [[self suggestedTags] objectAtIndex:i];
        
        // Found a match (deleted a suggested string)
        if([hashtagString isEqualToString:[tag hashtag]])
        {
            // De-select the tag and reload it
            [tag setSelected:NO];
            [[self suggestedTagsCollectionView] reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
            
            // Stop loop
            break;
        }
    }
    
    // Re-enable the add tags button if possible
    if([self canAddNewHashtag])
    {
        [[self addTagButton] setTitle:@"TAP TO ADD TAGS" forState:UIControlStateNormal];
        [[self addTagButton] setEnabled:YES];
    }
    
    // Reload the selected tags collectionview
    [[self selectedTagsCollectionView] reloadData];
    
    // Resize to fit contents
    [[self selectedTagsCollectionViewHeight] setConstant:[[self selectedTagsCollectionView] contentSize].height];
    [[self view] layoutIfNeeded];
}

#pragma mark - Hashtag management
// Returns TRUE if there is space for another tag in the list of hashtags
- (BOOL)canAddNewHashtag
{
    if([[self selectedTags] count] < MAX_NUMBER_OF_HASHTAGS)
        return TRUE;
    else
        return FALSE;
}

// Returns TRUE if there is space for another tag in the list of hashtags
- (BOOL)addNewSelectedHashtag:(NSString *)hashtag
{
    // Don't add if the tag is already there
    for(NSString *tag in [self selectedTags])
    {
        if([tag isEqualToString:hashtag])
            return FALSE;
    }
    
    // Also check if there is enough space for another hashtag
    if([[self selectedTags] count] < MAX_NUMBER_OF_HASHTAGS)
    {
        // Add new hashtag to selectedTags
        [[self selectedTags] addObject:hashtag];
        
        // Disable the Add Tags button if there are enough tags already
        if([[self selectedTags] count] >= MAX_NUMBER_OF_HASHTAGS)
        {
            [[self addTagButton] setTitle:@"YOU HAVE REACHED THE MAX # OF TAGS" forState:UIControlStateNormal];
            [[self addTagButton] setEnabled:NO];
        }
        
        // Reload the selected tags collectionview
        [[self selectedTagsCollectionView] reloadData];
        
        // Resize to fit contents
        [[self selectedTagsCollectionViewHeight] setConstant:[[self selectedTagsCollectionView] contentSize].height];
        [[self view] layoutIfNeeded];
        
        return TRUE;
    }
    else
        return FALSE;
}

#pragma mark - Upload test
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
              
              // Dismiss
              [self dismissViewControllerAnimated:YES completion:nil];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"**!!** Network error! %@", error);
              
              // Turn off network indicator
              [[UserInfo user] setNetworkActivityIndicatorVisible:NO];
          }];
}

@end
