//
//  NewsType.h
//  Flysurf
//
//  Created by Garri Adrian Nablo on 12/9/12.
//  Copyright (c) 2012 Joshua Glenn Paldo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ntNEWSTYPES @"NEWS_TYPES"
#define ntID @"ID_NEWS_TYPES"
#define ntTYPE @"LIB_NEWS_TYPES"

@interface NewsType : NSObject
@property(nonatomic,assign) uint ID;
@property(nonatomic,strong) NSString * Title;
@end
