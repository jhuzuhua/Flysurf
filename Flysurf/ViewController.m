//
//  ViewController.m
//  Flysurf
//
//  Created by Joshua Glenn Paldo on 12/7/12.
//  Copyright (c) 2012 Joshua Glenn Paldo. All rights reserved.
//

#import "ViewController.h"
#import "SDZnews.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)onload:(id)value {
    NSLog(@"Load:%@",value);
}

- (void)onerror:(NSError *)error {
    NSLog(@"Error:%@",error);
}

- (void)onfault:(SoapFault *)fault {
    NSLog(@"Fault:%@",fault);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SDZnews * news = [SDZnews service];
    [news GetNewsTypes:self key:@"Buzz"];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
