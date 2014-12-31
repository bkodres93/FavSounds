//
//  ViewController.m
//  SoundFav
//
//  Created by Benjamin Kodres-O'Brien on 12/29/14.
//  Copyright (c) 2014 Benjamin Kodres-O'Brien. All rights reserved.
//

#import "TrackListViewController.h"
#import "SongTableViewCell.h"
#import "PlayerViewController.h"
#import "SCUI.h"

#define CLIENT_ID "36e9edc50bb49091f65b65c30dfd6e4e"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playlist = [[Playlist alloc] init];
    [self.jamOutButtom setHidden:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableViewController methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.playlist.songs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return a cell to be used for the row at the given index
    SongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SongCell" forIndexPath:indexPath];
    cell.titleLabel.adjustsFontSizeToFitWidth = YES;
    cell.artistLabel.adjustsFontSizeToFitWidth = YES;
    
    cell.artistLabel.text = [[self.playlist.songs objectAtIndex:indexPath.row] artist];
    cell.titleLabel.text = [[self.playlist.songs objectAtIndex:indexPath.row] title];
    
    NSURL *imageUrl = [[self.playlist.songs objectAtIndex:indexPath.row] imageUrl];
    if (imageUrl)
    {
        NSData *data = [NSData dataWithContentsOfURL:imageUrl];
        UIImage *img = [[UIImage alloc] initWithData:data];
        cell.albumArt.image = img;
    }
    else
    {
        imageUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"blank" ofType:@"png"]];
        NSData *data = [NSData dataWithContentsOfURL:imageUrl];
        UIImage *img = [[UIImage alloc] initWithData:data];
        cell.albumArt.image = img;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Called whenever the user clicks on a table cell
    SCTrack *selectedSong = [self.playlist.songs objectAtIndex:indexPath.row];
    
    if (self.playlist.currentTrack == nil)
    {
        self.playlist.currentTrack = selectedSong;
    }
    
    if (selectedSong != self.playlist.currentTrack)
    {
        [self.playlist resetCurrentSong];
        self.playlist.currentTrack = selectedSong;
    }
    
    NSLog(@"Stream URL: %@", [self.playlist.currentTrack.streamUrl absoluteString]);
    NSString *realURL = [self.playlist.currentTrack.streamUrl.absoluteString
                         stringByAppendingFormat:@".json?client_id=" CLIENT_ID];
    self.playlist.currentTrack.audioPlayer = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:realURL]];
    [self.playlist.currentTrack.audioPlayer play];
    [self performSegueWithIdentifier:@"Now Playing" sender:[tableView dequeueReusableCellWithIdentifier:@"SongCell" forIndexPath:indexPath]];
}


#pragma mark track things

- (void)trackDidFinish:(NSNotification *)notification
{
    // do somethign when track finishes
    NSUInteger currentIndex = [self.playlist.songs indexOfObject:self.playlist.currentTrack];
    
    if (currentIndex + 1 < [self.playlist.songs count])
    {
        [self.playlist resetCurrentSong];
        
        SCTrack *newSong = [self.playlist.songs objectAtIndex:currentIndex + 1];
        self.playlist.currentTrack = newSong;
        [self.playlist.currentTrack play];
    }
}


- (IBAction)login:(id)sender
{
    SCLoginViewControllerCompletionHandler handler = ^(NSError *error) {
        if (SC_CANCELED(error)) {
            NSLog(@"Canceled!");
        } else if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
        // RELOAD EVERTHING
        else
        {
            NSLog(@"Done!");
            SCAccount *account = [SCSoundCloud account];
            if (account == nil) {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Not Logged In"
                                      message:@"You must login first"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            // register the handler
            SCRequestResponseHandler handler;
            handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
                self.playlist = [[Playlist alloc] init];
                NSError *jsonError = nil;
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                             options:NSJSONReadingMutableLeaves
                                                                               error:&jsonError];
                if (!jsonError) {
                    
                    // show all values
                    for(id key in jsonResponse) {
                        NSString *keyAsString = (NSString *)key;
                        
                        if ([keyAsString isKindOfClass:[NSString class]] && [keyAsString isEqualToString:@"errors"])
                        {
                            return;
                        }
                        
                        NSString *title = [key valueForKey:@"title"];
                        NSString *artist = [[key valueForKey:@"user"] valueForKey:@"username"];
                        NSString *streamString = [key valueForKey:@"stream_url"];
                        [streamString stringByAppendingString:@"?client_id=" CLIENT_ID];
                        NSString *imageString = [key valueForKey:@"artwork_url"];
                        
                        NSURL *streamUrl = nil;
                        if (streamString != nil)
                        {
                            streamUrl = [[NSURL alloc] initWithString:streamString];
                        }
                        NSURL *imageUrl = nil;
                        if (imageString != nil && ![imageString isKindOfClass:[NSNull class]])
                        {
                            imageUrl = [[NSURL alloc] initWithString:imageString];
                        }
                        
                        SCTrack *track = [[SCTrack alloc] initWithTitle:title
                                                              andArtist:artist
                                                                 andUrl:streamUrl
                                                               andImage:imageUrl];
                        
                        [self.playlist.songs addObject:track];
                    }
                    
                    [self.tableView reloadData];
                }
            };
            
            // perform the request
            NSString *resourceURL = @"https://api.soundcloud.com/me/favorites.json?client_id=" CLIENT_ID;
            [SCRequest performMethod:SCRequestMethodGET
                          onResource:[NSURL URLWithString:resourceURL]
                     usingParameters:nil
                         withAccount:account
              sendingProgressHandler:nil
                     responseHandler:handler];
        }

    };
    
    [SCSoundCloud requestAccessWithPreparedAuthorizationURLHandler:^(NSURL *preparedURL) {
        SCLoginViewController *loginViewController;
        
        loginViewController = [SCLoginViewController
                               loginViewControllerWithPreparedURL:preparedURL
                               completionHandler:handler];
        [self presentViewController:loginViewController animated:YES completion:NULL];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (self.playlist.currentTrack)
    {
        //Called whenever the view is about to segue to another view
        PlayerViewController *controller = (PlayerViewController *)[[segue destinationViewController] visibleViewController];
        controller.playlist = self.playlist;
        [self.jamOutButtom setHidden:NO];
    }
    else
    {
        return;
    }
}

@end
