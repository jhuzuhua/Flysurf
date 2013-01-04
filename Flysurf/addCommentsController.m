//
//  addCommentsController.m
//  Flysurf
//
//  Created by Joshua Glenn Paldo on 12/16/12.
//  Copyright (c) 2012 Joshua Glenn Paldo. All rights reserved.
//

#import "addCommentsController.h"
#import "News.h"
#define FLYSURF_WEBSERVICE @"http://dotnet.flysurf.com/services/news.asmx"
#define KEY @"@Fly$5F%"

#define kADDCOMMENTS @"AddNewsComment"

@interface addCommentsController ()
@property (nonatomic,strong) News* news;
@property (nonatomic, strong) NSString* PersonID;

@property(nonatomic,retain) IBOutlet UILabel *newsTitle;
@property (nonatomic, strong) IBOutlet UITextView* newsContent;
@property (nonatomic, strong) IBOutlet UITextField* title;

- (NSURLRequest *)getURLRequestForService:(NSString *)function WithParameters:(NSString *)params;
@end

@implementation addCommentsController

@synthesize newsTitle, news, PersonID, newsContent, title;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithNews: (News*) newsData withPersonID: (NSString*) personID{
    self = [super initWithNibName:@"addCommentsController" bundle:nil];
    if (self) {
        // Custom initialization
        news = newsData;
        PersonID = [NSString stringWithFormat:@"%@" , personID];
        
        NSLog(@"Logged in to comment with ID %@", PersonID);
    }
    return self;
}

- (NSURLRequest *)getURLRequestForService:(NSString *)function WithParameters:(NSString *)params
{
    NSURL * ServiceURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",FLYSURF_WEBSERVICE,function]];
    NSData * requestData = [NSData dataWithBytes:[params UTF8String] length:[params length]];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:ServiceURL];
    [request addValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request addValue: @"http://tempuri.org/AddNewsComment" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: @"dotnet.flysurf.com" forHTTPHeaderField:@"Host"];
	[request addValue: [NSString stringWithFormat:@"%@", requestData] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:@"POST"];
    [request setHTTPBody:requestData];
    
    return request;
}

- (IBAction) addCommentsData: (id) sender{
    NSString *commentsText = [NSString stringWithFormat:@"%@", newsContent.text];
    NSString *idForNews = [NSString stringWithFormat:@"%d", news.ID];
    
    NSLog(@"Content = %@", commentsText);
    
    NSString* parameters = [NSString stringWithFormat:@"key=%@&idNews=%@&idPerson=%@&comment=%@",KEY, idForNews, PersonID, commentsText];
    NSURLRequest * request = [self getURLRequestForService:kADDCOMMENTS WithParameters:parameters];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData * data, NSError * e) {
        if (response) {
            
            UIAlertView* message = [[UIAlertView alloc] initWithTitle:@"Successfully Added A Comment" message:@"Please wait for the administrator to approve the comment you submitted." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            message.alertViewStyle = UIAlertViewStyleDefault;
            [message show];
            
            NSLog(@"Data: %@", data);
            NSLog(@"Response: %@", response);
            NSLog(@"Error: %@", e);
        }
    }];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText: (NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [newsTitle setText:[NSString stringWithFormat:@"%@", news.Title]];
    
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)back {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
