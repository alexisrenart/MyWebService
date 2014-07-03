//
//  MasterViewController.m
//  MyWebService
//
//  Created by Alexis RENART on 07/05/2014.
//  Copyright (c) 2014 Alexis RENART. All rights reserved.
//

#import "MasterViewController.h"
#import "API.h"
#import "DetailViewController.h"
#import "SplitViewController.h"
#import "UIAlertView+error.h"


@interface MasterViewController ()

@end

@implementation MasterViewController

@synthesize usersList, searchBarOutlet, segmentControlOutlet, sortBy;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Display the refresh control (pull to refresh)
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl setBackgroundColor:[UIColor whiteColor]];
    [refreshControl setTintColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1]];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(allprofiles) forControlEvents:UIControlEventValueChanged];
    
    usersList = nil;
    sortBy = @"alphab";

    [self allprofiles];

}

- (void)viewDidAppear:(BOOL)animated {
    

}



-(void)dismissKeyboard {
    [searchBarOutlet resignFirstResponder];
}



-(void)allprofiles {
    
    // Desactivate the Segment Control
    segmentControlOutlet.enabled = NO;
    segmentControlOutlet.userInteractionEnabled = NO;

    // Build dictionary to send JSON request
    NSMutableDictionary* params2 =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"allprofiles", @"command",
                                   sortBy, @"sort",
                                    nil];
    
        //make the call to the web API
        [[API sharedInstance] commandWithParams:params2
                                   onCompletion:^(NSDictionary *json) {
    
                                       if ([json objectForKey:@"error"]==nil)  {
                                           
                                           // Save the result in usersList
                                           usersList = json;
                                           
                                           // Update the arrays
                                           [self updateArray];
                                           
                                           // Stop the Refresh Control
                                           [refreshControl endRefreshing];
                                           
                                           // Reload datas from tableview
                                           [self.tableView reloadData];
                                           
                                           //// Init View with current username cell selected
                                           int RowOfPathCurrentUsername = 0;
                                           
                                           
                                           if ([arrayUsername count] != 0) {
                                               for (int i=0;i<[arrayUsername count];i++) {
                                                   
                                                   if ([[arrayUsername objectAtIndex:i] isEqualToString:([[[API sharedInstance] user] objectForKey:@"username"])]) {
                                                       
                                                       RowOfPathCurrentUsername = i;
                                                       
                                                   }
                                               }
                                           
                                           
                                           
                                           NSIndexPath* selectedCellIndexPath= [NSIndexPath indexPathForRow:RowOfPathCurrentUsername inSection:0];
                                           [self tableView:self.tableView didSelectRowAtIndexPath:selectedCellIndexPath];
                                           [self.tableView selectRowAtIndexPath:selectedCellIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                                               
                                           } else {
                                               NSIndexPath* selectedCellIndexPath= [NSIndexPath indexPathForRow:0 inSection:0];
                                               [self tableView:self.tableView didSelectRowAtIndexPath:selectedCellIndexPath];
                                           }
                                           ////
                                           
                                           // Activate the Segment Control
                                           segmentControlOutlet.enabled = YES;
                                           segmentControlOutlet.userInteractionEnabled = YES;

    
                                       } else {
                                           
                                           // Activate the Segment Control
                                           segmentControlOutlet.enabled = YES;
                                           segmentControlOutlet.userInteractionEnabled = YES;

                                           // Stop the Refresh Control
                                           [refreshControl endRefreshing];
                                           
                                           // Error message
                                          [UIAlertView error:[json objectForKey:@"error"]];
                                       }
                                       
                                   }];
}

    
    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
#pragma mark - Void
-(void)updateArray {
    // Init arrays
    arrayUsername = [[NSMutableArray alloc] init];
    arrayFirstname = [[NSMutableArray alloc] init];
    arrayLastname = [[NSMutableArray alloc] init];
    arrayImageURL = [[NSMutableArray alloc] init];
    arrayCountry = [[NSMutableArray alloc] init];
    
    arrayEmail = [[NSMutableArray alloc] init];
    arrayBirthday = [[NSMutableArray alloc] init];
    arrayAdress1 = [[NSMutableArray alloc] init];
    arrayAdress2 = [[NSMutableArray alloc] init];
    arrayZipcode = [[NSMutableArray alloc] init];
    arrayCity = [[NSMutableArray alloc] init];
    
    arrayLastConnect = [[NSMutableArray alloc] init];
    
    arrayImageURLBig = [[NSMutableArray alloc] init];
    
    NSMutableArray *resultArray = [usersList objectForKey:@"result"];
    
    //////////////
    for (int i=0;i<[resultArray count];i++) {
        
        NSDictionary* resultDict = [resultArray objectAtIndex:i];
        
        NSMutableArray* itemUsername = [resultDict objectForKey:@"username"];
        NSMutableArray* itemFirstname = [resultDict objectForKey:@"firstname"];
        NSMutableArray* itemLastname = [resultDict objectForKey:@"lastname"];
        NSMutableArray* itemCountry = [resultDict objectForKey:@"country"];
        
        NSMutableArray* itemEmail = [resultDict objectForKey:@"email"];
        NSMutableArray* itemBirthday = [resultDict objectForKey:@"birthdate"];
        NSMutableArray* itemAdress1 = [resultDict objectForKey:@"adress1"];
        NSMutableArray* itemAdress2 = [resultDict objectForKey:@"adress2"];
        NSMutableArray* itemZipcode = [resultDict objectForKey:@"zipcode"];
        NSMutableArray* itemCity = [resultDict objectForKey:@"city"];
        NSMutableArray* itemLastConnect = [resultDict objectForKey:@"lastconnection"];
        
        [arrayUsername addObject:itemUsername];
        [arrayFirstname addObject:itemFirstname];
        [arrayLastname addObject:itemLastname];
        [arrayCountry addObject:itemCountry];
        
        [arrayEmail addObject:itemEmail];
        [arrayBirthday addObject:itemBirthday];
        [arrayAdress1 addObject:itemAdress1];
        [arrayAdress2 addObject:itemAdress2];
        [arrayZipcode addObject:itemZipcode];
        [arrayCity addObject:itemCity];
        [arrayLastConnect addObject:itemLastConnect];
      
        
        NSURL* imageURL = [[API sharedInstance] urlForImage:[NSNumber numberWithInt:0] :(NSString *)itemUsername :@"profil" isThumb:YES isProfil:YES];
        
        [arrayImageURL addObject:imageURL];
        
        NSURL* imageURLBig = [[API sharedInstance] urlForImage:[NSNumber numberWithInt:0] :(NSString *)itemUsername :@"profil" isThumb:NO isProfil:YES];
        
        [arrayImageURLBig addObject:imageURLBig];

        
    }
    
}







#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResultsUsername count];
        
    } else {
        
        return arrayUsername.count;
      
    }
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    // Display recipe in the table cell
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [searchResultsUsername objectAtIndex:indexPath.row];
        NSString *name = [NSString stringWithFormat:@"%@ %@", [searchResultsFirstname objectAtIndex:indexPath.row], [searchResultsLastname objectAtIndex:indexPath.row]];
        cell.detailTextLabel.text = name;

        
        cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[searchResultsImageURL objectAtIndex:indexPath.row]]];
        
        if (!(cell.imageView.image.CGImage)) {
            cell.imageView.image = [UIImage imageNamed:@"profil"];
        }


    } else {
        cell.textLabel.text = [arrayUsername objectAtIndex:indexPath.row];
        
        if ([sortBy isEqualToString:@"alphab"]) {
            NSString *name = [NSString stringWithFormat:@"%@ %@", [arrayFirstname objectAtIndex:indexPath.row], [arrayLastname objectAtIndex:indexPath.row]];
            cell.detailTextLabel.text = name;
            
        } else if ([sortBy isEqualToString:@"date"]||[sortBy isEqualToString:@"online"]) {
            //////  Calculate differences between 2 dates  ////////
            
            if (![[arrayLastConnect objectAtIndex:indexPath.row] isEqualToString:@"0000-00-00 00:00:00"]) {
                
                NSDateFormatter *dateFormatterSQL = [[NSDateFormatter alloc] init];
                dateFormatterSQL.dateFormat = @"yyyy-MM-dd' 'HH:mm:ss";
                [dateFormatterSQL setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
                
                NSDate *startDate = [dateFormatterSQL dateFromString:[arrayLastConnect objectAtIndex:indexPath.row]];
                
                NSDate *endDate = [NSDate date];
                
                NSCalendar *gregorian = [[NSCalendar alloc]
                                         
                                         initWithCalendarIdentifier:NSGregorianCalendar];
                
                
                
                NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ;
                
                
                
                NSDateComponents *components = [gregorian components:unitFlags
                                                
                                                            fromDate:startDate
                                                
                                                              toDate:endDate options:0];
                NSInteger years = [components year];
                NSInteger months = [components month];
                NSInteger days = [components day];
                NSInteger hours = [components hour];
                NSInteger minutes = [components minute];
                NSInteger seconds = [components second];
                
                if (years >0) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"Last connection : %ld Y %ld M", (long)years, (long)months];
                } else if (months > 0) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"Last connection : %ld M %ld d", (long)months, (long)days];
                } else if (days > 0) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"Last connection : %ld d %ld h", (long)days, (long)hours];
                } else if (hours > 0) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"Last connection : %ld h %ld min", (long)hours, (long)minutes];
                } else if (minutes > 0) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"Last connection : %ld min %ld s", (long)minutes, (long)seconds];
                } else {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"Last connection : %ld sec", (long)seconds];
                }
                
                
            } else {
                cell.detailTextLabel.text = @"Never connected";
            }
            
            //////////////////////////////////////////////////////
        }
        
        
        
        cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[arrayImageURL objectAtIndex:indexPath.row]]];
        
        if (!(cell.imageView.image.CGImage)) {
            cell.imageView.image = [UIImage imageNamed:@"profil"];
        }
        
    }
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    _detailViewController.adress1Outlet.textColor = [UIColor blackColor];
    _detailViewController.adress2Outlet.textColor = [UIColor blackColor];
    
    // Display recipe in the table cell
    if (self.searchDisplayController.active) {
        
        [self dismissKeyboard];
        
        indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        
        _detailViewController.usernameOutlet.text = [searchResultsUsername objectAtIndex:indexPath.row];
        _detailViewController.firstnameOutlet.text = [searchResultsFirstname objectAtIndex:indexPath.row];
        _detailViewController.lastnameOutlet.text = [searchResultsLastname objectAtIndex:indexPath.row];
        
        
        _detailViewController.emailOutlet.text = [searchResultsEmail objectAtIndex:indexPath.row];
        if ([[searchResultsBirthday objectAtIndex:indexPath.row] isEqualToString:@"0000-00-00"]) {
            _detailViewController.birthdateOutlet.text = @"";
        } else {
            // Convert date from SQL database
            NSString *dateStringSQL = [searchResultsBirthday objectAtIndex:indexPath.row];
            NSDateFormatter *dateFormatterSQL = [[NSDateFormatter alloc] init];
            dateFormatterSQL.dateFormat = @"yyyy-MM-dd";
            NSDate *date = [dateFormatterSQL dateFromString:dateStringSQL];
            
            NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"ddMMYYYY" options:0 locale:[NSLocale currentLocale]];
            NSDateFormatter *currentDateFormatter = [[NSDateFormatter alloc] init];
            [currentDateFormatter setDateFormat:formatString];
            currentDateFormatter.dateStyle = NSDateFormatterShortStyle;
            
            _detailViewController.birthdateOutlet.text = [currentDateFormatter stringFromDate:date];
        }
        
        _detailViewController.adress1Outlet.text = [searchResultsAdress1 objectAtIndex:indexPath.row];
        _detailViewController.adress2Outlet.text = [searchResultsAdress2 objectAtIndex:indexPath.row];
       
        if ([[searchResultsZipcode objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
            _detailViewController.zipcodeOutlet.text = @"";
        } else {
            _detailViewController.zipcodeOutlet.text = [searchResultsZipcode objectAtIndex:indexPath.row];
        }
        
        _detailViewController.cityOutlet.text = [searchResultsCity objectAtIndex:indexPath.row];
        
        
        if (![[searchResultsCountry objectAtIndex:indexPath.row] isEqualToString:@""]) {
            _detailViewController.imgcountryOutlet.image = [UIImage imageNamed:[searchResultsCountry objectAtIndex:indexPath.row]];
            
            countrypicker = [[CountryPicker alloc] init];
            [countrypicker setSelectedCountryCode:[searchResultsCountry objectAtIndex:indexPath.row]];
            
            _detailViewController.countryOutlet.text = countrypicker.selectedCountryName;
            
        } else {
            _detailViewController.imgcountryOutlet.image = [[UIImage alloc] init];
            _detailViewController.countryOutlet.text = @"";
        }
        
        _detailViewController.title = [[NSString alloc] initWithFormat:@"%@'s profil",[searchResultsUsername objectAtIndex:indexPath.row] ];
        
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[searchResultsImageURLBig objectAtIndex:indexPath.row]]];
        
        if (image.CGImage) {
            _detailViewController.photoprofilOutlet.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[searchResultsImageURLBig objectAtIndex:indexPath.row]]];
        }
        else {
            _detailViewController.photoprofilOutlet.image = [UIImage imageNamed:@"profil"];
        }

    } else {
        
        if ([arrayUsername count] != 0) {
            
            _detailViewController.usernameOutlet.text = [arrayUsername objectAtIndex:indexPath.row];
            _detailViewController.firstnameOutlet.text = [arrayFirstname objectAtIndex:indexPath.row];
            _detailViewController.lastnameOutlet.text = [arrayLastname objectAtIndex:indexPath.row];
            
            
            _detailViewController.emailOutlet.text = [arrayEmail objectAtIndex:indexPath.row];
            
            
            if ([[arrayBirthday objectAtIndex:indexPath.row] isEqualToString:@"0000-00-00"]) {
                _detailViewController.birthdateOutlet.text = @"";
            } else {
                
                // Convert date from SQL database
                NSString *dateStringSQL = [arrayBirthday objectAtIndex:indexPath.row];
                NSDateFormatter *dateFormatterSQL = [[NSDateFormatter alloc] init];
                dateFormatterSQL.dateFormat = @"yyyy-MM-dd";
                NSDate *date = [dateFormatterSQL dateFromString:dateStringSQL];
                
                NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"ddMMYYYY" options:0 locale:[NSLocale currentLocale]];
                NSDateFormatter *currentDateFormatter = [[NSDateFormatter alloc] init];
                [currentDateFormatter setDateFormat:formatString];
                currentDateFormatter.dateStyle = NSDateFormatterShortStyle;
                
                _detailViewController.birthdateOutlet.text = [currentDateFormatter stringFromDate:date];
            }
            
            
            _detailViewController.adress1Outlet.text = [arrayAdress1 objectAtIndex:indexPath.row];
            _detailViewController.adress2Outlet.text = [arrayAdress2 objectAtIndex:indexPath.row];
            
            if ([[arrayZipcode objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
                _detailViewController.zipcodeOutlet.text = @"";
            } else {
                _detailViewController.zipcodeOutlet.text = [arrayZipcode objectAtIndex:indexPath.row];
            }
            
            _detailViewController.cityOutlet.text = [arrayCity objectAtIndex:indexPath.row];
            
            
            if (![[arrayCountry objectAtIndex:indexPath.row] isEqualToString:@""]) {
                _detailViewController.imgcountryOutlet.image = [UIImage imageNamed:[arrayCountry objectAtIndex:indexPath.row]];
                
                countrypicker = [[CountryPicker alloc] init];
                [countrypicker setSelectedCountryCode:[arrayCountry objectAtIndex:indexPath.row]];
                
                _detailViewController.countryOutlet.text = countrypicker.selectedCountryName;
                
            } else {
                _detailViewController.imgcountryOutlet.image = [[UIImage alloc] init];
                _detailViewController.countryOutlet.text = @"";
            }
            
            _detailViewController.title = [[NSString alloc] initWithFormat:@"%@'s profil",[arrayUsername objectAtIndex:indexPath.row] ];
            
            
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[arrayImageURLBig objectAtIndex:indexPath.row]]];
            
            if (image.CGImage) {
                _detailViewController.photoprofilOutlet.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[arrayImageURLBig objectAtIndex:indexPath.row]]];
            }
            else {
                _detailViewController.photoprofilOutlet.image = [UIImage imageNamed:@"profil"];
            }
            

        } else {
            _detailViewController.usernameOutlet.text = @"";
            _detailViewController.firstnameOutlet.text = @"";
            _detailViewController.lastnameOutlet.text = @"";
            _detailViewController.emailOutlet.text = @"";
            _detailViewController.birthdateOutlet.text =  @"";
            _detailViewController.adress1Outlet.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1];
            _detailViewController.adress2Outlet.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1];
            _detailViewController.adress1Outlet.text =  @"Sorry, nobody is logged...";
            _detailViewController.adress2Outlet.text =  @"Try again later.";
            _detailViewController.zipcodeOutlet.text = @"";
            _detailViewController.cityOutlet.text = @"";
            _detailViewController.imgcountryOutlet.image = [[UIImage alloc] init];
            _detailViewController.countryOutlet.text = @"";
            _detailViewController.title = @"";
            _detailViewController.photoprofilOutlet.image = [UIImage imageNamed:@"profil"];
            
        }
                
            }
    
    
    // Unselect the cell
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma Search Method
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    
    // Init arrays
    searchResultsUsername = [[NSMutableArray alloc] init];
    searchResultsFirstname = [[NSMutableArray alloc] init];
    searchResultsLastname = [[NSMutableArray alloc] init];
    searchResultsImageURL = [[NSMutableArray alloc] init];
    searchResultsCountry = [[NSMutableArray alloc] init];
    
    searchResultsEmail = [[NSMutableArray alloc] init];
    searchResultsBirthday = [[NSMutableArray alloc] init];
    searchResultsAdress1 = [[NSMutableArray alloc] init];
    searchResultsAdress2 = [[NSMutableArray alloc] init];
    searchResultsZipcode = [[NSMutableArray alloc] init];
    searchResultsCity = [[NSMutableArray alloc] init];
    
    searchResultsImageURLBig = [[NSMutableArray alloc] init];

    NSMutableArray *resultArray = [usersList objectForKey:@"result"];
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"username beginswith[c] %@", searchText];
    
    NSArray *filteredArray = [resultArray filteredArrayUsingPredicate:resultPredicate];
    
    for (int i=0;i<[filteredArray count];i++) {
        
        NSDictionary* resultDict = [filteredArray objectAtIndex:i];
        
        NSMutableArray* itemUsername = [resultDict objectForKey:@"username"];
        NSMutableArray* itemFirstname = [resultDict objectForKey:@"firstname"];
        NSMutableArray* itemLastname = [resultDict objectForKey:@"lastname"];
        NSMutableArray* itemCountry = [resultDict objectForKey:@"country"];
        NSMutableArray* itemEmail = [resultDict objectForKey:@"email"];
        NSMutableArray* itemBirthday = [resultDict objectForKey:@"birthdate"];
        NSMutableArray* itemAdress1 = [resultDict objectForKey:@"adress1"];
        NSMutableArray* itemAdress2 = [resultDict objectForKey:@"adress2"];
        NSMutableArray* itemZipcode = [resultDict objectForKey:@"zipcode"];
        NSMutableArray* itemCity = [resultDict objectForKey:@"city"];
        
        [searchResultsUsername addObject:itemUsername];
        [searchResultsFirstname addObject:itemFirstname];
        [searchResultsLastname addObject:itemLastname];
        [searchResultsCountry addObject:itemCountry];
        
        [searchResultsEmail addObject:itemEmail];
        [searchResultsBirthday addObject:itemBirthday];
        [searchResultsAdress1 addObject:itemAdress1];
        [searchResultsAdress2 addObject:itemAdress2];
        [searchResultsZipcode addObject:itemZipcode];
        [searchResultsCity addObject:itemCity];

        
        NSURL* imageURL = [[API sharedInstance] urlForImage:[NSNumber numberWithInt:0] :(NSString *)itemUsername :@"profil" isThumb:YES isProfil:YES];
        
        [searchResultsImageURL addObject:imageURL];
        
        NSURL* imageURLBig = [[API sharedInstance] urlForImage:[NSNumber numberWithInt:0] :(NSString *)itemUsername :@"profil" isThumb:NO isProfil:YES];
        
        [searchResultsImageURLBig addObject:imageURLBig];
    }

}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}




- (IBAction)refreshBtnItem:(id)sender {
    
    [self allprofiles];

}

- (IBAction)searchBtnItem:(id)sender {
    
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    
    // Activate the searchbar controller
    [self.searchDisplayController setActive:YES animated:YES];
    // Show keyboard of searchbar
    [searchBarOutlet becomeFirstResponder];
    
}

- (IBAction)sortSgmntCtrlValueChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            sortBy = @"alphab";
            [self allprofiles];
            break;
        case 1:
            sortBy = @"date";
            [self allprofiles];
            break;
        case 2:
            sortBy = @"online";
            [self allprofiles];
            break;
            
        default:
            break;
    }
    
    //NSLog(@"SORT BY : %@", sortBy);
    
}


@end
