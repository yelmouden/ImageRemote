//
//  RemoteCacheManager.h
//  RemoteImages
//
//  Created by Yassin El Mouden on 05/02/13.
//  Copyright (c) 2013 Yassin El Mouden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemoteCacheManager : NSObject
+(RemoteCacheManager *)sharedInstance;
-(BOOL)doesExist:(NSString *)fileName;
-(void)saveImage:(UIImage *)img withName:(NSString *)fileName;
-(UIImage *)getImageFromCache:(NSString *)fileName;
@end
