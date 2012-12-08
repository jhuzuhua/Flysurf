//
//  ViewController.m
//  Flysurf
//
//  Created by Joshua Glenn Paldo on 12/7/12.
//  Copyright (c) 2012 Joshua Glenn Paldo. All rights reserved.
//

#import "ViewController.h"
#import "SDZnews.h"

#define kKEY @"@Fly$5F%"

@interface ViewController ()

@end

@implementation ViewController

- (void)onload:(id)value {
    NSError * e;
    NSData * retData = [NSData dataWithContentsOfMappedFile:value];
    
    if (retData) {
        NSDictionary * list = [NSJSONSerialization JSONObjectWithData:retData options:NSJSONReadingMutableContainers error:&e];
        for (NSString * key in list) NSLog(@"Key:%@ Contents:%@",key ,list[key]);
    }
    
    //NSLog(@"Load:%@",value);
}

- (void)onerror:(NSError *)error {
    NSLog(@"Error:%@",error);
}

- (void)onfault:(SoapFault *)fault {
    NSLog(@"Fault:%@",fault);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*SDZnews * news = [SDZnews service];
    [news setLogging:YES];
    [news GetNewsTypes:self key:kKEY];
    [news NewsList:self key:kKEY idNewsType:11 pageSize:10 nbrePage:1];*/
    
    NSString* requestStr = [NSString stringWithFormat:@"key=%@&idNewsType=8&pageSize=1&nbrePage=5", kKEY];
    
    
    NSData *myRequestData = [ NSData dataWithBytes: [ requestStr UTF8String ] length: [ requestStr length ] ];
    
	NSURL *url = [NSURL URLWithString:@"http://dotnet.flysurf.com/services/news.asmx/NewsList"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	//NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    NSString *msgLength = [NSString stringWithFormat:@"%@", myRequestData];
    
	//[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"]; //use this if text/xml
    [theRequest addValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"]; //use this for POST method
	[theRequest addValue: @"http://tempuri.org/NewsList" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: @"dotnet.flysurf.com" forHTTPHeaderField:@"Host"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	//[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [theRequest setHTTPBody: myRequestData];
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if( theConnection ) {
        NSLog(@"theConnection is SUCCESSFUL");
	}
	else {
		NSLog(@"theConnection is NULL");
	}
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
