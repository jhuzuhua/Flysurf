//
//  ViewController.m
//  Flysurf
//
//  Created by Joshua Glenn Paldo on 12/7/12.
//  Copyright (c) 2012 Joshua Glenn Paldo. All rights reserved.
//

#import "ViewController.h"
#import "News.h"
#import "NewsComment.h"
#import "NewsType.h"

#define FLYSURF_WEBSERVICE @"http://dotnet.flysurf.com/services/news.asmx"
#define KEY @"@Fly$5F%"

#define kGETNEWSTYPES @"GetNewsTypes"
#define kNEWSLIST @"NewsList"

@interface ViewController ()
@property(nonatomic,strong) NSMutableArray * NewsTypes;
@property(nonatomic,strong) NSMutableArray * NewsList;
- (void)getNewsTypes;
- (void)getNewsListForNewsType:(uint)type;
- (NSURLRequest *)getURLRequestForService:(NSString *)function WithParameters:(NSString *)params;

- (void)update;
@end

@implementation ViewController

@synthesize NewsTypes, NewsList;

#pragma mark - Web Service Methods
- (void)getNewsTypes
{
    NSString* parameters = [NSString stringWithFormat:@"key=%@&id", KEY];
    NSURLRequest * request = [self getURLRequestForService:kGETNEWSTYPES WithParameters:parameters];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData * data, NSError * e) {
        if (data) {
            NSDictionary * list = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
            NSArray * NewsTypesList = list[ntNEWSTYPES];
            
            if ([NSJSONSerialization isValidJSONObject:list]) {
                [NewsTypes removeAllObjects];
                //for (NSString * key in list) NSLog(@"%@",key);
                //for (NSString * key in list) NSLog(@"Key:%@ Contents:%@",key ,list[key]);
                
                for (NSDictionary * entry in NewsTypesList) {
                    NewsType * item = [[NewsType alloc] init];
                    [item setID:(uint)entry[ntID]];
                    [item setTitle:entry[ntTYPE]];
                    
                    [NewsTypes addObject:item];
                    item = nil;
                }
                [self update];
            }
        }
    }];
}

- (void)getNewsListForNewsType:(uint)type
{
    NSString* parameters = [NSString stringWithFormat:@"key=%@&idNewsType=%d&pageSize=1&nbrePage=5",KEY, type];
    NSURLRequest * request = [self getURLRequestForService:kNEWSLIST WithParameters:parameters];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData * data, NSError * e) {
        if (data) {
            NSDictionary * list = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
            //NSArray * NewsList = list[];
            
            if ([NSJSONSerialization isValidJSONObject:list]) {
                //for (NSString * key in list) NSLog(@"%@",key);
                for (NSString * key in list) NSLog(@"Key:%@ Contents:%@",key ,list[key]);
                
                /*for (NSDictionary * entry in news) {
                    <#statements#>
                }*/
            }
        }
    }];
}

- (NSURLRequest *)getURLRequestForService:(NSString *)function WithParameters:(NSString *)params
{
    NSURL * ServiceURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",FLYSURF_WEBSERVICE,function]];
    NSData * requestData = [NSData dataWithBytes:[params UTF8String] length:[params length]];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:ServiceURL];
    [request addValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request addValue: @"http://tempuri.org/NewsList" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: @"dotnet.flysurf.com" forHTTPHeaderField:@"Host"];
	[request addValue: [NSString stringWithFormat:@"%@", requestData] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:@"POST"];
    [request setHTTPBody:requestData];
    
    return request;
}

- (void)update
{
    /*for (NewsType * entry in NewsTypes) {
        NSLog(@"%@",entry.Title);
    }*/
}

#pragma mark - View Methods
- (void)viewDidLoad
{
    NewsTypes = [[NSMutableArray alloc] init];
    NewsList = [[NSMutableArray alloc] init];
    
    [self getNewsListForNewsType:8];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
