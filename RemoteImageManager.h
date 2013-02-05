//
//  RemoteImageManager.h
//  RemoteImages
//
//  Created by Vincent GUINIER on 01/02/13.
//  Copyright (c) 2013 Yassin El Mouden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoteImageDownloader.h"
#import "RemoteCacheManager.h"

typedef  void (^DownloadFinished)(UIImage *);

@interface RemoteImageManager : NSObject

//queue for opérations
@property (strong,nonatomic) NSOperationQueue * queue;
//cache
@property (strong,nonatomic) NSMutableDictionary * cacheImages;

//singleton
+(id)sharedInstance;
-(void)cancelAllDownloads;
-(RemoteImageDownloader *)dowloadImageAtUrl:(NSString *)url downloadsucceeded:(TelechargementImageReussi )sucess dowloadFailed:(TelechargementImageEchec)fail doesCacheImage:(BOOL)cache;
@end
