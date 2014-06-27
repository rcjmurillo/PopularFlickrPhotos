//
//  ObjCRecentPhotosTableViewController.m
//  PopularFlickrPhotos
//
//  Created by Ricardo Murillo on 6/26/14.
//  Copyright (c) 2014 Ricardo Murillo. All rights reserved.
//

#import "FlickrFetcher/FlickrFetcher.h"
#import "ObjCRecentPhotosTableViewController.h"
#import "PopularFlickrPhotos-Swift.h"

@interface ObjCRecentPhotosTableViewController ()
@property (strong, nonatomic) NSArray *recentPhotos;
@end

@implementation ObjCRecentPhotosTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

# pragma mark - Accessors

- (NSArray *)recentPhotos
{
    if (!_recentPhotos) {
        _recentPhotos = [[NSUserDefaults standardUserDefaults] arrayForKey:@"Recent Photos"];
    }
    return _recentPhotos;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.recentPhotos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Recent Photo Cell" forIndexPath:indexPath];
    
    NSDictionary *photo = self.recentPhotos[indexPath.row];
    
    cell.textLabel.text = photo[FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = photo[FLICKR_PHOTO_DESCRIPTION];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if ([segue.identifier isEqualToString:@"Display Recent Photo"]) {
            if ([segue.destinationViewController isKindOfClass:[PhotoViewController class]]) {
                PhotoViewController *photoViewController = segue.destinationViewController;
                NSDictionary *photo = self.recentPhotos[indexPath.row];
                photoViewController.photoURL = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
                photoViewController.photoTitle = photo[FLICKR_PHOTO_TITLE];
            }
        }
    }
}

@end
