//
//  addCommentsController.h
//  Flysurf
//
//  Created by Joshua Glenn Paldo on 12/16/12.
//  Copyright (c) 2012 Joshua Glenn Paldo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface addCommentsController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate ,UIImagePickerControllerDelegate>

- (id) initWithNews: (News*) newsData withPersonID: (NSString*) personID;

@end