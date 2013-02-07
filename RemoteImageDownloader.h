//
//  RemoteImageDownloader.h
//  RemoteImages
//
//  Created by Yassin El Mouden on 01/02/13.
//  Copyright (c) 2013 Yassin El Mouden. All rights reserved.
//

#import <Foundation/Foundation.h>
//block pour telechargement d'image
typedef  void (^TelechargementImageReussi)(UIImage *,BOOL fromCache);
typedef  void (^TelechargementImageEchec)();
typedef  void (^SaveInCache)(UIImage *img,NSString * url);

@interface RemoteImageDownloader : NSOperation <NSURLConnectionDelegate>
@property (strong,nonatomic) NSString * url;
@property (nonatomic,copy) TelechargementImageReussi  telechargementReussi;
@property (nonatomic,copy) TelechargementImageEchec  telechargementEchec;
@property (nonatomic,copy) SaveInCache saveImage;
@property (nonatomic,strong) NSURLConnection * imageConnection;
@property (nonatomic,strong) NSMutableData * data;
@property (nonatomic,strong) NSRunLoop * rl;
@property (nonatomic,strong) NSPort * port;

-(id)initRemoteImageDownloader:(NSString *)url succes:(TelechargementImageReussi)sucessTelechargement echec:(TelechargementImageEchec)echecTelechargement save:(SaveInCache)saveImage ;
-(void)finishRemoteWithSuccess:(NSData *)data;
-(void)finishRemoteWithFail;

@end
