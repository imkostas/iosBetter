//
//  MyRanking.m
//  Better
//
//  Created by Peter on 6/18/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "MyRanking.h"

@interface MyRanking ()
{
	// Pointer to userinfo object
	UserInfo *user;
	
	// iOS 8 or above
	BOOL isIOS8OrAbove;
}

@end

@implementation MyRanking

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// Get iOS version
	if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
		isIOS8OrAbove = TRUE;
	else
		isIOS8OrAbove = FALSE;
	
	// Set up this view
	[[self view] setBackgroundColor:COLOR_LIGHT_LIGHT_GRAY];
	
	// Set up the profile area
	[[self profilePanel] setImage:[UIImage imageNamed:@"donkey"]];
	[[self profileImage] setImage:[UIImage imageNamed:@"donkey"]];
	[[[self profileImage] layer] setCornerRadius:CGRectGetWidth([[self profileImage] frame]) / 2];
	[[[self profileImage] layer] setMasksToBounds:YES];
	
	// Set up profile panel overlay
	[[self profilePanelOverlay] setBackgroundColor:COLOR_BETTER_DARK];
	[[self profilePanelOverlay] setAlpha:ALPHA_PROFILE_PANEL_OVERLAY];
	
	// Set up rank
	user = [UserInfo user];
	UserRank *userRank = [user rank];
	switch([userRank rank])
	{
		case RANK_NORANK:
			[[self rankLabel] setText:@""];
			[[self rankIcon] setImage:nil];
			break;
		case RANK_NOOB:
			[[self rankLabel] setText:@"Newbie"];
			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_NEWBIE_WHITE]];
			break;
		case RANK_MAINSTREAM:
			[[self rankLabel] setText:@"Mainstream"];
			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_MAINSTREAM_WHITE]];
			break;
		case RANK_TRAILBLAZER:
			[[self rankLabel] setText:@"Trailblazer"];
			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_TRAILBLAZER_WHITE]];
			break;
		case RANK_TRENDSETTER:
			[[self rankLabel] setText:@"Trendsetter"];
			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_TRENDSETTER_WHITE]];
			break;
		case RANK_CROWNED:
			[[self rankLabel] setText:@"Crowned"];
			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_CROWNED_WHITE]];
			break;
	}
	
	// Set up points label
	[[self pointsLabel] setText:[NSString stringWithFormat:@"%i", [userRank totalPoints]]];
	
	// Set up the RankBarView and crown
	[[self rankBar] setBackgroundColor:COLOR_LIGHT_LIGHT_GRAY];
	[[self crownIcon] setImage:[UIImage imageNamed:ICON_CROWN_UNFILLED]];
	
	// Fill in the rankbar according to rank
	if([userRank rank] >= RANK_NOOB)
		[[self rankBar] setFirstSegmentFilled:YES];
	if([userRank rank] >= RANK_MAINSTREAM)
		[[self rankBar] setSecondSegmentFilled:YES];
	if([userRank rank] >= RANK_TRAILBLAZER)
		[[self rankBar] setThirdSegmentFilled:YES];
	if([userRank rank] >= RANK_TRENDSETTER)
		[[self rankBar] setFourthSegmentFilled:YES];
	if([userRank rank] >= RANK_CROWNED)
	{
		[[self rankBar] setFifthSegmentFilled:YES];
		[[self crownIcon] setImage:[UIImage imageNamed:ICON_CROWN_FILLED]];
	}
	
	// Redraw the rankbar
	[[self rankBar] setNeedsDisplay];
	
	// Set up the badges collection:
	
	[[self badgesCollectionView] setDataSource:self];
	[[self badgesCollectionView] setDelegate:self];
	[[self badgesCollectionView] setBackgroundColor:COLOR_LIGHT_LIGHT_GRAY];
	
	  // Unlike a uitableview, this uicollectionview does not allow you to call -dequeue...... and get a cell
	  // without doing -registerNib: first, so we do this once in -viewDidLoad.
	  // It doesn't have the -dequeue method _without_ the ...forIndexPath: parameter like UITableview has
	[[self badgesCollectionView] registerNib:[UINib nibWithNibName:@"BadgesCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:REUSE_ID_BADGES_COLLECTION_CELL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView datasource methods
// Tell collection view how many badges there are
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return 6;
}

// Return the proper cell to the collection view for a given index path
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	// Get a custom cell, or initialize one if it hasn't been initialized yet
	BadgesCollectionViewCell *cell = (BadgesCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:REUSE_ID_BADGES_COLLECTION_CELL forIndexPath:indexPath];
	
	if(cell == nil) // Shouldn't happen because we called -registerNib: above, in -viewDidLoad
	{
		[collectionView registerNib:[UINib nibWithNibName:@"BadgesCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:REUSE_ID_BADGES_COLLECTION_CELL];
		cell = (BadgesCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:REUSE_ID_BADGES_COLLECTION_CELL forIndexPath:indexPath];
	}
	
	// For iOS 7. (see below)
	if(!isIOS8OrAbove)
        [self collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
	
	return cell;
}

#pragma mark - UICollectionView delegate methods
// Called when a cell is about to appear (we set its properties here)
// iOS 8 and later has this delegate method
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(BadgesCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the user's rank object
    UserRank *rank = [user rank];
    
    // Configure the cell depending on the user's rank and the badge
    // So many cases........ :-)
    switch([indexPath item])
    {
        case 0: // Admirer
        {
            // Set the badge title
            [[cell badgeTitle] setText:@"Admirer"];
            
            // Bronze/silver/gold levels
            switch([rank badgeAdmirer])
            {
                case 0:
                    [[cell badgeImage] setImage:[UIImage imageNamed:IMAGE_BADGE_DEFAULT]];
                    [[cell badgeStatus] setText:@""];
                    break;
                case 1:
                    [[cell badgeImage] setImage:[UIImage imageNamed:IMAGE_BADGE_ADMIRER_BRONZE]];
                    [[cell badgeStatus] setText:@"BRONZE"];
                    break;
                case 2:
                    [[cell badgeImage] setImage:[UIImage imageNamed:IMAGE_BADGE_ADMIRER_SILVER]];
                    [[cell badgeStatus] setText:@"SILVER"];
                    break;
                case 3:
                    [[cell badgeImage] setImage:[UIImage imageNamed:IMAGE_BADGE_ADMIRER_GOLD]];
                    [[cell badgeStatus] setText:@"GOLD"];
                    break;
            }
            break;
        }
        case 1: // Adventurer
        {
            // Set the badge title
            [[cell badgeTitle] setText:@"Adventurer"];
            
            // Bronze/silver/gold levels
            switch([rank badgeAdventurer])
            {
                case 0:
                    [[cell badgeImage] setImage:[UIImage imageNamed:IMAGE_BADGE_DEFAULT]];
                    [[cell badgeStatus] setText:@""];
                    break;
                case 1:
                    [[cell badgeImage] setImage:[UIImage imageNamed:IMAGE_BADGE_ADVENTURER_BRONZE]];
                    [[cell badgeStatus] setText:@"BRONZE"];
                    break;
                case 2:
                    [[cell badgeImage] setImage:[UIImage imageNamed:IMAGE_BADGE_ADVENTURER_SILVER]];
                    [[cell badgeStatus] setText:@"SILVER"];
                    break;
                case 3:
                    [[cell badgeImage] setImage:[UIImage imageNamed:IMAGE_BADGE_ADVENTURER_GOLD]];
                    [[cell badgeStatus] setText:@"GOLD"];
                    break;
            }
            break;
        }
        case 2: // Celebrity
        {
            // Set the badge title
            [[cell badgeTitle] setText:@"Celebrity"];
            
            // Bronze/silver/gold levels
            switch([rank badgeCelebrity])
            {
                case 0:
                    [[cell badgeImage] setImage:[UIImage imageNamed:IMAGE_BADGE_DEFAULT]];
                    [[cell badgeStatus] setText:@""];
                    break;
                case 1:
                    [[cell badgeImage] setImage:[UIImage imageNamed:IMAGE_BADGE_CELEBRITY_BRONZE]];
                    [[cell badgeStatus] setText:@"BRONZE"];
                    break;
                case 2:
                    [[cell badgeImage] setImage:[UIImage imageNamed:IMAGE_BADGE_CELEBRITY_SILVER]];
                    [[cell badgeStatus] setText:@"SILVER"];
                    break;
                case 3:
                    [[cell badgeImage] setImage:[UIImage imageNamed:IMAGE_BADGE_CELEBRITY_GOLD]];
                    [[cell badgeStatus] setText:@"GOLD"];
                    break;
            }
            break;
        }
        case 3: // Idol
        {
            // Set the badge title
            [[cell badgeTitle] setText:@"Idol"];
            
            // Bronze/silver/gold levels
            switch([rank badgeIdol])
            {
                case 0:
                    [[cell badgeImage] setImage:[UIImage imageNamed:IMAGE_BADGE_DEFAULT]];
                    [[cell badgeStatus] setText:@""];
                    break;
                case 1:
                    [[cell badgeImage] setImage:[UIImage imageNamed:IMAGE_BADGE_IDOL_BRONZE]];
                    [[cell badgeStatus] setText:@"BRONZE"];
                    break;
                case 2:
                    [[cell badgeImage] setImage:[UIImage imageNamed:IMAGE_BADGE_IDOL_SILVER]];
                    [[cell badgeStatus] setText:@"SILVER"];
                    break;
                    //				case 3: // TO-DO: issing asset
                    //					[[cell badgeImage] setImage:[UIImage imageNamed:IMAGE_BADGE_IDOL_GOLD]];
                    //					[[cell badgeStatus] setText:@"GOLD"];
                    //					break;
            }
            break;
        }
        case 4: // Role Model
        {
            // Set the badge title
            [[cell badgeTitle] setText:@"Role Model"];
            
            // Bronze/silver/gold levels
            switch([rank badgeRoleModel])
            {
                case 0:
                    [[cell badgeImage] setImage:[UIImage imageNamed:IMAGE_BADGE_DEFAULT]];
                    [[cell badgeStatus] setText:@""];
                    break;
                case 1:
                    [[cell badgeImage] setImage:[UIImage imageNamed:IMAGE_BADGE_ROLEMODEL_BRONZE]];
                    [[cell badgeStatus] setText:@"BRONZE"];
                    break;
                case 2:
                    [[cell badgeImage] setImage:[UIImage imageNamed:IMAGE_BADGE_ROLEMODEL_SILVER]];
                    [[cell badgeStatus] setText:@"SILVER"];
                    break;
                case 3:
                    [[cell badgeImage] setImage:[UIImage imageNamed:IMAGE_BADGE_ROLEMODEL_GOLD]];
                    [[cell badgeStatus] setText:@"GOLD"];
                    break;
            }
            break;
        }
        case 5: // Tastemaker
        {
            // Set the badge title
            [[cell badgeTitle] setText:@"Tastemaker"];
            
            // Bronze/silver/gold levels
            switch([rank badgeTastemaker])
            {
                case 0:
                    [[cell badgeImage] setImage:[UIImage imageNamed:IMAGE_BADGE_DEFAULT]];
                    [[cell badgeStatus] setText:@""];
                    break;
                case 1:
                    [[cell badgeImage] setImage:[UIImage imageNamed:IMAGE_BADGE_TASTEMAKER_BRONZE]];
                    [[cell badgeStatus] setText:@"BRONZE"];
                    break;
                case 2:
                    [[cell badgeImage] setImage:[UIImage imageNamed:IMAGE_BADGE_TASTEMAKER_SILVER]];
                    [[cell badgeStatus] setText:@"SILVER"];
                    break;
                case 3:
                    [[cell badgeImage] setImage:[UIImage imageNamed:IMAGE_BADGE_TASTEMAKER_GOLD]];
                    [[cell badgeStatus] setText:@"GOLD"];
                    break;
            }
            break;
        }
    }
}

#pragma mark - UICollectionViewFlow delegate methods
// Size of a cell
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat width = (CGRectGetWidth([collectionView frame]) - 2*16 - 2*16) / 3.1;
	
	return CGSizeMake(width, width * 1.5);
}

// Section insets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
	UIEdgeInsets insets;
	insets.left = 16;
	insets.right = 16;
	insets.top = 4;
	insets.bottom = 16;
	
	return insets;
}

// Line spacing
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
	return 16;
}

// Inter-item spacing
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
	return 16;
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

@end
