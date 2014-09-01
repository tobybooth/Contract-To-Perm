//
//  TOBPermViewController.m
//  Contract To Perm
//
//  Created by Toby Booth on 7/1/14.
//  Copyright (c) 2014 Toby Booth. All rights reserved.
//

#import "TOBPermViewController.h"
#import "TOBContractView.h"

@interface TOBPermViewController () <UITextFieldDelegate>
@property (nonatomic, weak) UILabel *directions;
@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, weak) UILabel *perHourLabel;
@property (nonatomic, weak) UIButton *button;
@property (nonatomic, strong) UIColor *mainColor;
@property (nonatomic, strong) UIColor *lightColor;
@property (nonatomic, strong) UIColor *darkColor;

@end

@implementation TOBPermViewController

#pragma mark - init

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        UITabBarItem *tbi = self.tabBarItem;
        tbi.title = @"Annual Salary Range";
        tbi.image = [UIImage imageNamed:@"Salary"];
    }
    return self;
}

#pragma mark - View Setup

- (void)loadView
{
    // ColorScheme
    UIColor *mainColor = [[UIColor alloc] initWithRed:0.31 green:0.58 blue:0.75 alpha:1.0];
    UIColor *darkColor = [[UIColor alloc] initWithRed:0.15 green:0.15 blue:0.19 alpha:1.0];
    UIColor *lightColor = [[UIColor alloc] initWithRed:0.73 green:0.83 blue:0.9 alpha:1.0];
    self.mainColor = mainColor;
    self.darkColor = darkColor;
    self.lightColor = lightColor;
    
    TOBContractView *backgroundView = [[TOBContractView alloc]init];
    //backgroundView.backgroundColor = self.mainColor;
    backgroundView.backgroundColor = self.darkColor;
    
    // Label
    UILabel *directions = [[UILabel alloc]init];
    directions.textColor = self.lightColor;
    directions.text = @"Enter contract hourly rate below:";
    directions.font = [UIFont fontWithName:@"Helvetica" size:15];
    [directions sizeToFit];
    CGRect dirFrame = directions.frame;
    dirFrame.origin = CGPointMake(40, 40);
    directions.frame = dirFrame;
    [backgroundView addSubview:directions];
    
    
    // Text Field
    CGRect textFieldRect = CGRectMake(40,
                                      directions.frame.origin.y + directions.frame.size.height + 20,
                                      130,
                                      60);
    UITextField *textField = [[UITextField alloc]initWithFrame:textFieldRect];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont fontWithName:@"Helvetica" size:34];
    textField.placeholder = @"Rate";
    textField.clearsOnBeginEditing = YES;
    textField.textAlignment = NSTextAlignmentRight;
    textField.keyboardType = UIKeyboardTypeDecimalPad;

    
    
    textField.delegate = self;
    
    // per hour label
    UILabel *perHourLabel = [[UILabel alloc]init];
    //perHourLabel.textColor = self.darkColor;
    perHourLabel.textColor = self.mainColor;
    perHourLabel.font = [UIFont fontWithName:@"Helvetica" size:34];
    perHourLabel.text = @"/hour";
    CGRect perHourFrame = CGRectMake(textField.frame.origin.x + textField.frame.size.width + 10,
                               textField.frame.origin.y,
                               320 - textField.frame.size.width - 80,
                               textField.frame.size.height);
    perHourLabel.frame = perHourFrame;
    [backgroundView addSubview:perHourLabel];
    
    
    // Button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(120,
                              textField.frame.origin.y + textField.frame.size.height + 40,
                              80,
                              60);
    
    [button setTitleColor:self.lightColor forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"roundRect"] forState:UIControlStateNormal];
    [button setTitle:@"Calculate" forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(buttonAction:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [backgroundView addSubview:button];
    
    self.directions = directions;
    self.textField = textField;
    self.perHourLabel = perHourLabel;
    self.button = button;


    
    [backgroundView addSubview:textField];

    
    self.view = backgroundView;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self calculateSalary:textField.text.floatValue];
    [textField resignFirstResponder];
    [self.button setTitle:@"Back" forState:UIControlStateNormal];
    
    return YES;
}


#pragma mark - Actions



- (void) calculateSalary:(CGFloat) contractRate
{
    CGFloat flyinDuration = 0.5;
    
    // formatter for salary display
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setRoundingMode:NSNumberFormatterRoundUp];
    [formatter setMaximumFractionDigits:0];
    
    
    
    // Move directions and textfield off screen
    [UIView animateWithDuration:flyinDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = self.directions.frame;
                         frame.origin.x = frame.size.width * -1;
                         self.directions.frame = frame;
                     }
                     completion:NULL];
    
    [UIView animateWithDuration:flyinDuration
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = self.textField.frame;
                         frame.origin.x = frame.size.width * -1.0 - self.perHourLabel.frame.size.width - 10;
                         self.textField.frame = frame;
                         
                         CGRect labelFrame = self.perHourLabel.frame;
                         labelFrame.origin.x = labelFrame.size.width * -1;
                         self.perHourLabel.frame = labelFrame;
                     }
                     completion:NULL];
    
    
    
    // Move Button Down
    [UIView animateWithDuration:1.3
                          delay:0.2
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.7
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = self.button.frame;
                         frame.origin.y = self.view.frame.size.height - 150;
                         self.button.frame = frame;
                     }completion:NULL];
    
    
    // Display descriptive text
    
    UILabel *description = [[UILabel alloc] init];
    description.backgroundColor = [UIColor clearColor];
    description.textColor = self.lightColor;
    description.text = [NSString stringWithFormat:@"Your expected salary range is"];
    description.font = [UIFont fontWithName:@"Helvetica" size:15];
    [description sizeToFit];
    
    
    CGRect descFrame = description.frame;
    descFrame.origin = CGPointMake(self.view.bounds.size.width, 40);
    description.frame = descFrame;
    description.alpha = 0.0;
    
    [self.view addSubview:description];
    
    [UIView animateWithDuration:flyinDuration
                          delay:0.4
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         description.alpha = 1.0;
                         CGRect frame = descFrame;
                         frame.origin.x = 40;
                         description.frame = frame;
                     }
                     completion:NULL];
    
    // Display minimum rate
    NSNumber *minRate = [[NSNumber alloc]initWithFloat:(2080 * contractRate / 1.15)];
    UILabel *minLabel = [[UILabel alloc]init];
    minLabel.backgroundColor = [UIColor clearColor];
    //minLabel.textColor = self.darkColor;
    minLabel.textColor = self.mainColor;
    minLabel.text = [formatter stringFromNumber:minRate];
    minLabel.font = [UIFont fontWithName:@"Helvetica" size:70];
    minLabel.adjustsFontSizeToFitWidth = YES;
    [minLabel sizeToFit];
    
    
    CGRect minFrame = minLabel.frame;
    minFrame.size.width = 240;
    minFrame.origin = CGPointMake(self.view.bounds.size.width, descFrame.origin.y + descFrame.size.height + 10);
    minLabel.frame = minFrame;
    minLabel.alpha = 0.0;
    
    [self.view addSubview:minLabel];
    
    [UIView animateWithDuration:flyinDuration
                          delay:0.4
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         minLabel.alpha = 1.0;
                         CGRect frame = minFrame;
                         frame.origin.x = 40;
                         minLabel.frame = frame;
                     }
                     completion:NULL];
    
    // create label for "to"
    UILabel *toLabel = [[UILabel alloc]init];
    toLabel.text = @"to";
    toLabel.backgroundColor = [UIColor clearColor];
    toLabel.textColor = self.lightColor;
    toLabel.font = [UIFont fontWithName:@"Helvetica" size:34];
    [toLabel sizeToFit];
    
    CGRect toFrame = toLabel.frame;
    toFrame.origin = CGPointMake(self.view.bounds.size.width, minFrame.origin.y + minFrame.size.height + 10);
    toLabel.frame = toFrame;
    
    [self.view addSubview:toLabel];
    
    toLabel.alpha = 0.0;
    [UIView animateWithDuration:flyinDuration
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         toLabel.alpha = 1.0;
                         CGRect frame = toFrame;
                         frame.origin.x = 40;
                         toLabel.frame = frame;
                     }
                     completion:NULL];
    
    // Display Max Rate
    NSNumber *maxRate = [[NSNumber alloc]initWithFloat:(2080 * contractRate / 1.12)];
    UILabel *maxLabel = [[UILabel alloc]init];
    maxLabel.backgroundColor = [UIColor clearColor];
    //maxLabel.textColor = self.darkColor;
    maxLabel.textColor = self.mainColor;
    maxLabel.text = [formatter stringFromNumber:maxRate];
    maxLabel.font = [UIFont fontWithName:@"Helvetica" size:70];
    maxLabel.adjustsFontSizeToFitWidth = YES;
    [maxLabel sizeToFit];
    
    CGRect maxFrame = maxLabel.frame;
    maxFrame.size.width = 240;
    maxFrame.origin = CGPointMake(self.view.bounds.size.width, toFrame.origin.y + toFrame.size.height + 10);
    maxLabel.frame = maxFrame;
    
    maxLabel.alpha = 0.0;
    
    [self.view addSubview:maxLabel];
    
    [UIView animateWithDuration:flyinDuration
                          delay:0.6
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         maxLabel.alpha = 1.0;
                         CGRect frame = maxFrame;
                         frame.origin.x = 40;
                         maxLabel.frame = frame;
                         
                     }
                     completion:NULL];
    

}

- (void) clearView;
{
    CGFloat flyOutDuration = 0.5;
    
    ///// Move text off screen and remove extra views
    
    UILabel *description = self.view.subviews[4];
    UILabel *minLabel = self.view.subviews[5];
    UILabel *toLabel = self.view.subviews[6];
    UILabel *maxLabel = self.view.subviews[7];
    
    // move description
    [UIView animateWithDuration:flyOutDuration
                          delay:0.4
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         description.alpha = 0.0;
                         CGRect frame = description.frame;
                         frame.origin.x = self.view.bounds.size.width;
                         description.frame = frame;
                     }completion:^(BOOL finished){
                         [description removeFromSuperview];
                     }];
    
    // move minimum rate
    [UIView animateWithDuration:flyOutDuration
                          delay:0.2
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         minLabel.alpha = 0.0;
                         CGRect frame = minLabel.frame;
                         frame.origin.x = self.view.bounds.size.width;
                         minLabel.frame = frame;
                     }completion:^(BOOL finished){
                         [minLabel removeFromSuperview];
                     }];
    
    // move to
    [UIView animateWithDuration:flyOutDuration
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         toLabel.alpha = 0.0;
                         CGRect frame = toLabel.frame;
                         frame.origin.x = self.view.bounds.size.width;
                         toLabel.frame = frame;
                     }completion:^(BOOL finished){
                         [toLabel removeFromSuperview];
                     }];
    
    //move max rate
    [UIView animateWithDuration:flyOutDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         maxLabel.alpha = 0.0;
                         CGRect frame = maxLabel.frame;
                         frame.origin.x = self.view.bounds.size.width;
                         maxLabel.frame = frame;
                     }completion:^(BOOL finished){
                         [maxLabel removeFromSuperview];
                     }];
    
    
    
    //// Reset view
    
    //directions
    [UIView animateWithDuration:flyOutDuration
                          delay:0.8
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = self.directions.frame;
                         frame.origin.x = 40;
                         self.directions.frame = frame;
                     }completion:NULL];
    
    //text field and k/year label
    [UIView animateWithDuration:flyOutDuration
                          delay:0.6
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = self.textField.frame;
                         frame.origin.x = 40;
                         self.textField.frame = frame;
                         
                         CGRect labelFrame = self.perHourLabel.frame;
                         labelFrame.origin.x = frame.origin.x + frame.size.width + 10;
                         self.perHourLabel.frame = labelFrame;
                     }completion:NULL];
    
    //button
    [UIView animateWithDuration:1.3
                          delay:0.2
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.7
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = self.button.frame;
                         frame.origin.y = self.textField.frame.origin.y + self.textField.frame.size.height + 10;
                         self.button.frame = frame;
                     }completion:NULL];
}

- (void)buttonAction:(id)sender
{
    if ([self textFieldContainsErrors] == NO) {
        
    
        if ([self.button.titleLabel.text  isEqual: @"Calculate"]) {
            [sender setTitle:@"Back" forState:UIControlStateNormal];
            [self calculateSalary:_textField.text.floatValue];
            [self.textField resignFirstResponder];
        }else{
            [sender setTitle:@"Calculate" forState:UIControlStateNormal];
            [self clearView];
        }
    }
    
}

- (BOOL)textFieldContainsErrors
{
    if ([self.textField.text isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
    
}

@end
