//
//  MasterViewController.h
//  MyWebService
//
//  Created by Alexis RENART on 07/05/2014.
//  Copyright (c) 2014 Alexis RENART. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "CountryPicker.h"

@interface MasterViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate> {
    NSMutableArray *arrayUsername;
    NSMutableArray *arrayFirstname;
    NSMutableArray *arrayLastname;
    NSMutableArray *arrayImageURL;
    NSMutableArray *arrayCountry;
    NSMutableArray *arrayEmail;
    NSMutableArray *arrayBirthday;
    NSMutableArray *arrayAdress1;
    NSMutableArray *arrayAdress2;
    NSMutableArray *arrayZipcode;
    NSMutableArray *arrayCity;
    NSMutableArray *arrayLastConnect;
    
    NSMutableArray *arrayImageURLBig;
    NSMutableArray *searchResultsImageURLBig;
    
    NSMutableArray *searchResults;
    NSMutableArray *searchResultsUsername;
    NSMutableArray *searchResultsFirstname;
    NSMutableArray *searchResultsLastname;
    NSMutableArray *searchResultsImageURL;
    NSMutableArray *searchResultsCountry;
    NSMutableArray *searchResultsEmail;
    NSMutableArray *searchResultsBirthday;
    NSMutableArray *searchResultsAdress1;
    NSMutableArray *searchResultsAdress2;
    NSMutableArray *searchResultsZipcode;
    NSMutableArray *searchResultsCity;
    NSMutableArray *searchResultsLastConnect;
        
    CountryPicker *countrypicker;
    
    UIRefreshControl *refreshControl;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControlOutlet;

//@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSDictionary *usersList;

@property (strong, nonatomic) NSString *sortBy;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBarOutlet;

- (IBAction)refreshBtnItem:(id)sender;

- (IBAction)searchBtnItem:(id)sender;

- (IBAction)sortSgmntCtrlValueChanged:(UISegmentedControl *)sender;

@property (strong, nonatomic) DetailViewController *detailViewController;



@end
