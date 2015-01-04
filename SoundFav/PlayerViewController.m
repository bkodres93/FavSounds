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

@property id timeObserver;

@end

@implementation PlayerViewController

- (void)viewDidDisappear:(BOOL)animated
{
    [self.playlist.currentTrack.audioPlayer removeTimeObserver:self.timeObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // the album art
    NSData *data = [NSData dataWithContentsOfURL:self.playlist.currentTrack.largeImageUrl];
    UIImage *img = [[UIImage alloc] initWithData:data];
    self.albumArt.image = img;
    // make the album art fit
    [self.albumArt setContentMode:UIViewContentModeScaleAspectFit];
    
    // the shadow behind the album art
    self.albumArt.layer.shadowColor = [UIColor grayColor].CGColor;
    self.albumArt.layer.shadowOffset = CGSizeMake(3, 3);
    self.albumArt.layer.shadowOpacity = 1;
    self.albumArt.layer.shadowRadius = 1.0;
    self.albumArt.clipsToBounds = NO;
    
    
    // The labels for artist and title
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.artistLabel.adjustsFontSizeToFitWidth = YES;
    
    self.titleLabel.text = self.playlist.currentTrack.title;
    self.artistLabel.text = self.playlist.currentTrack.artist;

    // slider setup
    self.currentTimeSlider.maximumValue = self.playlist.currentTrack.duration;
    self.currentTimeSlider.minimumValue = 0.0;
    if (self.playlist.currentTrack.audioPlayer)
    {
        CMTime time = self.playlist.currentTrack.audioPlayer.currentTime;
        self.currentTimeSlider.value = time.value / time.timescale * 1000;
        
        // Set the seconds
        NSUInteger currentSeconds = time.value / time.timescale;
        NSUInteger currentMinutes = currentSeconds / 60;
        NSUInteger currentExtraSeconds = currentSeconds % 60;
        NSString *currentString = [NSString stringWithFormat:@"%lu:", (unsigned long)currentMinutes];
        if (currentExtraSeconds < 10)
        {
            currentString = [currentString stringByAppendingString:[NSString stringWithFormat:@"0%lu", (unsigned long)currentExtraSeconds]];
        }
        else
        {
            currentString = [currentString stringByAppendingString:[NSString stringWithFormat:@"%lu", currentExtraSeconds]];
        }
        self.currentTimeLabel.text = currentString;
        
        // now to calculate total number
        NSUInteger totalSeconds = self.playlist.currentTrack.duration / 1000;
        NSUInteger totalMinutes = totalSeconds / 60;
        NSUInteger totalExtraSeconds = totalSeconds % 60;
        NSString *totalString = [NSString stringWithFormat:@"%lu:", (unsigned long)totalMinutes];
        if (totalExtraSeconds < 10)
        {
            totalString = [totalString stringByAppendingString:[NSString stringWithFormat:@"0%lu", totalExtraSeconds]];
        }
        else
        {
            totalString = [totalString stringByAppendingString:[NSString stringWithFormat:@"%lu", totalExtraSeconds]];
        }
        self.totalTimeLabel.text = totalString;
        
    }
    
    // complicated observer stuff, must create a weak reference to self to avoid retain cycle
    CMTime interval = CMTimeMakeWithSeconds(1.0, NSEC_PER_SEC); // 1 second
    __unsafe_unretained typeof(self) weakSelf = self;
    self.timeObserver = [self.playlist.currentTrack.audioPlayer addPeriodicTimeObserverForInterval:interval
                                                    queue:NULL usingBlock:^(CMTime time) {
                                                        
                                                        // update slider value here...
                                                        [weakSelf.currentTimeSlider setValue:time.value / time.timescale * 1000];
                                                        
                                                        // here is where updating the timer label will happen
                                                        
                                                        // Set the seconds
                                                        NSUInteger currentSeconds = time.value / time.timescale;
                                                        NSUInteger currentMinutes = currentSeconds / 60;
                                                        NSUInteger currentExtraSeconds = currentSeconds % 60;
                                                        NSString *currentString = [NSString stringWithFormat:@"%lu:", (unsigned long)currentMinutes];
                                                        if (currentExtraSeconds < 10)
                                                        {
                                                            currentString = [currentString stringByAppendingString:[NSString stringWithFormat:@"0%lu", (unsigned long)currentExtraSeconds]];
                                                        }
                                                        else
                                                        {
                                                            currentString = [currentString stringByAppendingString:[NSString stringWithFormat:@"%lu", currentExtraSeconds]];
                                                        }
                                                        weakSelf.currentTimeLabel.text = currentString;
                                                        
                                                    }];
    
    //Take care of the play button appearance
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"pause" ofType:@"png"]];
    data = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *image = [[UIImage alloc] initWithData:data];
    [self.playButton setImage:image forState:UIControlStateNormal];
    if (!self.playlist.currentTrack.isPlaying)
    {
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"play" ofType:@"png"]];
        data = [[NSData alloc] initWithContentsOfURL:url];
        image = [[UIImage alloc] initWithData:data];
        [self.playButton setImage:image forState:UIControlStateNormal];
    }
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
    
    // if we can actually change the song
    if (currentIndex - 1.0 >= 0.0)
    {
        [self.playlist resetCurrentSong];
        [self.playlist.currentTrack.audioPlayer removeTimeObserver:self.timeObserver];
        
        //update current track
        SCTrack *newTrack = [self.playlist.songs objectAtIndex:currentIndex - 1];
        self.playlist.currentTrack = newTrack;
        
        //get stream and create audioplayer with stream
        NSLog(@"Stream URL: %@", [self.playlist.currentTrack.streamUrl absoluteString]);
        if ([self.playlist.currentTrack.streamUrl absoluteString])
        {
            NSString *realURLString = [self.playlist.currentTrack.streamUrl.absoluteString
                                       stringByAppendingFormat:@".json?client_id=" CLIENT_ID];
            NSURL *realUrl = [[NSURL alloc] initWithString:realURLString];
            AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:realUrl];
            self.playlist.currentTrack.playerItem = playerItem;
            self.playlist.currentTrack.audioPlayer = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid stream url"
                                                            message:@"It appears the soundcloud stream url is invalid."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        // reset the image
        NSData *data = [NSData dataWithContentsOfURL:self.playlist.currentTrack.largeImageUrl];
        UIImage *img = [[UIImage alloc] initWithData:data];
        self.albumArt.image = img;
        
        //[self.currentTimeSlider setValue:0.0 animated:NO];
        [self.playlist.currentTrack play];
        self.playlist.currentTrack.isPlaying = YES;
        [self viewDidLoad];
    }
}

- (IBAction)fastforwardClicked:(UIButton *)sender
{
    NSUInteger currentIndex = [self.playlist.songs indexOfObject:self.playlist.currentTrack];
    
    if (currentIndex + 1 < [self.playlist.songs count])
    {
        [self.playlist resetCurrentSong];
        [self.playlist.currentTrack.audioPlayer removeTimeObserver:self.timeObserver];
        
        //update current track
        SCTrack *newTrack = [self.playlist.songs objectAtIndex:currentIndex + 1];
        self.playlist.currentTrack = newTrack;
        
        //get stream and create audioplayer with stream
        NSLog(@"Stream URL: %@", [self.playlist.currentTrack.streamUrl absoluteString]);
        if ([self.playlist.currentTrack.streamUrl absoluteString])
        {
            NSString *realURLString = [self.playlist.currentTrack.streamUrl.absoluteString
                                   stringByAppendingFormat:@".json?client_id=" CLIENT_ID];
            NSURL *realUrl = [[NSURL alloc] initWithString:realURLString];
            AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:realUrl];
            self.playlist.currentTrack.playerItem = playerItem;
            self.playlist.currentTrack.audioPlayer = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid stream url"
                                                            message:@"It appears the soundcloud stream url is invalid."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        // reset the image
        NSData *data = [NSData dataWithContentsOfURL:self.playlist.currentTrack.largeImageUrl];
        UIImage *img = [[UIImage alloc] initWithData:data];
        self.albumArt.image = img;
        
        //[self.currentTimeSlider setValue:0.0 animated:NO];
        [self.playlist.currentTrack play];
        self.playlist.currentTrack.isPlaying = YES;
        [self viewDidLoad];
        
    }
}

- (IBAction)seekToTime:(UISlider *)sender
{
    CMTime time = CMTimeMake(sender.value / 1000, 1);
    [self.playlist.currentTrack.audioPlayer pause];
    [self.playlist.currentTrack.audioPlayer seekToTime:time];
    [self.playlist.currentTrack.audioPlayer play];
    
    // re-add the time observer
    CMTime interval = CMTimeMakeWithSeconds(1.0, NSEC_PER_SEC); // 1 second
    __unsafe_unretained typeof(self) weakSelf = self;
    self.timeObserver = [self.playlist.currentTrack.audioPlayer addPeriodicTimeObserverForInterval:interval
                                                    queue:NULL usingBlock:^(CMTime time) {
                                                        
                                                        // update slider value here...
                                                        [weakSelf.currentTimeSlider setValue:time.value / time.timescale * 1000];
                                                        
                                                        // here is where updating the timer label will happen
                                                        
                                                        // Set the seconds
                                                        NSUInteger currentSeconds = time.value / time.timescale;
                                                        NSUInteger currentMinutes = currentSeconds / 60;
                                                        NSUInteger currentExtraSeconds = currentSeconds % 60;
                                                        NSString *currentString = [NSString stringWithFormat:@"%lu:", (unsigned long)currentMinutes];
                                                        if (currentExtraSeconds < 10)
                                                        {
                                                            currentString = [currentString stringByAppendingString:[NSString stringWithFormat:@"0%lu", (unsigned long)currentExtraSeconds]];
                                                        }
                                                        else
                                                        {
                                                            currentString = [currentString stringByAppendingString:[NSString stringWithFormat:@"%lu", currentExtraSeconds]];
                                                        }
                                                        weakSelf.currentTimeLabel.text = currentString;
                                                        
                                                    }];
}
- (IBAction)sliderTouchDown:(UISlider *)sender
{
    [self.playlist.currentTrack.audioPlayer pause];
    [self.playlist.currentTrack.audioPlayer removeTimeObserver:self.timeObserver];
}

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    CMTime time = CMTimeMake(sender.value / 1000, 1);
    [self.playlist.currentTrack.audioPlayer seekToTime:time];

    // update slider value here...
    [sender setValue:time.value / time.timescale * 1000];
    
    // here is where updating the timer label will happen
    
    // Set the seconds
    NSUInteger currentSeconds = time.value / time.timescale;
    NSUInteger currentMinutes = currentSeconds / 60;
    NSUInteger currentExtraSeconds = currentSeconds % 60;
    NSString *currentString = [NSString stringWithFormat:@"%lu:", (unsigned long)currentMinutes];
    if (currentExtraSeconds < 10)
    {
        currentString = [currentString stringByAppendingString:[NSString stringWithFormat:@"0%lu", (unsigned long)currentExtraSeconds]];
    }
    else
    {
        currentString = [currentString stringByAppendingString:[NSString stringWithFormat:@"%lu", currentExtraSeconds]];
    }
    self.currentTimeLabel.text = currentString;
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
