//
//  HashtagCellDeletable.m
//  Better
//
//  Created by Peter on 7/21/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "HashtagCellDeletable.h"

@implementation HashtagCellDeletable

- (void)awakeFromNib
{
    // Initialization code
}

// Called when "X" is pressed
- (IBAction)pressedDeleteButton:(id)sender
{
    // Tell the delegate that this cell's delete button was pressed
    if([self delegate])
        if([[self delegate] respondsToSelector:@selector(deleteButtonWasPressedForHashtagCell:)])
            // Send the message
            [[self delegate] deleteButtonWasPressedForHashtagCell:self];
}
@end
