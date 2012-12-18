//
//  addCommentsController.m
//  Flysurf
//
//  Created by Joshua Glenn Paldo on 12/16/12.
//  Copyright (c) 2012 Joshua Glenn Paldo. All rights reserved.
//

#import "addCommentsController.h"
#import "News.h"

@interface addCommentsController ()
@property News* news;
@end

@implementation addCommentsController

@synthesize newsTitle, news;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithNews: (News*) newsData{
    self = [super initWithNibName:@"addCommentsController" bundle:nil];
    if (self) {
        // Custom initialization
        news = newsData;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [newsTitle setText:[NSString stringWithFormat:@"%@", news.Title]];
    
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)back:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
