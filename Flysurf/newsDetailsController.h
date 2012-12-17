//
//  newsDetailsController.h
//  Flysurf
//
//  Created by Joshua Glenn Paldo on 12/13/12.
//  Copyright (c) 2012 Joshua Glenn Paldo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface newsDetailsController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UILabel *newsDate;
    IBOutlet UIWebView *newsImage;
    IBOutlet UIWebView *newsText;
    IBOutlet UITextView *newsTitle;
    IBOutlet UITextView *newsDetails;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UILabel* commentsCount;
}

@property (weak, nonatomic) IBOutlet UITableView *CommentsTable;
@property (nonatomic, retain) IBOutlet UILabel *newsDate;
@property (nonatomic, retain) IBOutlet UIWebView *newsImage;
@property (nonatomic, retain) IBOutlet UIWebView *newsText;
@property (nonatomic, retain) IBOutlet UITextView *newsTitle;
@property (nonatomic, retain) IBOutlet UITextView *newsDetails;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UILabel* commentsCount;

-(id)initWithNews:(News *) newsForDisplay;
@end