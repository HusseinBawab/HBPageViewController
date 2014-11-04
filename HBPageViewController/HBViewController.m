//
//  HBViewController.m
//  HBPageViewController
//
//  Created by hussein bawab on 10/11/14.
//  Copyright (c) 2014 Hussein Bawab. All rights reserved.
//

#import "HBViewController.h"

#import "HBPageViewController.h"

#import "HBOneViewController.h"

#import "HBTwoViewController.h"

@interface HBViewController ()
@property (nonatomic, strong) HBPageViewController *page;
@property (nonatomic, strong) HBOneViewController *one;
@property (nonatomic, strong) HBTwoViewController *two;
@property (nonatomic, strong) HBOneViewController *three;
@property (nonatomic, strong) HBTwoViewController *four;
@end

@implementation HBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    //[self.navigationController.navigationBar setTranslucent:NO];
    
    // First Create your view controllers
    _one = [[HBOneViewController alloc] init];
    _one.title = @"One";
    
    _two = [[HBTwoViewController alloc] init];
    _two.title = @"Two";
    
    _three = [[HBOneViewController alloc] init];
    _three.title = @"Three";
    
    _four = [[HBTwoViewController alloc] init];
    _four.title = @"Four";
    
    // Create your HBPageViewController instance and pass self view contorller to it
    _page = [[HBPageViewController alloc] initWithParentViewController:self];
    // Pass the created view controllers in an array to the page view controller instance
    _page.viewControllers = @[_one, _two, _three, _four];
    // Add HBPageViewController's view as subview to the View Controller main view.
    [_page setEnablePickerChin:YES];
    [self.view addSubview:_page.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
