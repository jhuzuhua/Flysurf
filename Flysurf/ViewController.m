//
//  ViewController.m
//  Flysurf
//
//  Created by Joshua Glenn Paldo on 12/7/12.
//  Copyright (c) 2012 Joshua Glenn Paldo. All rights reserved.
//

#import "ViewController.h"
#import "newsDetailsController.h"
#import "addNewsController.h"
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
-(IBAction) selectCategory:(id)sender;
- (IBAction) addNews: (id) sender;
-(void) performCategorySelectionWithID: (UIButton*) sender;
- (NSURLRequest *)getURLRequestForService:(NSString *)function WithParameters:(NSString *)params;

- (void)update;
@end

@implementation ViewController

@synthesize NewsTable, NewsTypes, NewsList;

BOOL hideNewsTypes;

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //get the specific news for the specific cell clicked.
    News * newsForCell = NewsList[indexPath.row];
    
    newsDetailsController *newsDetails = [[newsDetailsController alloc] initWithNews:newsForCell];
    [newsDetails setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentModalViewController:newsDetails animated:YES];
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

    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    [v setBackgroundColor:[UIColor colorWithRed:1.03 green:0.32 blue:0.08 alpha:1]];
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd-MM-yyyy"];
    
    [cell.Thumbnail loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:newsForCell.Pic]]];
    [cell.Date setText:[format stringFromDate:newsForCell.Date]];
    [cell.Title setText:newsForCell.Title];
    [cell.Details setText:newsForCell.Text];
    [cell setSelectedBackgroundView:v];
    
    //NSLog(@"%@", newsForCell.Pic);
    
    v = nil;
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
    NSString* parameters = [NSString stringWithFormat:@"key=%@&idNewsType=%d&pageSize=10&nbrePage=1",KEY, type];
    NSURLRequest * request = [self getURLRequestForService:kNEWSLIST WithParameters:parameters];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData * data, NSError * e) {
        if (data) {
            NSDictionary * list = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
            NSArray * TempNewsList = list[nNEWS];
            
            if ([NSJSONSerialization isValidJSONObject:list]) {
                [NewsList removeAllObjects];
                //for (NSString * key in list) NSLog(@"%@",key);
                //for (NSString * key in list) NSLog(@"Key:%@ Contents:%@",key ,list[key]);
                NSDateFormatter * format = [[NSDateFormatter alloc] init];
                [format setLocale:[NSLocale systemLocale]];
                [format setFormatterBehavior:NSDateFormatterBehaviorDefault];
                [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                
                for (NSDictionary * entry in TempNewsList) {
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
                
                format = nil;
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

-(IBAction) selectCategory:(id)sender{
    CGPoint init;
    init.x = 10;
    init.y = 397;
    
    if (hideNewsTypes) {
        for(UIButton* button in self.view.subviews){
            if (button.tag == 118600512 || button.tag == 118600512 || button.tag == 118600512 || button.tag == 118600512 || button.tag == 118600512 || button.tag == 118600512 ||
                button.tag == 118600512)
                [self delete:button];
        }
        
        hideNewsTypes = NO;
    }
    
    else {
        for (NewsType* type in NewsTypes){
            UIButton *clickable = [[UIButton alloc] initWithFrame:CGRectMake(init.x, init.y, 200, 30)];
            [clickable setTitle:type.Title forState:UIControlStateNormal];
            [clickable setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [clickable setBackgroundImage:[UIImage imageNamed:@"yellow.jpg"] forState:UIControlStateNormal];
            [clickable setTag:type.ID];
            [clickable addTarget:self action:@selector(performCategorySelectionWithID:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:clickable];
            NSLog(@"tag %d", type.ID);
            init.y = init.y - 30;
            init.x = 10;
        }
        
        hideNewsTypes = YES;
    }
}

-(void) performCategorySelectionWithID: (UIButton*) sender{
    NSLog(@"sender tag = %d", sender.tag);
    [self getNewsListForNewsType:sender.tag];
}

- (IBAction) addNews: (id) sender{
    addNewsController* addNews = [[addNewsController alloc] init];
    [self presentModalViewController:addNews animated:NO];
}

#pragma mark - View Methods
- (void)viewDidLoad
{
    NewsTypes = [[NSMutableArray alloc] init];
    NewsList = [[NSMutableArray alloc] init];
    
    [self getNewsTypes];
    [self getNewsListForNewsType:11];
    
    hideNewsTypes = NO;
    
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
