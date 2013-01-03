//
//  commentsController.h
//  Flysurf
//
//  Created by Joshua Glenn Paldo on 12/10/12.
//  Copyright (c) 2012 Joshua Glenn Paldo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface commentsController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *CommentsTable;

- (id)initWithNews:(News*) newsForDisplay;
@end
