//
//  NewsComment.h
//  Flysurf
//
//  Created by Garri Adrian Nablo on 12/9/12.
//  Copyright (c) 2012 Joshua Glenn Paldo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsComment : NSObject

#define ncID @"ID_NEWS_COMMENTS"
#define ncDATE @"DATE_CREATE"
#define ncPSEUDO @"PSEUDO"
#define ncCOMMENTS @"COMMENTS"

@property(nonatomic,assign) uint ID;
@property(nonatomic,strong) NSDate * Date;
@property(nonatomic,strong) NSString * Pseudonym;
@property(nonatomic,strong) NSString * Comments;

@end
