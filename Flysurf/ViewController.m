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
#import "CODialog.h"

#define CELL_ID @"NewsCell"
#define FLYSURF_WEBSERVICE @"http://dotnet.flysurf.com/services/news.asmx"
#define KEY @"@Fly$5F%"

#define kGETNEWSTYPES @"GetNewsTypes"
#define kNEWSLIST @"NewsList"
#define kLOGIN @"Login"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView * NewsTable;
@property (weak, nonatomic) IBOutlet UILabel * NewsTypeChoice;
@property (weak, nonatomic) IBOutlet UIView * ActivityIndicator;
@property (weak, nonatomic) IBOutlet UIPickerView * NewsPicker;
@property (weak, nonatomic) IBOutlet UINavigationBar * PickerDoneBar;
//@property (nonatomic, strong) CODialog *dialog;
@property (nonatomic, strong) NSString* Username;
@property (nonatomic, strong) NSString* Password;
@property (nonatomic, strong) NSString* PersonID;
@property (nonatomic, strong) NSString* newsTypeID;

@property(nonatomic,strong) NSMutableArray * NewsTypes;
@property(nonatomic,strong) NSMutableArray * NewsList;
@property(nonatomic,assign) uint NewsTypeChosen;

- (void)getNewsTypes;
- (void)getNewsListForNewsType:(uint)type;
- (NSURLRequest *)getURLRequestForService:(NSString *)function WithParameters:(NSString *)params;
- (NSURLRequest *)getLoginRequestForService:(NSString *)function WithParameters:(NSString *)params;
- (void)checkCredentials;
- (void)showForm;
@end

@implementation ViewController

@synthesize PickerDoneBar, NewsPicker, NewsTypeChosen;
@synthesize NewsTable, NewsTypeChoice, ActivityIndicator;
@synthesize NewsTypes, NewsList, Username, Password, PersonID, newsTypeID;

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * title;

    if (NewsTypes.count == row) {
        title = @"All News";
    }
    else {
        NewsType * typeChosen = NewsTypes[row];
        title = typeChosen.Title;
    }
    
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NewsTypeChosen = row;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return NewsTypes.count + 1;
}

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
                    [item setID:(uint)[entry[ntID] intValue]];
                    [item setTitle:entry[ntTYPE]];
                    
                    [NewsTypes addObject:item];
                    item = nil;
                }
                //for (NewsType * entry in NewsTypes) { NSLog(@"%@",entry.Title); }
                NewsType * firstType = NewsTypes[0];

                [NewsTypeChoice setText:firstType.Title];
                
                newsTypeID = [NSString stringWithFormat:@"%d", firstType.ID];
                [self getNewsListForNewsType:firstType.ID];
                [NewsPicker reloadAllComponents];
            }
        }
    }];
}

- (void)getNewsListForNewsType:(uint)type
{
    NSString* parameters = [NSString stringWithFormat:@"key=%@&idNewsType=%d&pageSize=10&nbrePage=1",KEY, type];
    NSURLRequest * request = [self getURLRequestForService:kNEWSLIST WithParameters:parameters];
 
    [ActivityIndicator setHidden:NO];
    
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
                    [itemType setID:(uint)[entry[ntID] intValue]];
                    [itemType setTitle:entry[ntTYPE]];
                    
                    News * item = [[News alloc] init];
                    [item setID:(uint)[entry[nID] intValue]];
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
                            [itemComment setID:(uint)[comment[ncID] intValue]];
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
                                    
                    [NewsTable reloadData];
                    [ActivityIndicator setHidden:YES];
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

#pragma mark - IBActions
- (IBAction)pickNewsType
{
    [NewsPicker setHidden:NO];
    [PickerDoneBar setHidden:NO];
}

- (IBAction)selectNewsType
{
    if (NewsTypeChosen == NewsTypes.count) {
        [NewsTypeChoice setText:@"All News"];
        newsTypeID = @"0";
        [self getNewsListForNewsType:0];
    }
    else {
        NewsType * typeChosen = NewsTypes[NewsTypeChosen];
        
        [NewsTypeChoice setText:typeChosen.Title];
        //track the current NewsType ID
        newsTypeID = [NSString stringWithFormat:@"%d", typeChosen.ID];
        [self getNewsListForNewsType:typeChosen.ID];
    }
    
    [NewsPicker setHidden:YES];
    [PickerDoneBar setHidden:YES];
}

- (IBAction) addNews: (id) sender{

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

#pragma mark - Login Methods
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
                PersonID = [NSString stringWithFormat:@"%d", ID];
                [self showForm];
            }
        }
    }];
    
}

- (void) showForm{
    
    addNewsController* addNews = [[addNewsController alloc] initWithPersonID:PersonID withNewsType:newsTypeID];
    [addNews setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self presentModalViewController:addNews animated:YES];
}

#pragma mark - View Methods
- (void)viewDidLoad
{
    NewsTypes = [[NSMutableArray alloc] init];
    NewsList = [[NSMutableArray alloc] init];
    
    [self getNewsTypes];
    //[ActivityIndicator setHidden:YES];
    //[self getNewsListForNewsType:11];
    
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
