//
//  newsDetailsController.m
//  Flysurf
//
//  Created by Joshua Glenn Paldo on 12/13/12.
//  Copyright (c) 2012 Joshua Glenn Paldo. All rights reserved.
//

#import "newsDetailsController.h"
#import "News.h"
#import "NewsComment.h"
#import "NewsType.h"
#import "NewsCell.h"
<<<<<<< HEAD
#import "addCommentsController.h"

#define CELL_ID @"NewsCell"
#define FLYSURF_WEBSERVICE @"http://dotnet.flysurf.com/services/news.asmx"
#define KEY @"@Fly$5F%"

#define kGETNEWSDETAILS @"GetNewsTypes"
=======
#import "CommentCell.h"
#import "addCommentsController.h"

#define CELL_ID @"NewsCell"
#define FLYSURF_WEBSERVICE @"http://dotnet.flysurf.com/services/news.asmx"
#define KEY @"@Fly$5F%"

#define kGETNEWSDETAILS @"GetNewsTypes"

@interface newsDetailsController ()
@property News* news;
@property(nonatomic,strong) NSMutableArray * CommentsList;

-(id)initWithNews:(News *) newsForDisplay;
-(IBAction)back:(id)sender;
-(IBAction) addNewsComment:(id)sender;
>>>>>>> 6f8a4d10bbe3223e45fe343b951fd83eda9b3a46

@interface newsDetailsController ()
@property News* news;
-(id)initWithNews:(News *) newsForDisplay;
-(IBAction)back:(id)sender;
-(IBAction) addNewsComment:(id)sender;
@end

@implementation newsDetailsController

<<<<<<< HEAD
@synthesize newsImage, newsTitle, newsDate, newsDetails, news, newsText, scrollView, commentsCount;
=======
@synthesize newsImage, newsTitle, newsDate, newsDetails, news, newsText, scrollView, commentsCount, CommentsList, CommentsTable;
>>>>>>> 6f8a4d10bbe3223e45fe343b951fd83eda9b3a46

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNews:(News*) newsForDisplay
{
    self = [super initWithNibName:@"newsDetailsController" bundle:Nil];
    if (self) {
        // Custom initialization
        
        news = newsForDisplay;
<<<<<<< HEAD
        
        NSLog(@"TITLE: %@", newsForDisplay.Title);
=======
>>>>>>> 6f8a4d10bbe3223e45fe343b951fd83eda9b3a46
    }
    return self;
}

<<<<<<< HEAD
=======
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //get the specific news for the specific cell clicked.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return news.CommentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsComment * newsCommentForCell = CommentsList[indexPath.row];
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CommentsCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    [v setBackgroundColor:[UIColor colorWithRed:1.03 green:0.32 blue:0.08 alpha:1]];
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd-MM-yyyy"];
    
    [cell.Author setText:[NSString stringWithFormat:@"%@", newsCommentForCell.Pseudonym]];
    [cell.Date setText:[format stringFromDate:newsCommentForCell.Date]];
    [cell.Details setText:[NSString stringWithFormat:@"%@", newsCommentForCell.Comments]];
    [cell setSelectedBackgroundView:v];
    
    NSLog(@"TBViewCell ID - %d, Author - %@", newsCommentForCell.ID, newsCommentForCell.Pseudonym);
    
    v = nil;
    format = nil;
    
    return cell;
}

>>>>>>> 6f8a4d10bbe3223e45fe343b951fd83eda9b3a46
- (void) assignNewsDetails{
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterMediumStyle];
    
    NSString* dateString = [NSString stringWithFormat: @"Publié le %@", [format stringFromDate:news.Date]];
    [newsDate setText: dateString];
    [newsTitle setText:news.Title];
    [newsImage loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:news.Pic]]];
    
    //get the text and place it on a webview
<<<<<<< HEAD
    int totalHeight = 0;
=======
    int totalHeight = 200;
>>>>>>> 6f8a4d10bbe3223e45fe343b951fd83eda9b3a46
    
    NSString* htmlContentString = [NSString stringWithFormat:
                                   @"<html>"
                                   "<style type=\"text/css\">"
                                   "body { background-color:transparent; font-size:16px; text-align: justify;}"
                                   "</style>"
                                   "<body>"
                                   "<p>%@</p>"
                                   "</body></html>", news.Text];
    
    [newsText loadHTMLString:htmlContentString baseURL:nil];
    
    //set Comments Count
<<<<<<< HEAD
    [commentsCount setText:[NSString stringWithFormat:@"%d Comments", news.Comments]];
    
    totalHeight = newsText.frame.origin.y + (newsText.frame.size.height/2);
    [scrollView setContentSize:CGSizeMake(320, 1200)];
=======
    [commentsCount setText:[NSString stringWithFormat:@"%d Comments", news.CommentList.count]];
    
    //display comments
    NSArray* TempCommentsList = news.CommentList;
    
    NSLog(@"%@", TempCommentsList);
    
    for (NewsComment *comment in TempCommentsList){
        [CommentsList addObject:comment];
        NSLog(@"ID - %d, Author - %@", comment.ID, comment.Pseudonym);
        [self update];
    }
    
    //end of processing newsComments
    
    totalHeight = totalHeight + newsText.frame.origin.y + (newsText.frame.size.height/2);
    [scrollView setContentSize:CGSizeMake(320, 1100)];
>>>>>>> 6f8a4d10bbe3223e45fe343b951fd83eda9b3a46
}

-(IBAction)back:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction) addNewsComment:(id)sender{
    addCommentsController* addComment = [[addCommentsController alloc] initWithNews: news];
    [addComment setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
<<<<<<< HEAD
    [self presentModalViewController:addComment animated:NO];
=======
    [self presentModalViewController:addComment animated:YES];
}

- (void)update
{
    [CommentsTable reloadData];
    
    NSLog(@"updating...");
>>>>>>> 6f8a4d10bbe3223e45fe343b951fd83eda9b3a46
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
<<<<<<< HEAD
=======
    CommentsList = [[NSMutableArray alloc] init];
>>>>>>> 6f8a4d10bbe3223e45fe343b951fd83eda9b3a46
    [self assignNewsDetails];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
