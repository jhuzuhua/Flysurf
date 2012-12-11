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
#import "NewsCell.h"

#define CELL_ID @"NewsCell"
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

@synthesize NewsTable, NewsTypes, NewsList;

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return NewsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    News * newsForCell = NewsList[indexPath.row];
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"DD-MM-YYYY"];
    
    [cell.Thumbnail loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:newsForCell.Pic]]];
    [cell.Date setText:[format stringFromDate:newsForCell.Date]];
    [cell.Title setText:newsForCell.Title];
    [cell.Details setText:newsForCell.Text];
    
    format = nil;
    
    return cell;
}

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
    NSString* parameters = [NSString stringWithFormat:@"key=%@&idNewsType=%d&pageSize=10&nbrePage=5",KEY, type];
    NSURLRequest * request = [self getURLRequestForService:kNEWSLIST WithParameters:parameters];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData * data, NSError * e) {
        if (data) {
            NSDictionary * list = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
            NSArray * TempNewsList = list[nNEWS];
            
            if ([NSJSONSerialization isValidJSONObject:list]) {
                [NewsList removeAllObjects];
                //for (NSString * key in list) NSLog(@"%@",key);
                //for (NSString * key in list) NSLog(@"Key:%@ Contents:%@",key ,list[key]);
                
                for (NSDictionary * entry in TempNewsList) {
                    NSDateFormatter * format = [[NSDateFormatter alloc] init];
                    [format setDateFormat:@"YYYY-MM-DDTHH:mm:ss"];
                    
                    NewsType * itemType = [[NewsType alloc] init];
                    [itemType setID:(uint)entry[ntID]];
                    [itemType setTitle:entry[ntID]];
                    
                    News * item = [[News alloc] init];
                    [item setID:(uint)entry[nID]];
                    [item setType:itemType];
                    [item setTitle:entry[nTITLE]];
                    [item setText:entry[nTEXT]];
                    [item setPic:entry[nPIC]];
                    [item setDate:[format dateFromString:entry[nDATE]]];
                    [item setComments:(uint)entry[nCOMMENTS]];
                    
                    NSMutableArray * tempList = nil;
                    if (![entry[nCOMMENTSLIST] isKindOfClass:[NSNull class]]) {
                        NSArray * commentsList = entry[nCOMMENTSLIST];
                        tempList = [NSMutableArray arrayWithCapacity:commentsList.count];
                        
                        for (NSDictionary * comment in commentsList) {
                            NewsComment * itemComment = [[NewsComment alloc] init];
                            [itemComment setID:(uint)comment[ncID]];
                            [itemComment setDate:[format dateFromString:comment[ncDATE]]];
                            [itemComment setPseudonym:comment[ncPSEUDO]];
                            [itemComment setComments:comment[ncCOMMENTS]];
                            
                            [tempList addObject:itemComment];
                            itemComment = nil;
                        }
                    }
                    
                    [item setCommentList:tempList];
                    [NewsList addObject:item];
                    item = nil;
                    
                    [self update];
                }
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
    //for (NewsType * entry in NewsTypes) { NSLog(@"%@",entry.Title); }
    
    /*for (News * entry in NewsList) {
        NSLog(@"%@",entry.Title);
        
        for (NewsComment * entryComment in entry.CommentList) {
            NSLog(@"%@",entryComment.Comments);
        }
    }*/
    
    [NewsTable reloadData];
}

#pragma mark - View Methods
- (void)viewDidLoad
{
    NewsTypes = [[NSMutableArray alloc] init];
    NewsList = [[NSMutableArray alloc] init];
    
    [self getNewsListForNewsType:11];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNewsTable:nil];
    [super viewDidUnload];
}
@end
