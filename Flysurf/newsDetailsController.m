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
#import "addCommentsController.h"

#define CELL_ID @"NewsCell"
#define FLYSURF_WEBSERVICE @"http://dotnet.flysurf.com/services/news.asmx"
#define KEY @"@Fly$5F%"

#define kGETNEWSDETAILS @"GetNewsTypes"

@interface newsDetailsController ()
@property News* news;
-(id)initWithNews:(News *) newsForDisplay;
-(IBAction)back:(id)sender;
-(IBAction) addNewsComment:(id)sender;
@end

@implementation newsDetailsController

@synthesize newsImage, newsTitle, newsDate, newsDetails, news, newsText, scrollView, commentsCount;

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
        
        NSLog(@"TITLE: %@", newsForDisplay.Title);
    }
    return self;
}

- (void) assignNewsDetails{
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterMediumStyle];
    
    NSString* dateString = [NSString stringWithFormat: @"Publié le %@", [format stringFromDate:news.Date]];
    [newsDate setText: dateString];
    [newsTitle setText:news.Title];
    [newsImage loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:news.Pic]]];
    
    //get the text and place it on a webview
    int totalHeight = 0;
    
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
    [commentsCount setText:[NSString stringWithFormat:@"%d Comments", news.Comments]];
    
    totalHeight = newsText.frame.origin.y + (newsText.frame.size.height/2);
    [scrollView setContentSize:CGSizeMake(320, 1200)];
}

-(IBAction)back:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction) addNewsComment:(id)sender{
    addCommentsController* addComment = [[addCommentsController alloc] initWithNews: news];
    [addComment setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:addComment animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self assignNewsDetails];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
