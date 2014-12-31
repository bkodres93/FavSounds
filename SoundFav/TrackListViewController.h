//
//  TrackListViewController.h
//  SoundFav
//
//  Created by Benjamin Kodres-O'Brien on 12/29/14.
//  Copyright (c) 2014 Benjamin Kodres-O'Brien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCTrack.h"
#import "Playlist.h"

@interface ViewController : UITableViewController <NSURLConnectionDelegate>

@property (nonatomic, strong) Playlist *playlist;
@property NSMutableData *responseData;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *jamOutButtom;

@end

