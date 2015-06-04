//
//  CustomAlert.m
//  Better
//

#import "CustomAlert.h"

@implementation CustomAlert

//initialization method
- (id)initWithType:(int)type withframe:(CGRect)frame withMessage:(NSString *)message {
    
    self = [super init];
    
    if (self) {
        
        //set formatting values
        self.alertViewWidth = 280.0f;
        self.alertMessageWidth = 250.0f;
        self.alertMessageSpacing = 15.0f;
        self.bottomSpacing = 10.0f;
        self.buttonHeight = 40.0f;
        self.buttonSpacing = (type == 1) ? 0 : 5;
        
        //setup alert view
        [self setupWithType:type withframe:frame withMessage:message];
        
    }
    
    return self;
}

//setup method according to type
- (void)setupWithType:(int)type withframe:(CGRect)frame withMessage:(NSString *)message {
    
    //initialize frame and background color
    self.frame = frame;
    [self setBackgroundColor:[UIColor colorWithRed:103/255.0f green:103/255.0f blue:103/255.0f alpha:0.65]];
    
    //set alpha to 0.0f for fade-in effect
    [self setAlpha:0.0f];
    
    //add message subview
    [self setupAlertMessage:message];
    
    //setup rest of alert considering type
    switch (type) {
        case 1:
            [self setupLeftButton:NO];
            break;
            
        case 2:
            [self setupLeftButton:YES];
            [self setupRightButton];
            break;
            
        case 3:
            [self setupLeftButton:YES];
            [self setupRightButton];
            break;
            
        default:
            NSLog(@"Invalid alert type");
            break;
    }
    
    //setup alert view by ading all necessary subviews
    self.alertView = [self setupAlertView];
    
    //add subview to self and return
    [self addSubview:self.alertView];
    
}

- (UIView *)setupAlertView {
    
    //calculate alertView height
    self.alertViewHeight = self.alertMessage.frame.size.height + self.alertMessageSpacing*2.5 + self.leftButton.frame.size.height + self.bottomSpacing;
    
    //create view based on alertView height and set background color
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - self.alertViewWidth/2, self.frame.size.height/2 - self.alertViewHeight/2, self.alertViewWidth, self.alertViewHeight)];
    [view setBackgroundColor:[UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0]];
    
    //add motion effects
    CGFloat leftRightMin = -15.0f;
    CGFloat leftRightMax = 15.0f;
    CGFloat upDownMin = -15.0f;
    CGFloat upDownMax = 15.0f;
    
    UIInterpolatingMotionEffect *leftRight = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    UIInterpolatingMotionEffect *upDown = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    
    leftRight.minimumRelativeValue = @(leftRightMin);
    leftRight.maximumRelativeValue = @(leftRightMax);
    upDown.minimumRelativeValue = @(upDownMin);
    upDown.maximumRelativeValue = @(upDownMax);
    
    UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects = [NSArray arrayWithObjects:leftRight, upDown, nil];
    
    [view addMotionEffect:motionEffectGroup];
    
    //add created subviews to view
    [view addSubview:self.alertMessage];
    [view addSubview:self.leftButton];
    [view addSubview:self.rightButton];
    
    //return view
    return view;
    
}

- (void)setupAlertMessage:(NSString *)text {
    
    //initialize alert message label
    self.alertMessage = [[UILabel alloc] init];
    
    if(text == nil) text = @"";
    
    CGSize size = [[[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir-Medium" size:17]}] boundingRectWithSize:CGSizeMake(self.alertMessageWidth, 400.0f) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    [self.alertMessage setFrame:CGRectMake(self.alertViewWidth/2 - size.width/2, self.alertMessageSpacing, size.width, size.height)];
    [self.alertMessage setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.0]];
    
    [self.alertMessage setText:text];
    [self.alertMessage setTextColor:[UIColor darkGrayColor]];
    [self.alertMessage setFont:[UIFont fontWithName:@"Avenir-Medium" size:17]];
    [self.alertMessage setNumberOfLines:0];
    [self.alertMessage setTextAlignment:NSTextAlignmentCenter];
    
}

- (void)setupLeftButton:(BOOL)isRight {
    
    //initialize alert left button
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bottomSpacing, self.alertMessage.frame.origin.y + self.alertMessage.frame.size.height + self.alertMessageSpacing*1.5, ((isRight) ? (self.alertViewWidth - (self.bottomSpacing*2) - self.buttonSpacing)/2 : (self.alertViewWidth - (self.bottomSpacing*2) - self.buttonSpacing)), self.buttonHeight)];
    [self.leftButton setBackgroundColor:[UIColor colorWithRed:40/255.0f green:212/255.0f blue:202/255.0f alpha:1.0]];
    [self.leftButton.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:17]];
    [self.leftButton addTarget:self action:@selector(leftButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setupRightButton {
    
    //initialize alert right button
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.leftButton.frame.origin.x + self.leftButton.frame.size.width + 5, self.leftButton.frame.origin.y, (self.alertViewWidth - (self.bottomSpacing*2) - self.buttonSpacing)/2, self.buttonHeight)];
    [self.rightButton.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:17]];
    [self.rightButton addTarget:self action:@selector(rightButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)leftButtonMethod {
    
    //if alert delegate, proceed
    if(!self.customAlertDelegate)return;
    
    //call delegate method
    [self.customAlertDelegate leftActionMethod:(int)self.leftButton.tag];
    
}

- (void)rightButtonMethod {
    
    //if alert delegate, proceed
    if(!self.customAlertDelegate)return;
    
    //call delegate method
    [self.customAlertDelegate rightActionMethod:(int)self.rightButton.tag];
    
}

@end
