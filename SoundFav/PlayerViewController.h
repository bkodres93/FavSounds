//
//  PlayerViewController.h
//  SoundFav
//
//  Created by Benjamin Kodres-O'Brien on 12/30/14.
//  Copyright (c) 2014 Benjamin Kodres-O'Brien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCTrack.h"
#import "TrackListViewController.h"

@interface PlayerViewController : UIViewController

@property (nonatomic, strong) Playlist *playlist;
@property (strong, nonatomic) IBOutlet UIImageView *albumArt;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *artistLabel;
@property (strong, nonatomic) IBOutlet UISlider *currentTimeSlider;
@property (strong, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalTimeLabel;


@end
