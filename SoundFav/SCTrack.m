//
//  SCTrack.m
//  SoundFav
//
//  Created by Benjamin Kodres-O'Brien on 12/29/14.
//  Copyright (c) 2014 Benjamin Kodres-O'Brien. All rights reserved.
//

#import "SCTrack.h"

#define CLIENT_ID "36e9edc50bb49091f65b65c30dfd6e4e"


@implementation SCTrack


- (id)initWithTitle:(NSString *)title andArtist:(NSString *)artist andUrl:(NSURL *)streamUrl andImage:(NSURL *)image
{
    self = [super init];
    
    if (self) {
        self.title = title;
        self.artist = artist;
        self.streamUrl = streamUrl;
        self.imageUrl = image;
        NSString *largeImageString = [[image absoluteString]
                                      stringByReplacingOccurrencesOfString:@"large" withString:@"t500x500"];
        if (largeImageString && largeImageString.length > 0)
        {
            self.largeImageUrl = [[NSURL alloc] initWithString:largeImageString];
        }
        else
        {
            self.largeImageUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"blank" ofType:@"png"]];
        }
    }
    return self;
}


- (void)play
{
    [self.audioPlayer play];
    self.isPlaying = YES;
}
- (void)pause
{
    [self.audioPlayer pause];
    self.isPlaying = NO;
}


@end
