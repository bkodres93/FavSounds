//
//  SCTrack.m
//  SoundFav
//
//  Created by Benjamin Kodres-O'Brien on 12/29/14.
//  Copyright (c) 2014 Benjamin Kodres-O'Brien. All rights reserved.
//

#import "SCTrack.h"

@implementation SCTrack


- (id)initWithTitle:(NSString *)title andArtist:(NSString *)artist andUrl:(NSURL *)streamUrl andImage:(NSURL *)image
{
    self = [super init];
    
    if (self) {
        self.title = title;
        self.artist = artist;
        self.streamUrl = streamUrl;
        self.imageUrl = image;
    }
    return self;
}


@end
