//
//  Playlist.m
//  SoundFav
//
//  Created by Benjamin Kodres-O'Brien on 12/31/14.
//  Copyright (c) 2014 Benjamin Kodres-O'Brien. All rights reserved.
//

#import "Playlist.h"

@implementation Playlist

- (id)init
{
    self = [super init];
    if (self)
    {
        _songs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)resetCurrentSong
{
    if (self.currentTrack == nil)
    {
        return;
    }
    
    CMTime beginning = CMTimeMake(0, 1);
    [self.currentTrack pause];
    [self.currentTrack.audioPlayer seekToTime:beginning];
}

@end
