//
//  RemoteCacheManager.m
//  RemoteImages
//
//  Created by Yassin El Mouden on 05/02/13.
//  Copyright (c) 2013 Yassin El Mouden. All rights reserved.
//

#import "RemoteCacheManager.h"

@implementation RemoteCacheManager

+(RemoteCacheManager *)sharedInstance
{
    static dispatch_once_t onceToken = 0;
    static RemoteCacheManager * manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

-(void)saveImage:(UIImage *)img withName:(NSString *)fileName
{
    //récupération de répertoire de l'application
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //création du chemin du fichier
    NSString *pngFilePath =[documentsPath stringByAppendingPathComponent:fileName];
    NSLog(@"enregistrement %@",pngFilePath);
	NSData * dataImage = [NSData dataWithData:UIImagePNGRepresentation(img)];
    //enregistrement de l'image
	BOOL sucess = [dataImage writeToFile:pngFilePath atomically:YES];
    NSLog(@"success %d",sucess);
}

-(BOOL)doesExist:(NSString *)fileName
{
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* file = [documentsPath stringByAppendingPathComponent:fileName];
    return [[NSFileManager defaultManager] fileExistsAtPath:file];
}

-(UIImage *)getImageFromCache:(NSString *)fileName
{
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* file = [documentsPath stringByAppendingPathComponent:fileName];
    UIImage * image = [UIImage imageWithContentsOfFile:file];
    NSLog(@"file %@ %@",file,image);
    return image;
}

@end
