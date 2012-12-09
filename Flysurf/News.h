//
//  News.h
//  Flysurf
//
//  Created by Garri Adrian Nablo on 12/9/12.
//  Copyright (c) 2012 Joshua Glenn Paldo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsType.h"

#define nNEWS @"NEWS"
#define nID @"ID_NEWS"
#define nTITLE @"TITLE"
#define nTEXT @"TEXT"
#define nPIC @"NEWS_PIC"
#define nDATE @"DATESTART"
#define nCOMMENTS @"NB_COMMENTS"
#define nCOMMENTSLIST @"COMMENTS_LIST"

@interface News : NSObject
@property(nonatomic,assign) uint ID;
@property(nonatomic,strong) NewsType * Type;
@property(nonatomic,strong) NSString * Title;
@property(nonatomic,strong) NSString * Text;
@property(nonatomic,strong) NSString * Pic;
@property(nonatomic,strong) NSDate * Date;
@property(nonatomic,assign) uint Comments;
@property(nonatomic,strong) NSArray * CommentList;
@end
