//
//  RemoteImageDownloader.m
//  RemoteImages
//
//  Created by Vincent GUINIER on 01/02/13.
//  Copyright (c) 2013 Yassin El Mouden. All rights reserved.
//

#import "RemoteImageDownloader.h"

@implementation RemoteImageDownloader
@synthesize url = _url;
@synthesize rl = _rl;
@synthesize data = _data;
@synthesize port = _port;
@synthesize saveImage = _saveImage;
@synthesize imageConnection = _imageConnection;
@synthesize telechargementEchec = _telechargementEchec;
@synthesize telechargementReussi = _telechargementReussi;

-(id)initRemoteImageDownloader:(NSString *)url succes:(TelechargementImageReussi)sucessTelechargement echec:(TelechargementImageEchec)echecTelechargement save:(SaveInCache)saveImage
{
    if(self = [super init])
    {
        self.telechargementReussi = sucessTelechargement;
        self.telechargementEchec = echecTelechargement;
        self.saveImage = saveImage;
        self.url = url;
    }
    return self;
}

-(void)main
{
    @autoreleasepool {
        // si l'opération est annulée, on break
        if(self.isCancelled)
        {
            return;
        }
        if(!self.isCancelled)
        {
            //on crée notre nsurlconnection pour le download de l'image
            NSURL * urlImage =  [[NSURL alloc] initWithString:_url];
            NSURLRequest * request = [[NSURLRequest alloc] initWithURL:urlImage];
            NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            self.imageConnection = connection;
            
            
            //run loop afin que les méthodes du delegate soient appelées
            NSPort* port = [NSPort port];
            NSRunLoop* rl = [NSRunLoop currentRunLoop]; 
            [rl addPort:port forMode:NSDefaultRunLoopMode];
            [connection scheduleInRunLoop:rl forMode:NSDefaultRunLoopMode];
            self.rl = rl;
            self.port = port;
            //si l'opération n'est pas annulée, on lance le téléchargement
            
            if(!self.isCancelled)
            {
                [connection start];
            }
            [rl run];
            
        }
        
       
    }
    
   
    
}

-(void)cancel
{
    [super cancel];
    //on cancel notre opération, si l'operation est annulée
    [_imageConnection cancel];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSMutableData * newData = [[NSMutableData alloc] init];
    self.data = newData;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [_rl removePort:_port forMode:NSDefaultRunLoopMode];
    CFRunLoopStop(CFRunLoopGetCurrent());
    
    self.imageConnection = nil;
    [self performSelectorOnMainThread:@selector(finishRemoteWithSuccess:) withObject:_data waitUntilDone:YES];
    self.data = nil;
    
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [_rl removePort:_port forMode:NSDefaultRunLoopMode];
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.data = nil;
    self.imageConnection = nil;
    
    [self performSelectorOnMainThread:@selector(finishRemoteWithFail) withObject:nil waitUntilDone:YES];
}



-(void)finishRemoteWithSuccess:(NSData *)data
{
    UIImage * img = [UIImage imageWithData:data];
    _saveImage(img,_url);
    _telechargementReussi(img,NO);
}

-(void)finishRemoteWithFail
{
    _telechargementEchec();
}



@end
