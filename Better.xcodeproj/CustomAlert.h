//
//  CustomAlert.h
//  Better
//

#import <UIKit/UIKit.h>

//alert view delegate protocol
@protocol CustomAlertDelegate

//delegate methods to perform specific instance actions
@required
- (void)leftActionMethod:(int)method;
- (void)rightActionMethod:(int)method;

@end

@interface CustomAlert : UIView

//alert view delegate
@property (nonatomic, strong) id <CustomAlertDelegate> customAlertDelegate;

//alert view and modular subviews
@property (nonatomic, strong) UIView *alertView; //view to hold alert contents
@property (nonatomic, strong) UILabel *alertMessage; //displays alert message
@property (nonatomic, strong) UIButton *leftButton; //left alert button
@property (nonatomic, strong) UIButton *rightButton; //right alert button
@property (nonatomic, strong) UIImageView *alertImage; //alert image

//variables for formatting alert view
@property (nonatomic) float alertViewWidth;
@property (nonatomic) float alertViewHeight;
@property (nonatomic) float alertMessageWidth;
@property (nonatomic) float alertMessageSpacing;
@property (nonatomic) float bottomSpacing;
@property (nonatomic) float buttonHeight;
@property (nonatomic) float buttonSpacing;

//initialization method
- (id)initWithType:(int)type withframe:(CGRect)frame withMessage:(NSString *)message;

@end
