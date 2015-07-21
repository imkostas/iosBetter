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

// Array of suggested hashtags (NSStrings), loaded from SuggestedTags.plist
@property (strong, nonatomic) NSArray *suggestedTags;

// Array of currently-selected tags (NSStrings), presented by the upper collectionview (selectedTagsCollectionView)
@property (strong, nonatomic) NSMutableArray *selectedTags;

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
    
    // Create a dummy BELabel (the only attribute that it needs is a font size of 15 pt)
    dummyHashtagLabel = [[BELabel alloc] init];
    [dummyHashtagLabel setFont:[UIFont fontWithName:FONT_RALEWAY_MEDIUM size:FONT_SIZE_HASHTAG_ADDING_TAGS]];
    
    // Load the suggested tags plist
    NSDictionary *suggestedTagsPlistContents = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SuggestedTags" ofType:@"plist"]];
    // Retrieve the "Tags" array from the plist
    _suggestedTags = [suggestedTagsPlistContents objectForKey:@"Tags"];
    
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
    [[self selectedTags] addObject:@"123"];
    NSUInteger indexOfInsertedItem = [[self selectedTags] count] - 1;
    
    [[self selectedTagsCollectionView] insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:indexOfInsertedItem inSection:0]]];
}

// Called when user presses "Post Your Question"
- (IBAction)pressedPostButton:(id)sender
{
    
}

#pragma mark - UICollectionViewDataSource methods
// Return a new cell for the collection views to use
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Upper collection view (selected hashtags -- mix of non-deletable and deletable)
    if(collectionView == [self selectedTagsCollectionView])
    {
        // First two cells are from the previous viewcontroller
        if([indexPath item] == 0 || [indexPath item] == 1)
        {
            // Dequeue a cell and return it
            HashtagCellNoDelete *cell = (HashtagCellNoDelete *)[collectionView dequeueReusableCellWithReuseIdentifier:REUSE_ID_HASHTAG_COLLECTION_CELL_NO_DELETE forIndexPath:indexPath];
            
            return cell;
        }
        else // Deletable (user-specified or suggested) hashtags
        {
            // Dequeue a cell and return it
            HashtagCellDeletable *cell = (HashtagCellDeletable *)[collectionView dequeueReusableCellWithReuseIdentifier:REUSE_ID_HASHTAG_COLLECTION_CELL_DELETABLE forIndexPath:indexPath];
            
            // Sets its delegate to this object (so we can be notified when the user presses the "X" button
            // on this cell)
            [cell setDelegate:self];
            
            return cell;
        }
    }
    // Lower collection view (only non-deletable cells -- suggested hashtags)
    else if(collectionView == [self suggestedTagsCollectionView])
    {
        // Dequeue a cell and return it
        HashtagCellNoDelete *cell = (HashtagCellNoDelete *)[collectionView dequeueReusableCellWithReuseIdentifier:REUSE_ID_HASHTAG_COLLECTION_CELL_NO_DELETE forIndexPath:indexPath];
        
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
        NSString *hashtagString = [@"#" stringByAppendingString:[[self suggestedTags] objectAtIndex:[indexPath item]]];
        
        // Make the "#" a light gray
        NSMutableAttributedString *hashtagStringAttributed = [[NSMutableAttributedString alloc] initWithString:hashtagString];
        NSRange firstCharRange = {0, 1};
        [hashtagStringAttributed addAttribute:NSForegroundColorAttributeName value:COLOR_CREATEPOST_HASH_CHARACTER range:firstCharRange];
        
        // Apply the text
        [[thisCell hashtagLabel] setAttributedText:hashtagStringAttributed];
    }
    
    [[self selectedTagsCollectionViewHeight] setConstant:[[self selectedTagsCollectionView] contentSize].height];
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
    {
        insets.top = 16;
        insets.left = 16;
        insets.bottom = 16;
        insets.right = 16;
    }
    else if(collectionView == [self suggestedTagsCollectionView])
    {
        insets.top = 4;
        insets.left = 16;
        insets.bottom = 4;
        insets.right = 16;
    }
    
    return insets;
}

// Minimum inter-item spacing
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}

// Minimum line spacing
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
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
    
    // Reload the selected tags collectionview
    [[self selectedTagsCollectionView] deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:indexToRemove inSection:0]]];
}

@end
