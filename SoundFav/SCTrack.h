//
//  SCTrack.h
//  SoundFav
//
//  Created by Benjamin Kodres-O'Brien on 12/29/14.
//  Copyright (c) 2014 Benjamin Kodres-O'Brien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SCTrack : NSObject

@property AVPlayer *audioPlayer;
@property AVPlayerItem *playerItem;
@property NSUInteger duration;   // in milliseconds

@property BOOL isPlaying;

@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *streamUrl;
@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, strong) NSURL *largeImageUrl;
@property NSInteger trackID;

- (id)initWithTitle:(NSString *)title andArtist:(NSString *)artist andUrl:(NSURL *)url andImage:(NSURL *)image;

- (void)play;
- (void)pause;


@end
