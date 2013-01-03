//
//  newsDetailsController.h
//  Flysurf
//
//  Created by Joshua Glenn Paldo on 12/13/12.
//  Copyright (c) 2012 Joshua Glenn Paldo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"


@interface newsDetailsController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

-(id)initWithNews:(News *) newsForDisplay;

@end