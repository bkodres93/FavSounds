//
//  Playlist.h
//  SoundFav
//
//  Created by Benjamin Kodres-O'Brien on 12/31/14.
//  Copyright (c) 2014 Benjamin Kodres-O'Brien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCTrack.h"

@interface Playlist : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *songs;
@property (nonatomic, strong) SCTrack *currentTrack;

- (id)init;
- (void)resetCurrentSong;

@end
