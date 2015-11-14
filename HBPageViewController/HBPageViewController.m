//
//  HBPageViewController.m
//  HBPageViewController
//
//  Created by hussein bawab on 10/11/14.
//  Copyright (c) 2014 Hussein Bawab. All rights reserved.
//

#import "HBPageViewController.h"

#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

@interface HBPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate, UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) UIScrollView *picker;
@property (nonatomic, strong) UIViewController* parent;
@property (nonatomic, strong) UIView *chin;
@end

@implementation HBPageViewController{
    NSInteger currentSelectedPickerButton;
    float startingPageScrollViewContentOffsetX, latestPickerOffset;
    BOOL gestureDrivenTransition;
    BOOL rotating;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithParentViewController:(UIViewController *)parent{
    self = [super init];
    
    if (self) {
        _parent = parent;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if (!_parent.navigationController.navigationBar.isHidden) {
        if (_parent.navigationController.navigationBar.translucent) {
            [self.view setFrame:CGRectMake(0, 64+_pickerHeight, _parent.view.frame.size.width, _parent.view.frame.size.height-64-_pickerHeight)];
        } else{
            [self.view setFrame:CGRectMake(_parent.view.frame.origin.x, _pickerHeight, _parent.view.frame.size.width, _parent.view.frame.size.height-_pickerHeight)];
        }
    } else{
        [self.view setFrame:CGRectMake(_parent.view.frame.origin.x, _pickerHeight, _parent.view.frame.size.width, _parent.view.frame.size.height-_pickerHeight)];
    }
    
    [self createPicker];
    
    [self createPageViewController];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self configurePickerButtonsWithNextButton:(int)currentSelectedPickerButton];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    /*if (toInterfaceOrientation == UIDeviceOrientationLandscapeLeft || toInterfaceOrientation == UIDeviceOrientationLandscapeRight) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
            if (!_parent.navigationController.navigationBar.isHidden) {
                if (_parent.navigationController.navigationBar.translucent) {
                    [self.view setFrame:CGRectMake(0, _parent.navigationController.navigationBar.frame.size.height+_pickerHeight+20, _parent.view.frame.size.width, _parent.view.frame.size.height-_parent.navigationController.navigationBar.frame.size.height-_pickerHeight-20)];
                } else{
                    [self.view setFrame:CGRectMake(_parent.view.frame.origin.x, _pickerHeight, _parent.view.frame.size.width, _parent.view.frame.size.height-_pickerHeight)];
                }
                if (_pickerHeight) {
                    [_picker setFrame:CGRectMake(0, 0, self.view.frame.size.width, _pickerHeight)];
                } else{
                    [_picker setFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
                }
            } else{
                [self.view setFrame:CGRectMake(_parent.view.frame.origin.x, _pickerHeight, _parent.view.frame.size.width, _parent.view.frame.size.height-_pickerHeight)];
                if (_pickerHeight) {
                    [_pageViewController.view setFrame:CGRectMake(0, _pickerHeight+20, _parent.view.frame.size.width, _parent.view.frame.size.height-(_pickerHeight+20))];
                    [_picker setFrame:CGRectMake(0, 0, self.view.frame.size.width, _pickerHeight+20)];
                } else{
                    [_pageViewController.view setFrame:CGRectMake(0, 60, _parent.view.frame.size.width, _parent.view.frame.size.height-60)];
                    [_picker setFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
                }
            }
        } else{
            if (!_parent.navigationController.navigationBar.isHidden) {
                if (_parent.navigationController.navigationBar.translucent) {
                    [self.view setFrame:CGRectMake(0, _parent.navigationController.navigationBar.frame.size.height+_pickerHeight, _parent.view.frame.size.width, _parent.view.frame.size.height-_parent.navigationController.navigationBar.frame.size.height-_pickerHeight)];
                } else{
                    [self.view setFrame:CGRectMake(_parent.view.frame.origin.x, _pickerHeight, _parent.view.frame.size.width, _parent.view.frame.size.height-_pickerHeight)];
                }
            } else{
                [self.view setFrame:CGRectMake(_parent.view.frame.origin.x, _pickerHeight, _parent.view.frame.size.width, _parent.view.frame.size.height-_pickerHeight)];
                if (_pickerHeight) {
                    [_pageViewController.view setFrame:CGRectMake(0, _pickerHeight, _parent.view.frame.size.width, _parent.view.frame.size.height)];
                } else{
                    [_pageViewController.view setFrame:CGRectMake(0, 40, _parent.view.frame.size.width, _parent.view.frame.size.height)];
                }
            }
            
            if (_pickerHeight) {
                if (!_parent.navigationController.navigationBar.isHidden) {
                    [_picker setFrame:CGRectMake(0, 0, self.view.frame.size.width, _pickerHeight)];
                } else{
                    [_picker setFrame:CGRectMake(0, 0, self.view.frame.size.width, _pickerHeight)];
                }
            } else{
                [_picker setFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
            }
        }
        
        float pickerButtonWidth = self.view.frame.size.width/3;
        float pickerButtonHeight = _picker.frame.size.height;
        
        for (id objects in _picker.subviews) {
            if ([objects isKindOfClass:[UIButton class]]) {
                int buttonTag = (int)((UIButton*)objects).tag;
                if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
                    if (!_parent.navigationController.navigationBar.isHidden) {
                        if (_parent.navigationController.navigationBar.translucent) {
                            [objects setFrame:CGRectMake(-((_picker.frame.size.width/2) - ((self.view.frame.size.width/3)/2)) + (((_picker.frame.size.width/2) - ((self.view.frame.size.width/3)/2)) * (buttonTag+1)), -64, pickerButtonWidth, pickerButtonHeight)];
                        } else{
                            [objects setFrame:CGRectMake(-((_picker.frame.size.width/2) - ((self.view.frame.size.width/3)/2)) + (((_picker.frame.size.width/2) - ((self.view.frame.size.width/3)/2)) * (buttonTag+1)), 0, pickerButtonWidth, pickerButtonHeight)];
                        }
                    } else{
                        [objects setFrame:CGRectMake(-((_picker.frame.size.width/2) - ((self.view.frame.size.width/3)/2)) + (((_picker.frame.size.width/2) - ((self.view.frame.size.width/3)/2)) * (buttonTag+1)), -20, pickerButtonWidth, pickerButtonHeight)];
                    }
                } else{
                    if (!_parent.navigationController.navigationBar.isHidden) {
                        if (_parent.navigationController.navigationBar.translucent) {
                            [objects setFrame:CGRectMake(-((_picker.frame.size.width/2) - ((self.view.frame.size.width/3)/2)) + (((_picker.frame.size.width/2) - ((self.view.frame.size.width/3)/2)) * (buttonTag+1)), -64, pickerButtonWidth, pickerButtonHeight)];
                        } else{
                            [objects setFrame:CGRectMake(-((_picker.frame.size.width/2) - ((self.view.frame.size.width/3)/2)) + (((_picker.frame.size.width/2) - ((self.view.frame.size.width/3)/2)) * (buttonTag+1)), 0, pickerButtonWidth, pickerButtonHeight)];
                        }
                    } else{
                        [objects setFrame:CGRectMake(-((_picker.frame.size.width/2) - ((self.view.frame.size.width/3)/2)) + (((_picker.frame.size.width/2) - ((self.view.frame.size.width/3)/2)) * (buttonTag+1)), -20, pickerButtonWidth, pickerButtonHeight)];
                    }
                }
            }
        }
        
        startingPageScrollViewContentOffsetX = -((_picker.frame.size.width/2) - ((self.view.frame.size.width/3)/2));
        
        if (_enablePickerChin) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
                if (_pickerChinSize.height > 0 && _pickerChinSize.width > 0) {
                    [_chin setFrame:CGRectMake(_picker.frame.size.width/2 - _pickerChinSize.width/2, _picker.frame.size.height - _pickerChinSize.height-40, _pickerChinSize.width, _pickerChinSize.height+10)];
                } else{
                    [_chin setFrame:CGRectMake(_picker.frame.size.width/2 - _picker.frame.size.width/8, _picker.frame.size.height-2, _picker.frame.size.width/4, 2)];;
                }
            } else{
                if (_pickerChinSize.height > 0 && _pickerChinSize.width > 0) {
                    [_chin setFrame:CGRectMake(_picker.frame.size.width/2 - _pickerChinSize.width/2, _picker.frame.size.height - _pickerChinSize.height, _pickerChinSize.width, _pickerChinSize.height)];
                } else{
                    [_chin setFrame:CGRectMake(_picker.frame.size.width/2 - _picker.frame.size.width/8, _picker.frame.size.height-2, _picker.frame.size.width/4, 2)];;
                }
            }
        }
        
        [self configurePickerButtonsWithNextButton:(int)currentSelectedPickerButton];
    } else{[_picker setBackgroundColor:[UIColor redColor]];
        if (!_parent.navigationController.navigationBar.isHidden) {
            if (_parent.navigationController.navigationBar.translucent) {
                [self.view setFrame:CGRectMake(0, 64+_pickerHeight, _parent.view.frame.size.width, _parent.view.frame.size.height-64-_pickerHeight)];
            } else{
                [self.view setFrame:CGRectMake(_parent.view.frame.origin.x, _pickerHeight, _parent.view.frame.size.width, _parent.view.frame.size.height-_pickerHeight)];
            }
        } else{
            [self.view setFrame:CGRectMake(_parent.view.frame.origin.x, _pickerHeight+20, _parent.view.frame.size.width, _parent.view.frame.size.height-_pickerHeight-20)];
            
            [_pageViewController.view setFrame:CGRectMake(0, _picker.frame.size.height+20, self.view.frame.size.width, self.view.frame.size.height-_picker.frame.size.height-20)];
        }
        
        if (_pickerHeight) {
            if (!_parent.navigationController.navigationBar.isHidden) {
                [_picker setFrame:CGRectMake(0, 0, self.view.frame.size.width, _pickerHeight)];
            } else{
                [_picker setFrame:CGRectMake(0, 0, self.view.frame.size.width, _pickerHeight+20)];
            }
        } else{
            if (!_parent.navigationController.navigationBar.isHidden) {
                [_picker setFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
            } else{
                [_picker setFrame:CGRectMake(0, -20, self.view.frame.size.width, 60)];
            }
        }
        
        float pickerButtonWidth = self.view.frame.size.width/3;
        float pickerButtonHeight = _picker.frame.size.height;
        
        for (id objects in _picker.subviews) {
            if ([objects isKindOfClass:[UIButton class]]) {
                int buttonTag = (int)((UIButton*)objects).tag;
                if (!_parent.navigationController.navigationBar.isHidden) {
                    if (_parent.navigationController.navigationBar.translucent) {
                        [objects setFrame:CGRectMake(-((_picker.frame.size.width/2) - ((self.view.frame.size.width/3)/2)) + (((_picker.frame.size.width/2) - ((self.view.frame.size.width/3)/2)) * (buttonTag+1)), -64, pickerButtonWidth, pickerButtonHeight)];
                    } else{
                        [objects setFrame:CGRectMake(-((_picker.frame.size.width/2) - ((self.view.frame.size.width/3)/2)) + (((_picker.frame.size.width/2) - ((self.view.frame.size.width/3)/2)) * (buttonTag+1)), 0, pickerButtonWidth, pickerButtonHeight)];
                    }
                } else{
                    [objects setFrame:CGRectMake(-((_picker.frame.size.width/2) - ((self.view.frame.size.width/3)/2)) + (((_picker.frame.size.width/2) - ((self.view.frame.size.width/3)/2)) * (buttonTag+1)), -20, pickerButtonWidth, pickerButtonHeight)];
                }
            }
        }
        
        startingPageScrollViewContentOffsetX = -((_picker.frame.size.width/2) - ((self.view.frame.size.width/3)/2));
        
        if (_enablePickerChin) {
            if (_pickerChinSize.height > 0 && _pickerChinSize.width > 0) {
                [_chin setFrame:CGRectMake(_picker.frame.size.width/2 - _pickerChinSize.width/2, _picker.frame.size.height - _pickerChinSize.height, _pickerChinSize.width, _pickerChinSize.height)];
            } else{
                [_chin setFrame:CGRectMake(_picker.frame.size.width/2 - _picker.frame.size.width/8, _picker.frame.size.height-2, _picker.frame.size.width/4, 2)];;
            }
        }
        
        [self configurePickerButtonsWithNextButton:(int)currentSelectedPickerButton];
    }*/
}

- (void)createPicker{
    if (_pickerHeight) {
        if (!_parent.navigationController.navigationBar.isHidden) {
            _picker = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _pickerHeight)];
        } else{
            _picker = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _pickerHeight+20)];
        }
    } else{
        if (!_parent.navigationController.navigationBar.isHidden) {
            _picker = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        } else{
            _picker = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        }
    }
    
    for (UIViewController* vc in _viewControllers) {
        float pickerButtonWidth = self.view.frame.size.width/3;
        float pickerButtonHeight = _picker.frame.size.height;
        NSUInteger currentVCIndex = [_viewControllers indexOfObject:vc];
        
        UIButton *pickerButton;
        if (!_parent.navigationController.navigationBar.isHidden) {
            if (_parent.navigationController.navigationBar.translucent) {
                pickerButton = [[UIButton alloc] initWithFrame:CGRectMake(pickerButtonWidth*currentVCIndex, -64, pickerButtonWidth, pickerButtonHeight)];
            } else{
                pickerButton = [[UIButton alloc] initWithFrame:CGRectMake(pickerButtonWidth*currentVCIndex, 0, pickerButtonWidth, pickerButtonHeight)];
            }
        } else{
            pickerButton = [[UIButton alloc] initWithFrame:CGRectMake(pickerButtonWidth*currentVCIndex, -20, pickerButtonWidth, pickerButtonHeight)];
        }
        [pickerButton setTitle:vc.title forState:UIControlStateNormal];
        [pickerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [pickerButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        if (_pickerButtonNormalTitleColor) {
            [pickerButton setTitleColor:_pickerButtonNormalTitleColor forState:UIControlStateNormal];
        }
        if (_pickerButtonSelectedTitleColor) {
            [pickerButton setTitleColor:_pickerButtonSelectedTitleColor forState:UIControlStateSelected];
        }
        if (_pickerButtonTitleFont) {
            [pickerButton.titleLabel setFont:_pickerButtonTitleFont];
        }
        if (_pickerButtonTintColor) {
            [pickerButton setTintColor:_pickerButtonTintColor];
        }
        [pickerButton setTag:currentVCIndex];
        [pickerButton addTarget:self action:@selector(pickerButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_picker addSubview:pickerButton];
    }
    
    if (_pickerBackgroundColor) {
        [_picker setBackgroundColor:_pickerBackgroundColor];
    }
    
    if (_pickerBackgroundImage) {
        UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _picker.frame.size.width, _picker.frame.size.height)];
        [backgroundImage setImage:_pickerBackgroundImage];
        [_picker addSubview:backgroundImage];
    }
    
    [_picker setScrollEnabled:NO];
    
    startingPageScrollViewContentOffsetX = -((_picker.frame.size.width/2) - ((self.view.frame.size.width/3)/2));

    [_picker setContentOffset:CGPointMake(startingPageScrollViewContentOffsetX, 0)];
    
    [self.view addSubview:_picker];
    
    [[_picker.subviews firstObject] setSelected:YES];
    
    currentSelectedPickerButton = 0;
    
    if (_enablePickerChin) {
        if (_pickerChinSize.height > 0 && _pickerChinSize.width > 0) {
            _chin = [[UIView alloc] initWithFrame:CGRectMake(_picker.frame.size.width/2 - _pickerChinSize.width/2, _picker.frame.size.height - _pickerChinSize.height, _pickerChinSize.width, _pickerChinSize.height)];
        } else{
            _chin = [[UIView alloc] initWithFrame:CGRectMake(_picker.frame.size.width/2 - _picker.frame.size.width/8, _picker.frame.size.height-2, _picker.frame.size.width/4, 2)];;
        }
        
        if (_pickerChinColor) {
            [_chin setBackgroundColor:_pickerChinColor];
        } else{
            [_chin setBackgroundColor:[UIColor blackColor]];
        }
        
        [self.view addSubview:_chin];
    }
}

- (void)createPageViewController{
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [_pageViewController setViewControllers:@[[_viewControllers firstObject] ] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [_pageViewController.view setFrame:CGRectMake(0, _picker.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-_picker.frame.size.height)];
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    
    [(UIScrollView*)[_pageViewController.view.subviews firstObject] setDelegate:self];
    
    [self.view addSubview:_pageViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pickerButtonTapped:(UIButton*)sender{
    
    if (currentSelectedPickerButton < sender.tag) {
        [_pageViewController setViewControllers:@[[_viewControllers objectAtIndex:currentSelectedPickerButton+1]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    } else if (currentSelectedPickerButton > sender.tag){
        [_pageViewController setViewControllers:@[[_viewControllers objectAtIndex:currentSelectedPickerButton-1]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }
    
    [self configurePickerButtonsWithNextButton:(int)sender.tag];
}

- (void)configurePickerButtonsWithNextButton:(int)buttonTag{
    if (!_parent.navigationController.navigationBar.isHidden) {
        if (_parent.navigationController.navigationBar.translucent) {
            [_picker setContentOffset:CGPointMake(-((_picker.frame.size.width/2) - ((self.view.frame.size.width/3)/2)) + (((_picker.frame.size.width/2) - ((self.view.frame.size.width/3)/2)) * buttonTag), -64) animated:YES];
        } else{
            [_picker setContentOffset:CGPointMake(-((_picker.frame.size.width/2) - ((self.view.frame.size.width/3)/2)) + (((_picker.frame.size.width/2) - ((self.view.frame.size.width/3)/2)) * buttonTag), 0) animated:YES];
        }
    } else{
        [_picker setContentOffset:CGPointMake(-((_picker.frame.size.width/2) - ((self.view.frame.size.width/3)/2)) + (((_picker.frame.size.width/2) - ((self.view.frame.size.width/3)/2)) * buttonTag), -20) animated:YES];
    }
    
    [[_picker.subviews objectAtIndex:currentSelectedPickerButton] setSelected:NO];
    
    currentSelectedPickerButton = buttonTag;
    
    [[_picker.subviews objectAtIndex:buttonTag] setSelected:YES];
}

#pragma mark -  UIPageViewControllerDatasource Methods
- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index = [_viewControllers indexOfObject:viewController];
    
    if (index == 0) {
        return nil;
    } else{
        return (UIViewController*)[_viewControllers objectAtIndex:index-1];
    }
}

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index = [_viewControllers indexOfObject:viewController];
    
    if (index == _viewControllers.count-1) {
        return nil;
    } else{
        return (UIViewController*)[_viewControllers objectAtIndex:index+1];
    }
}

#pragma mark - UIPageViewControllerDelegate Methods
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    if (completed) {
        [self pickerButtonTapped:(UIButton*)[_picker.subviews objectAtIndex:[_viewControllers indexOfObject:[[pageViewController viewControllers] firstObject]]]];
    }
    gestureDrivenTransition = NO;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
    gestureDrivenTransition = YES;
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (gestureDrivenTransition) {
        if (scrollView.contentOffset.x != self.view.frame.size.width) {
            latestPickerOffset = startingPageScrollViewContentOffsetX + (((_picker.frame.size.width * currentSelectedPickerButton) + (scrollView.contentOffset.x - self.view.frame.size.width))/3);
            
            if ((scrollView.contentOffset.x - self.view.frame.size.width) == scrollView.frame.size.width/2) {
                //half way there
            }
            
            if (!_parent.navigationController.navigationBar.isHidden) {
                if (_parent.navigationController.navigationBar.translucent) {
                    [_picker setContentOffset:CGPointMake(latestPickerOffset, -64)];
                } else{
                    [_picker setContentOffset:CGPointMake(latestPickerOffset, 0)];
                }
            } else{
                [_picker setContentOffset:CGPointMake(latestPickerOffset, -20)];
            }
        }
    }
}
@end
