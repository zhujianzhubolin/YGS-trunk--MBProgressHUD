//
//  WebImage.h
//  CantonTower
//
//  Created by dlrc on 14/11/13.
//  Copyright (c) 2013年 dlrc. All rights reserved.
//
//#ifndef _WebImage_H_
//#define _WebImage_H_
#import <Foundation/Foundation.h>

@interface WebImage : NSObject

@property (copy,nonatomic) NSString* url;
@property  BOOL Has_netvideo;
@property (copy,nonatomic) NSString * video_url;


-(id) initWithURL:(NSString*) url_ withvideoTag:(BOOL) HASNETVIDEO withvideoURL:(NSString*) VIDEOURL;

@end
//#endif
