//
//  ViewController.h
//  SoundFav
//
//  Created by Benjamin Kodres-O'Brien on 12/29/14.
//  Copyright (c) 2014 Benjamin Kodres-O'Brien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCTrack.h"

@interface ViewController : UITableViewController <NSURLConnectionDelegate>

@property (nonatomic, strong) NSMutableArray *playlist;
@property NSMutableData *responseData;
@property (nonatomic, strong) SCTrack *currentTrack;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *loginButton;

@end

