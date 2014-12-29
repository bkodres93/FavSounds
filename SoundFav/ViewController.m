//
//  ViewController.m
//  SoundFav
//
//  Created by Benjamin Kodres-O'Brien on 12/29/14.
//  Copyright (c) 2014 Benjamin Kodres-O'Brien. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playlist = [[NSMutableArray alloc] init];
    
    [self loadInitialData];
}

- (void)loadInitialData
{
    // Create the request.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.soundcloud.com/users/58871449/favorites.json?client_id=36e9edc50bb49091f65b65c30dfd6e4e"]];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
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
    return [self.playlist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return a cell to be used for the row at the given index
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SongCell" forIndexPath:indexPath];
    
    
    return cell;
}


#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [self.responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %lu bytes of data",self.responseData.length);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData
                                                        options:NSJSONReadingMutableLeaves
                                                          error:&myError];
    
    // show all values
    for(id key in res) {
        NSString *keyAsString = (NSString *)key;
        NSLog(@"LARGE key: %@", keyAsString);
        
        NSString *title = [key valueForKey:@"title"];
        NSString *artist = [[key valueForKey:@"user"] valueForKey:@"username"];
        NSString *streamString = [key valueForKey:@"stream_url"];
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
        /*
        for(id key2 in key)
        {
            id value = [key objectForKey:key2];
        
            NSString *keyAsString2 = (NSString *)key2;
            NSString *valueAsString = (NSString *)value;
        
            NSLog(@"key: %@", keyAsString2);
            NSLog(@"value: %@", valueAsString);
        }
         */

        
    }
    
    // extract specific value...
    /*
    NSArray *results = [res objectForKey:@"results"];
    
    for (NSDictionary *result in results) {
        NSString *icon = [result objectForKey:@"icon"];
        NSLog(@"icon: %@", icon);
    }*/
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"Error");
}

@end
