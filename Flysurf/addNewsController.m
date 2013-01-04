//
//  addNewsController.m
//  Flysurf
//
//  Created by Joshua Glenn Paldo on 12/16/12.
//  Copyright (c) 2012 Joshua Glenn Paldo. All rights reserved.
//

#import "addNewsController.h"
#define FLYSURF_WEBSERVICE @"http://dotnet.flysurf.com/services/news.asmx"
#define KEY @"@Fly$5F%"

#define kGETNEWSTYPES @"GetNewsTypes"
#define kNEWSLIST @"NewsList"
#define kLOGIN @"Login"
#define kADDNEWS @"AddNews"


@interface addNewsController ()
@property (nonatomic, strong) NSString* PersonID;
@property (nonatomic, strong) NSString* newsType;
@property (weak, nonatomic) IBOutlet UIView * ActivityIndicator;
@property (nonatomic, strong) IBOutlet UIButton* primaryImage;
@property (nonatomic, strong) UIImagePickerController *imgPicker;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) IBOutlet UITextView* newsContent;
@property (nonatomic, strong) IBOutlet UITextField* newsTitle;

- (NSURLRequest *)getURLRequestForService:(NSString *)function WithParameters:(NSString *)params;
- (IBAction) uploadPhoto: (id)sender;
- (IBAction) addNewsData: (id) sender;
- (IBAction) back;
@end

@implementation addNewsController

@synthesize PersonID, newsType, primaryImage, imgPicker, imageData, newsContent, newsTitle, ActivityIndicator;

- (id)initWithPersonID:(NSString*) personID withNewsType: (NSString *) newsTypeID
{
    self = [super initWithNibName:@"addNewsController" bundle:Nil];
    if (self) {
        // Custom initialization
        NSLog(@"Logged in with ID: %@", personID);
        NSLog(@"News Type ID: %@", newsTypeID);
        PersonID = [NSString stringWithFormat:@"%@", personID];
        newsType = [NSString stringWithFormat:@"%@", newsTypeID];
        
    }
    return self;
}


- (IBAction) back {
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText: (NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text = @"";
}

- (NSURLRequest *)getURLRequestForService:(NSString *)function WithParameters:(NSString *)params
{
    NSURL * ServiceURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",FLYSURF_WEBSERVICE,function]];
    NSData * requestData = [NSData dataWithBytes:[params UTF8String] length:[params length]];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:ServiceURL];
    [request addValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request addValue: @"http://tempuri.org/AddNews" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: @"dotnet.flysurf.com" forHTTPHeaderField:@"Host"];
	[request addValue: [NSString stringWithFormat:@"%@", requestData] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:@"POST"];
    [request setHTTPBody:requestData];
    
    return request;
}

- (IBAction) addNewsData: (id) sender{
    [ActivityIndicator setHidden:NO];
    
    NSString *title = [NSString stringWithFormat:@"%@", newsTitle.text];
    NSString *newsText = [NSString stringWithFormat:@"%@", newsContent.text];
    
    NSLog(@"Title = %@", title);
    NSLog(@"Content = %@", newsText);
    
    NSString* parameters = [NSString stringWithFormat:@"key=%@&idNewsTypes=%@&idPerson=%@&title=%@&newsText=%@&newsPicture=%@",KEY, newsType, PersonID, title, newsText, imageData];
    NSURLRequest * request = [self getURLRequestForService:kADDNEWS WithParameters:parameters];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData * data, NSError * e) {
        if (response) {
            
            UIAlertView* message = [[UIAlertView alloc] initWithTitle:@"Successfully Added News" message:@"Please wait for the administrator to approve the news you submitted." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            message.alertViewStyle = UIAlertViewStyleDefault;
            
            [message show];
            
            [ActivityIndicator setHidden:YES];
            [self dismissModalViewControllerAnimated:YES];
            
            NSLog(@"Data: %@", data);
            NSLog(@"Response: %@", response);
            NSLog(@"Error: %@", e);
        }
    }];

}

-(IBAction)uploadPhoto:(id)sender {
    self.imgPicker = [[UIImagePickerController alloc] init];
    self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imgPicker.delegate = self;
    [self presentModalViewController:self.imgPicker animated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *profileImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [primaryImage setImage:profileImage forState:UIControlStateNormal];
    
    imageData = UIImageJPEGRepresentation(profileImage, 0.7);
    
    //NSString *string = [[NSString alloc] initWithData:imageData encoding:NSUTF8StringEncoding];
    
    //NSLog(@"NSString Data of the uploaded image: %@", string);
    
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [ActivityIndicator setHidden:YES];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
