//
//  CVViewController.m
//  ios7tester
//
//  Created by Sam Fox on 10/16/13.
//  Copyright (c) 2013 Sam Fox. All rights reserved.
//

#import "CVViewController.h"
#import "CVDelegate.h"

@interface CVViewController ()

@end

@implementation CVViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (!self.CVHandler) {
            self.CVHandler = [[CVDelegate alloc] init];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
