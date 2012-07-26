//
//  ImageCache.m
//  TimeLimitFree
//
//  Created by lujiaolong on 11-8-24.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import "ImageCache.h"

#define kLISTCOUNT 200
#define kDETAILCOUNT 50

@implementation ImageCache

+(BOOL)saveToCacheWithID:(NSString *)identity andImg:(UIImage *)image andDir:(NSInteger)dir{
	NSString *_docDir = [ImageCache parseDir:dir];
	[[NSFileManager defaultManager] createDirectoryAtPath:_docDir attributes:nil];
	
	NSString *_filePath = [NSString stringWithFormat:@"%@/%@",_docDir,identity];

	NSData *_imgData = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];
	return [_imgData writeToFile:_filePath atomically:YES];
}

+(UIImage *)loadFromCacheWithID:(NSString *)identity andDir:(NSInteger)dir{
		
	NSString *_imgPath = [self getPersistencePathWithID:identity andDir:dir];
	if([[NSFileManager defaultManager] fileExistsAtPath:_imgPath]){
		return [UIImage imageWithContentsOfFile:_imgPath];
	}
	else{
		return nil;
	}
}

// 获取文件夹中的文件
+(NSString *)getPersistencePathWithID:(NSString *)identity andDir:(NSInteger)dir{
	NSString *_docDir = [ImageCache parseDir:dir];
	NSString *_filePath = [NSString stringWithFormat:@"%@/%@",_docDir,identity];
	return _filePath;
}

/*
// 缓存一周的时间。。    
+(void)checkCache{
	NSArray *_dirs = [NSArray arrayWithObjects:DIRSTR_LIST,DIRSTR_DETAIL,nil];
	for(NSString *_aDir in _dirs){
		NSString *_docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		_docDir = [_docDir stringByAppendingString:_aDir];
		
		NSFileManager *_fm = [NSFileManager defaultManager];
		// 返回 文件夹中的 文件数
		NSArray *_files = [_fm contentsOfDirectoryAtPath:_docDir error:NULL];
		
		if([_files count] > 200){
			[_fm removeItemAtPath:_docDir error:NULL];
			return;
		}
		
		for(NSString *_fileName in _files){
			NSString *_path = [NSString stringWithFormat:@"%@/%@",_docDir,_fileName];
			NSDate *_mDate = [[_fm attributesOfItemAtPath:_path error:NULL] fileModificationDate];
			if(_mDate != nil){
				if([_mDate timeIntervalSinceNow] < -(7 * 24 * 3600))
					[_fm removeItemAtPath:_path error:NULL];
			}
		}
	}
}
*/

+ (void)checkCache {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	NSArray *dirs = [NSArray arrayWithObjects:DIRSTR_LIST,DIRSTR_DETAIL,nil];
	NSFileManager *fm = [NSFileManager defaultManager];
    NSString *bundleIdentifier = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
   
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
	for(NSString *dir in dirs){
        //删除以前缓存在Document目录下的全部缓存
        [fm removeItemAtPath:[docDir stringByAppendingString:dir] error:NULL];
        
        //检测Cache目录下的缓存数量（list 图片大于200张则删除、detail 大图大于50张则删除）           ~/listImage12/    ~/DetailImage/.
        
        docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        docDir = [docDir stringByAppendingString:dir];
        
        NSArray *files = [fm contentsOfDirectoryAtPath:docDir error:NULL];
        
        //列表Logo大于200张  详细页大图大于50张  已下载记录大于50张
        
        /*
        if([dir isEqualToString:DIRSTR_LIST] && [files count] > kLISTCOUNT){
            NSLog(@"清列表缓存");
            
            if([files count] > 10){
                for(int i = 10; i < [files count]; i ++){
                    NSString *fileName = [NSString stringWithFormat:@"%@",[files objectAtIndex:i]];
                    docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    docDir = [docDir stringByAppendingString:DIRSTR_LIST];
                    docDir = [docDir stringByAppendingFormat:@"/%@",fileName];
                    
                    [fm removeItemAtPath:docDir error:NULL];
                }
            }
        }
        
        else if([dir isEqualToString:DIRSTR_DETAIL] && [files count] > kDETAILCOUNT){
            NSLog(@"清详细页缓存");
            [fm removeItemAtPath:docDir error:NULL];
        }
        */
       
        if(([dir isEqualToString:DIRSTR_LIST] && [files count] > kLISTCOUNT) || (![dir isEqualToString:DIRSTR_DETAIL] && [files count] > kDETAILCOUNT)){
            if([dir isEqualToString:DIRSTR_LIST]){
                NSLog(@"清列表页缓存");
            }
            else if([dir isEqualToString:DIRSTR_DETAIL]){
                NSLog(@"清详情页图片缓存");
            }
            [fm removeItemAtPath:docDir error:NULL];
        }
    }
    
    docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    docDir = [docDir stringByAppendingFormat:@"/%@",bundleIdentifier];
    [fm removeItemAtPath:docDir error:NULL];
    
    [pool release];
}

+(void)removeAllCache{
    NSArray *dirs = [NSArray arrayWithObjects:DIRSTR_LIST,DIRSTR_DETAIL,nil];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSString *docDir;
    
    for(NSString *dir in dirs){
        docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        docDir = [docDir stringByAppendingFormat:@"%@",dir];
        [fm removeItemAtPath:docDir error:NULL];
    }
    
    docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    [fm removeItemAtPath:docDir error:NULL];
}

+(BOOL)haveImageWithPath:(NSString *)path andDir:(NSInteger)dir{
	NSString *_docDir = [ImageCache parseDir:dir];
	path = [NSString stringWithFormat:@"%@/%@",_docDir,path];
	return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

// 根据不同的int值返回不同的 文档路径
+(NSString *)parseDir:(NSInteger)dir{
	
	NSString *_docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	switch(dir){
		case DIR_LIST:
			_docDir = [_docDir stringByAppendingString:DIRSTR_LIST];
			break;
		case DIR_DETAIL:
			_docDir = [_docDir stringByAppendingString:DIRSTR_DETAIL];
			break;

        case DIR_SHOTPICTURE:
            _docDir = [_docDir stringByAppendingString:DIRSTR_SHOTPICTURE];
            
		default:
			break;
	}
	
	return _docDir;
}

@end
