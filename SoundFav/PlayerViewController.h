//
//  PlayerViewController.h
//  SoundFav
//
//  Created by Benjamin Kodres-O'Brien on 12/30/14.
//  Copyright (c) 2014 Benjamin Kodres-O'Brien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCTrack.h"

@interface PlayerViewController : UIViewController

@property (nonatomic, strong) SCTrack *currentTrack;

@end
