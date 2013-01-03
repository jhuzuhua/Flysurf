//
//  addNewsController.h
//  Flysurf
//
//  Created by Joshua Glenn Paldo on 12/16/12.
//  Copyright (c) 2012 Joshua Glenn Paldo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addNewsController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate ,UIImagePickerControllerDelegate>
- (id)initWithPersonID:(NSString*) personID withNewsType: (NSString *) newsType;
@end
