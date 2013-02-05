//
//  UIImageView+RemoteImage.m
//  RemoteImages
//
//  Created by Vincent GUINIER on 01/02/13.
//  Copyright (c) 2013 Yassin El Mouden. All rights reserved.
//

#import "UIImageView+RemoteImage.h"
#import <objc/runtime.h>
@implementation UIImageView (RemoteImage)
static char ASSOC_KEY;
-(void)setImageFromUrl:(NSString *)url placeholderImage:(UIImage *)image withIndicator:(BOOL)hasIndicator doesCacheImage:(BOOL)cache
{
    //on affecte l'image placehoelder
    self.image = image;
    
    //on teste si l'on doit ajouter un indicator
    UIActivityIndicatorView * ind = (UIActivityIndicatorView *)[self viewWithTag:999];
    if(hasIndicator)
    {
        //si aucun indicateur, on en ajoute un
        if(!ind)
        {
            UIActivityIndicatorView * indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            //on ajoute l'indicateur au centre de l'imageview
            indicator.frame = CGRectMake((self.frame.size.width - 25) /2 , (self.frame.size.width - 25) /2, 25, 25);
            [self addSubview:indicator];
            [indicator startAnimating];
            indicator.tag = 999;
        }else {
            //on lance l'animation
            [ind startAnimating];
        }
        
    }
    //si une opération a été associée à notre instance, on la cancel
    RemoteImageDownloader * previousRemote = (RemoteImageDownloader *)objc_getAssociatedObject(self, &ASSOC_KEY);
    if(previousRemote)
    {
        [previousRemote cancel];
    }
    
    //éviter une cycle retain
    __unsafe_unretained UIImageView * remote = self;
    //on crée notre opération
     RemoteImageDownloader * dowloader = [[RemoteImageManager sharedInstance] dowloadImageAtUrl:url downloadsucceeded:^(UIImage * img,BOOL fromCache) {
         //on supprime notre indicateur
         [((UIActivityIndicatorView *)[remote viewWithTag:999]) stopAnimating];
         [[remote viewWithTag:999] removeFromSuperview];
         remote.image = img;
         if(!fromCache)
         {
             //une animation pour l'ajout de l'image
             [UIView beginAnimations:nil context:NULL];
             [UIView setAnimationDuration: 1.0];
             [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:remote cache:NO];
             [UIView commitAnimations];

         }
         //on réduit le compteur de référence
        objc_setAssociatedObject(remote,&ASSOC_KEY,nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } dowloadFailed:^{
        
    } doesCacheImage:NO];
    //on associe à notre instance une opération
    objc_setAssociatedObject(self,&ASSOC_KEY,dowloader,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    

}




@end
