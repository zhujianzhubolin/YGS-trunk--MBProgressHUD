//
//  WebImage.m
//  CantonTower
//
//  Created by dlrc on 14/11/13.
//  Copyright (c) 2013年 dlrc. All rights reserved.
//

#import "WebImage.h"

@implementation WebImage

@synthesize url,Has_netvideo,video_url;

-(id) initWithURL:(NSString*) url_ withvideoTag:(BOOL) HASNETVIDEO withvideoURL:(NSString*) VIDEOURL
{
    self =[self init];
    if (self!=nil) {
        
        url = url_;
        Has_netvideo = HASNETVIDEO;
        if (VIDEOURL!=NULL) {
            video_url = VIDEOURL;
        }
        
        
    }
    
    
    return self;


}

@end
