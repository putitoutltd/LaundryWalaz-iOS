//
//  PIOSideBarViewController.m
//  LaundryWalaz
//
//  Created by pito on 6/24/16.
//  Copyright © 2016 pito. All rights reserved.
//

#import "PIOSideBarViewController.h"
#import "PIOSideBarCustomTableViewCell.h"
#import "PIOOrderViewController.h"
#import "PIOAppController.h"
#import "CDRTranslucentSideBar.h"
#import "PIOConstants.h"

@interface PIOSideBarViewController ()

@property (nonatomic, weak) IBOutlet UITableView *dashboardTableView;

@end

@implementation PIOSideBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        CGRect tableViewRect = self.dashboardTableView.frame;
        tableViewRect.size.height = 7 * 42;
        self.dashboardTableView.frame = tableViewRect;
    self.dashboardTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.dashboardTableView setSeparatorInset:UIEdgeInsetsZero];
    self.view.frame = self.view.window.frame;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PIOHideSideBarView" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideBarView) name:@"PIOHideSideBarView" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PIOSideBarCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PIOSideBarCustomTableViewCell"];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PIOSideBarCustomTableViewCell" owner:self options:nil] objectAtIndex:0];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
    }
    
    //    cell.iconImageView.image = [UIImage imageNamed:[self.dashboardImages objectAtIndex:indexPath.row]];
    
    cell.titleLabel.text = PIODashboardTitles[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *visibleViewController = [[PIOAppController sharedInstance] navigationController].visibleViewController;
    if ([visibleViewController isKindOfClass:[CDRTranslucentSideBar class]]) {
        CDRTranslucentSideBar *bar = (CDRTranslucentSideBar *)visibleViewController;
        [bar dismissAnimated:YES];
        [visibleViewController removeFromParentViewController];
    }
    
    NSArray *viewControllers = [[PIOAppController sharedInstance] navigationController].viewControllers;
    visibleViewController = [viewControllers objectAtIndex:[viewControllers count]-1];
    
    switch (indexPath.row) {
            case PIODashboardRowTypeLogout: {
                
                break;
            }
            
            
            case PIODashboardRowTypeHowItWorks: {
                break;
            }
            
            
            case PIODashboardRowTypeHelp: {
                
                break;
            }
            
            case PIODashboardRowTypeTsAndCs: {
                break;
            }
            case PIODashboardRowTypePrivacy: {
                
                break;
            }
            case PIODashboardRowTypeOrder: {
                
                if (![visibleViewController isKindOfClass:[PIOOrderViewController class]] ) {
                    
                    PIOOrderViewController *orderViewController;
                    for (UIViewController *viewController in viewControllers) {
                        if ([viewController isKindOfClass:[PIOOrderViewController class]]) {
                            orderViewController = (PIOOrderViewController *)viewController;
                            break;
                        }
                    }
                    if (orderViewController == nil) {
                        orderViewController = [PIOOrderViewController new];
                        [[[PIOAppController sharedInstance] navigationController] pushViewController: orderViewController animated:NO];
                    } else {
                        
                        [[[PIOAppController sharedInstance] navigationController] popToViewController: orderViewController animated:NO];
                    }
                }
                
                break;
            }
            case PIODashboardRowTypePricing: {
                
                break;
            }
        default:
            break;
            
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}

- (void)hideBarView
{
    UIViewController *visibleViewController = [[PIOAppController sharedInstance] navigationController].visibleViewController;
    if ([visibleViewController isKindOfClass:[CDRTranslucentSideBar class]]) {
        CDRTranslucentSideBar *bar = (CDRTranslucentSideBar *)visibleViewController;
        [bar dismissAnimated:YES];
        [visibleViewController removeFromParentViewController];
    }
}
- (IBAction)crossButtonPressed:(id)sender
{
    [self hideBarView];
}

@end