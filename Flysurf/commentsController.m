//
//  commentsController.m
//  Flysurf
//
//  Created by Joshua Glenn Paldo on 12/10/12.
//  Copyright (c) 2012 Joshua Glenn Paldo. All rights reserved.
//

#import "commentsController.h"
#import "News.h"
#import "NewsComment.h"
#import "CommentCell.h"
#import "addCommentsController.h"

#define CELL_ID @"CommentCell"
#define FLYSURF_WEBSERVICE @"http://dotnet.flysurf.com/services/news.asmx"
#define KEY @"@Fly$5F%"
#define kLOGIN @"Login"

@interface commentsController ()
@property(nonatomic,strong) NSMutableArray * CommentsList;
@property (nonatomic, retain) IBOutlet UILabel *newsDate;
@property (weak, nonatomic) IBOutlet UIView * ActivityIndicator;
@property (nonatomic, strong) NSString* Username;
@property (nonatomic, strong) NSString* Password;
@property (nonatomic, strong) NSString* PersonID;
@property (nonatomic,strong) News* news;
@property (nonatomic, assign) float height;

-(IBAction) addNewsComment:(id)sender;

@end

@implementation commentsController
@synthesize CommentsTable, CommentsList, news, newsDate;
@synthesize Username, Password, PersonID, height, ActivityIndicator;

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
    self = [super initWithNibName:@"commentsController" bundle:Nil];
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
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return news.CommentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsComment * commentForCell = CommentsList[indexPath.row];
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];

    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CommentsCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 128)];
    [v setBackgroundColor:[UIColor colorWithRed:1.03 green:0.32 blue:0.08 alpha:1]];
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@" - dd/MM/yyyy 'à' HH'H'mm"];
    
    
    
    [cell.Author setText:[NSString stringWithFormat:@"%@",commentForCell.Pseudonym]];
    CGSize expectedLabelSize = [cell.Author.text sizeWithFont:cell.Author.font
                                      constrainedToSize:CGSizeMake(70, 24)
                                          lineBreakMode:cell.Author.lineBreakMode];
    
    CGRect newFrame = cell.Date.frame;
    newFrame.origin.x = expectedLabelSize.width + 15;
    cell.Date.frame = newFrame;
    
    [cell.Date setText:[format stringFromDate:commentForCell.Date]];
    
    [cell.Details setText: [NSString stringWithFormat:@"%@", commentForCell.Comments]];
    [cell setSelectedBackgroundView:v];
    
    height = height + expectedLabelSize.height + 30;
    
    v = nil;
    format = nil;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 120;
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
        [ActivityIndicator setHidden:NO];
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
                [ActivityIndicator setHidden:YES];
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

-(IBAction)back {
    [self dismissModalViewControllerAnimated:YES];
}

- (void) showForm{
    [ActivityIndicator setHidden:YES];
    addCommentsController* addComment = [[addCommentsController alloc] initWithNews: news withPersonID:PersonID];
    [addComment setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:addComment animated:YES];
    
    
}



- (void)viewDidLoad
{
    [ActivityIndicator setHidden:YES];
    NSArray* TempCommentsList = news.CommentList;
    height = 0;
    
    CommentsList = [[NSMutableArray alloc] init];
    
    for (NewsComment *comment in TempCommentsList){
        [CommentsList addObject:comment];
        //NSLog(@"ID - %d, Author - %@", comment.ID, comment.Pseudonym);
    }
    
    //NSLog(@"comments count = %d", [CommentsList count]);
    
    [CommentsTable reloadData];
    
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterMediumStyle];
    NSString* dateString = [NSString stringWithFormat: @"Publié le %@", [format stringFromDate:news.Date]];
    [newsDate setText: dateString];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
