//
//  ImageCache.h
//  TimeLimitFree
//
//  Created by lujiaolong on 11-8-24.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DIR_LIST 1
#define DIR_DETAIL 2

#define DIR_SHOTPICTURE 3
//#define DIR_DOWN 3

#define DIRSTR_LIST @"/listImage12"
#define DIRSTR_DETAIL @"/DetailPage"

#define DIRSTR_SHOTPICTURE @"/VideoShotPicture"

//#define DIRSTR_DOWN_LOGO @"/down_logo"

@interface ImageCache : NSObject {

}

+(BOOL)saveToCacheWithID:(NSString *)identity andImg:(UIImage *)image andDir:(NSInteger)dir;

+(UIImage *)loadFromCacheWithID:(NSString *)identity andDir:(NSInteger)dir;

+(NSString *)getPersistencePathWithID:(NSString *)identity andDir:(NSInteger)dir;

+(void)checkCache;
+(void)removeAllCache;


+(BOOL)haveImageWithPath:(NSString *)path andDir:(NSInteger)dir;

+(NSString *)parseDir:(NSInteger)dir;

@end
