//
//  SCTrack.h
//  SoundFav
//
//  Created by Benjamin Kodres-O'Brien on 12/29/14.
//  Copyright (c) 2014 Benjamin Kodres-O'Brien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCTrack : NSObject

@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *streamUrl;
@property (nonatomic, strong) NSURL *imageUrl;
@property NSInteger trackID;

- (id)initWithTitle:(NSString *)title andArtist:(NSString *)artist andUrl:(NSURL *)url andImage:(NSURL *)image;

@end
