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
#import "CommentCell.h"
#import "addCommentsController.h"
#import "commentsController.h"

#define CELL_ID @"CommentCell"
#define FLYSURF_WEBSERVICE @"http://dotnet.flysurf.com/services/news.asmx"
#define KEY @"@Fly$5F%"
#define kGETNEWSDETAILS @"GetNewsTypes"
#define kLOGIN @"Login"



#define kGETNEWSDETAILS @"GetNewsTypes"

@interface newsDetailsController ()
@property (weak, nonatomic) IBOutlet UITableView *CommentsTable;
@property (nonatomic, retain) IBOutlet UILabel *newsDate;
@property (nonatomic, retain) IBOutlet UIWebView *newsImage;
@property (nonatomic, retain) IBOutlet UIWebView *newsText;
@property (nonatomic, retain) IBOutlet UILabel *newsTitle;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UILabel* commentsCount;
@property (nonatomic, retain) IBOutlet UIButton* commentButton;
@property (nonatomic, retain) IBOutlet UIImageView* commentButtonBG;
@property (nonatomic, strong) NSString* Username;
@property (nonatomic, strong) NSString* Password;
@property (nonatomic, strong) NSString* PersonID;
@property (nonatomic,strong) News* news;
@property (nonatomic,strong) NSMutableArray * CommentsList;

- (NSURLRequest *)getLoginRequestForService:(NSString *)function WithParameters:(NSString *)params;
- (IBAction) showComments;
@end

@implementation newsDetailsController


@synthesize newsImage, newsTitle, newsDate, news, newsText, scrollView, commentsCount, CommentsList, CommentsTable, Username, Password, PersonID, commentButton, commentButtonBG;

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
    [format setDateFormat:@"dd/MM/yyyy 'à' HH'H'mm"];

    [cell.Author setText:[NSString stringWithFormat:@"%@", newsCommentForCell.Pseudonym]];
    [cell.Date setText:[NSString stringWithFormat:@"- %@",[format stringFromDate:newsCommentForCell.Date]]];
    [cell.Details setText:[NSString stringWithFormat:@"%@", newsCommentForCell.Comments]];
    [cell setSelectedBackgroundView:v];
    
    //NSLog(@"TBViewCell ID - %d, Author - %@", newsCommentForCell.ID, newsCommentForCell.Pseudonym);
    
    v = nil;
    format = nil;
    
    return cell;
}

- (void) assignNewsDetails{
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterMediumStyle];
    
    NSString* dateString = [NSString stringWithFormat: @"Publié le %@", [format stringFromDate:news.Date]];
    [newsDate setText: dateString];
    [newsTitle setText:news.Title];
    [newsImage loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:news.Pic]]];
    
    //get the text and place it on a webview
    float totalHeight = 100;
    
    NSString* htmlContentString = [NSString stringWithFormat:
                                   @"<html>"
                                   "<style type=\"text/css\">"
                                   "body { background-color:transparent; font-size:14px; text-align: justify;}"
                                   "</style>"
                                   "<body>"
                                   "<p>%@</p>"
                                   "</body></html>", news.Text];
    
    CGSize expectedLabelSize = [htmlContentString sizeWithFont:[UIFont systemFontOfSize:14]
                                            constrainedToSize:CGSizeMake(280, 600)
                                                lineBreakMode:NSLineBreakByCharWrapping];
    
    CGRect newFrame = newsText.frame;
    newFrame.size.height = expectedLabelSize.height;

    if (news.Text == NULL) totalHeight = 100;
    else totalHeight = totalHeight + expectedLabelSize.height + 80;
    NSLog(@"total height %f", totalHeight);
    
    newsText.frame = newFrame;
    
    [newsText loadHTMLString:htmlContentString baseURL:nil];
    
    newFrame.size.width = 90;
    newFrame.size.height = 30;
    newFrame.origin.y = totalHeight - 60.0;
    newFrame.origin.x = 20.0;
    
    commentButton.frame = newFrame;
    
    newFrame.size.height = 40;
    newFrame.size.width = 320;
    newFrame.origin.x = 0;
    newFrame.origin.y = commentButton.frame.origin.y - 5;
    
    commentButtonBG.frame = newFrame;
    
    NSLog(@"comment button x y %f, %f", commentButton.frame.origin.x, commentButton.frame.origin.y);
    
    //set Comments Count
    //[commentsCount setText:[NSString stringWithFormat:@"%d Comments", news.Comments]];
    
    [scrollView setContentSize:CGSizeMake(320, totalHeight)];
    
}

-(IBAction)back {
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction) addNewsComment:(id)sender{
    UIAlertView* message = [[UIAlertView alloc] initWithTitle:@"Flysurf Login" message:@"Connectez-vous pour continuer" delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"Entrer", nil];
    message.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Entrer"])
    {
        UITextField *uname = [alertView textFieldAtIndex:0];
        UITextField *pword = [alertView textFieldAtIndex:1];
        
        Username = uname.text;
        Password = pword.text;
        NSLog(@"Username: %@\nPassword: %@", Username, Password);
        
        [self checkCredentials];
    }
}

- (void)checkCredentials{
    NSString* parameters = [NSString stringWithFormat:@"key=%@&email=%@&password=%@", KEY, Username, Password];
    NSURLRequest * request = [self getLoginRequestForService:kLOGIN WithParameters:parameters];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData * data, NSError * e) {
        if (data) {
            
            NSDictionary * list = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
            int ID = [list[@"ID_PERSONS"] intValue];
            
            PersonID = [NSString stringWithFormat:@"%d", ID];
            
            if (ID == -1) {
                UIAlertView* message = [[UIAlertView alloc] initWithTitle:@"Login Unsuccessful" message:@"Incorrect Email or Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                message.alertViewStyle = UIAlertViewStyleDefault;
                [message show];
            }
            
            else{
                [self showForm];
            }
        }
    }];
    
}

- (NSURLRequest *)getLoginRequestForService:(NSString *)function WithParameters:(NSString *)params
{
    NSURL * ServiceURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",FLYSURF_WEBSERVICE,function]];
    NSData * requestData = [NSData dataWithBytes:[params UTF8String] length:[params length]];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:ServiceURL];
    [request addValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request addValue: @"http://tempuri.org/Login" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: @"dotnet.flysurf.com" forHTTPHeaderField:@"Host"];
	[request addValue: [NSString stringWithFormat:@"%@", requestData] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:@"POST"];
    [request setHTTPBody:requestData];
    
    return request;
}

- (void) showForm{
    addCommentsController* addComment = [[addCommentsController alloc] initWithNews: news withPersonID:PersonID];
    [addComment setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:addComment animated:YES];


}


- (IBAction) showComments{
    
    commentsController* comments = [[commentsController alloc] initWithNews:news];
    [comments setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:comments animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CommentsList = [[NSMutableArray alloc] init];
    [self assignNewsDetails];
    [CommentsTable reloadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
