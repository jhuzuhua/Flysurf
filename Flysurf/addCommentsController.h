//
//  addCommentsController.h
//  Flysurf
//
//  Created by Joshua Glenn Paldo on 12/16/12.
//  Copyright (c) 2012 Joshua Glenn Paldo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface addCommentsController : UIViewController{
    IBOutlet UITextView *newsTitle;
}

@property (nonatomic, retain) IBOutlet UITextView *newsTitle;
- (id) initWithNews: (News*) newsData;
@end