//
//  PlayerViewController.m
//  SoundFav
//
//  Created by Benjamin Kodres-O'Brien on 12/30/14.
//  Copyright (c) 2014 Benjamin Kodres-O'Brien. All rights reserved.
//

#import "PlayerViewController.h"
#import "TrackListViewController.h"

#define CLIENT_ID "36e9edc50bb49091f65b65c30dfd6e4e"


@interface PlayerViewController ()

@end

@implementation PlayerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.artistLabel.adjustsFontSizeToFitWidth = YES;
    
    NSData *data = [NSData dataWithContentsOfURL:self.playlist.currentTrack.largeImageUrl];
    UIImage *img = [[UIImage alloc] initWithData:data];
    self.albumArt.image = img;
    
    self.titleLabel.text = self.playlist.currentTrack.title;
    self.artistLabel.text = self.playlist.currentTrack.artist;
    
    [self.albumArt setContentMode:UIViewContentModeScaleAspectFit];
    [self.playButton setUserInteractionEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - MUSIC CONTROL BUTTON EVENTS

- (IBAction)playButtonClicked:(UIButton *)sender
{
    if (self.playlist.currentTrack.isPlaying)
    {
        [self.playlist.currentTrack pause];
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"play" ofType:@"png"]];
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:data];
        [self.playButton setImage:image forState:UIControlStateNormal];
    }
    else
    {
        [self.playlist.currentTrack play];
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"pause" ofType:@"png"]];
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:data];
        [self.playButton setImage:image forState:UIControlStateNormal];
    }
}
- (IBAction)rewindClicked:(UIButton *)sender
{
    NSUInteger currentIndex = [self.playlist.songs indexOfObject:self.playlist.currentTrack];
    
    if (currentIndex - 1.0 >= 0.0)
    {
        [self.playlist resetCurrentSong];
        
        //update current track
        SCTrack *newTrack = [self.playlist.songs objectAtIndex:currentIndex - 1];
        self.playlist.currentTrack = newTrack;
        
        //get stream and create audioplayer with stream
        NSLog(@"Stream URL: %@", [self.playlist.currentTrack.streamUrl absoluteString]);
        NSString *realURL = [self.playlist.currentTrack.streamUrl.absoluteString
                             stringByAppendingFormat:@".json?client_id=" CLIENT_ID];
        self.playlist.currentTrack.audioPlayer = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:realURL]];
        
        // reset the image
        NSData *data = [NSData dataWithContentsOfURL:self.playlist.currentTrack.largeImageUrl];
        UIImage *img = [[UIImage alloc] initWithData:data];
        self.albumArt.image = img;
        
        [self viewDidLoad];
        [self.playlist.currentTrack play];
    }
}

- (IBAction)fastforwardClicked:(UIButton *)sender
{
    NSUInteger currentIndex = [self.playlist.songs indexOfObject:self.playlist.currentTrack];
    
    if (currentIndex + 1 < [self.playlist.songs count])
    {
        [self.playlist resetCurrentSong];
        
        //update current track
        SCTrack *newTrack = [self.playlist.songs objectAtIndex:currentIndex + 1];
        self.playlist.currentTrack = newTrack;
        
        //get stream and create audioplayer with stream
        NSLog(@"Stream URL: %@", [self.playlist.currentTrack.streamUrl absoluteString]);
        NSString *realURL = [self.playlist.currentTrack.streamUrl.absoluteString
                             stringByAppendingFormat:@".json?client_id=" CLIENT_ID];
        self.playlist.currentTrack.audioPlayer = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:realURL]];
        
        // reset the image
        NSData *data = [NSData dataWithContentsOfURL:self.playlist.currentTrack.largeImageUrl];
        UIImage *img = [[UIImage alloc] initWithData:data];
        self.albumArt.image = img;
        
        [self viewDidLoad];
        [self.playlist.currentTrack play];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
