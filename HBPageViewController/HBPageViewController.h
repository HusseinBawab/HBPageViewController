//
//  HBPageViewController.h
//  HBPageViewController
//
//  Created by hussein bawab on 10/11/14.
//  Copyright (c) 2014 Hussein Bawab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBPageViewController : UIViewController
@property (nonatomic, strong) NSArray *viewControllers;

// Custom picker properties
@property (nonatomic, strong) UIColor *pickerBackgroundColor;
@property (nonatomic) CGFloat pickerHeight;
@property (nonatomic, strong) UIColor *pickerButtonNormalTitleColor;
@property (nonatomic, strong) UIColor *pickerButtonSelectedTitleColor;
@property (nonatomic, strong) UIColor *pickerButtonTintColor;
@property (nonatomic, strong) UIFont *pickerButtonTitleFont;
@property (nonatomic, strong) UIImage *pickerBackgroundImage;
@property (nonatomic) BOOL enablePickerChin;
@property (nonatomic, strong) UIColor *pickerChinColor;
@property (nonatomic) CGSize pickerChinSize;

- (id)initWithParentViewController:(UIViewController*)parent;
@end
