//
//  addNewsController.m
//  Flysurf
//
//  Created by Joshua Glenn Paldo on 12/16/12.
//  Copyright (c) 2012 Joshua Glenn Paldo. All rights reserved.
//

#import "addNewsController.h"

@interface addNewsController ()

-(IBAction)back:(id)sender;
@end

@implementation addNewsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)back:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
