//
//  MyRanking.m
//  Better
//
//  Created by Peter on 6/18/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "MyRanking.h"

@interface MyRanking ()

@end

@implementation MyRanking

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
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
	UserInfo *user = [UserInfo user];
	UserRank *userRank = [user rank];
	switch([userRank rank])
	{
		case 0:
			[[self rankLabel] setText:@""];
			[[self rankIcon] setImage:nil];
			break;
		case 1:
			[[self rankLabel] setText:@"Newbie"];
			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_NEWBIE]];
			break;
		case 2:
			[[self rankLabel] setText:@"Mainstream"];
			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_MAINSTREAM]];
			break;
		case 3:
			[[self rankLabel] setText:@"Trailblazer"];
			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_TRAILBLAZER]];
			break;
		case 4:
			[[self rankLabel] setText:@"Trendsetter"];
			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_TRENDSETTER]];
			break;
		case 5:
			[[self rankLabel] setText:@"Crowned"];
			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_CROWNED]];
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
	
	return cell;
}

#pragma mark - UICollectionView delegate methods
// Called when a cell is about to appear (we set its properties here)
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(BadgesCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
	[[cell badgeImage] setImage:[UIImage imageNamed:IMAGE_BADGE_DEFAULT]];
	[[cell badgeStatus] setText:@"GOLD"];
	[[cell badgeTitle] setText:@"Hello"];
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
