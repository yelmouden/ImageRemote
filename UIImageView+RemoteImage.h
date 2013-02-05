//
//  UIImageView+RemoteImage.h
//  RemoteImages
//
//  Created by Vincent GUINIER on 01/02/13.
//  Copyright (c) 2013 Yassin El Mouden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteImageManager.h"

@interface UIImageView (RemoteImage)
//méthode permettant d'affecter une image 
-(void)setImageFromUrl:(NSString *)url placeholderImage:(UIImage *)image withIndicator:(BOOL)hasIndicator doesCacheImage:(BOOL)cache;
@end
