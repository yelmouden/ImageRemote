//
//  RemoteImageManager.m
//  RemoteImages
//
//  Created by Vincent GUINIER on 01/02/13.
//  Copyright (c) 2013 Yassin El Mouden. All rights reserved.
//

#import "RemoteImageManager.h"

@implementation RemoteImageManager
@synthesize queue = _queue;
@synthesize cacheImages = _cacheImages;

-(id)init
{
    if(self = [super init])
    {
        //création de notre queue d'opération
        self.queue = [[NSOperationQueue alloc] init];
        self.cacheImages = [[NSMutableDictionary alloc] init];
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self
                   selector:@selector(responseToMemWarning:)
                       name:UIApplicationDidReceiveMemoryWarningNotification
                     object:nil];
    }
    
    return self;
}

//création de singleton
+(id)sharedInstance
{
    static dispatch_once_t onceToken = 0;
    static RemoteImageManager * manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

-(RemoteImageDownloader *)dowloadImageAtUrl:(NSString *)url downloadsucceeded:(TelechargementImageReussi )sucess dowloadFailed:(TelechargementImageEchec)fail doesCacheImage:(BOOL)cache
{
    //on teste si l'image est déjà dans le cache
    if(cache)
    {
        if([[RemoteCacheManager sharedInstance] doesExist:[[url componentsSeparatedByString:@"/"] lastObject]])
        {
             sucess([[RemoteCacheManager sharedInstance] getImageFromCache:[[url componentsSeparatedByString:@"/"] lastObject]],YES);
            
            return nil;
        }
    }else {
        UIImage * image = [_cacheImages objectForKey:url];
        if(image)
        {
            sucess(image,YES);
            return nil;
        }
    }
    
    
    RemoteImageDownloader * downloader = [[RemoteImageDownloader alloc] initRemoteImageDownloader:url succes:sucess echec:fail save:^(UIImage *img, NSString *url) {
        
        if(cache)
        {
            [[RemoteCacheManager sharedInstance] saveImage:img withName:[[url componentsSeparatedByString:@"/"] lastObject]];
        }else {
            
            [_cacheImages setObject:img forKey:url];
        }
            
    }];
    //on ajoute notre opération à notre queue
    [_queue addOperation:downloader];
    return downloader;
        
}

-(void)responseToMemWarning:(NSNotification *)notification
{
    [_cacheImages removeAllObjects];
}

-(void)cancelAllDownloads
{
    //cancel l'ensemble des opérations
    [_queue cancelAllOperations];
    [_cacheImages removeAllObjects];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}


@end
