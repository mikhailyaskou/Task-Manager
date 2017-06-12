//
//  YMAInboxViewController.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 03.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAAddAndEditTaskViewController.h"
#import "YMAInboxViewController.h"
#import "YMATaskService.h"
#import "YMATask.h"
#import "YMADetailViewController.h"
#import "YMAConstants.h"

static NSString * const YMACellIdentifier = @"YMATaskCell";
static NSString * const YMADetailViewControllerIdentifier = @"detailView";

@interface YMAInboxViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YMAInboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.taskService = [[YMATaskService alloc] initWithTasks:[NSMutableArray new]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskReceived:) name:YMAReceivedTaskNotificationName object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.tableView reloadData];
}

#pragma mark - Notification

- (void)taskReceived:(NSNotification *) notification {
    NSDictionary *dict = notification.userInfo;
    YMATask *task = dict[YMATaskNotificationKey];
    [self.taskService incomingTask:task];
}

#pragma mark - Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.taskService.numberOfTasks;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YMACellIdentifier];
    NSUInteger index = (NSUInteger) [indexPath row];
    cell.textLabel.text = [self.taskService taskByIndex:index].name;
    return cell;
}

#pragma mark - Actions

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YMADetailViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:YMADetailViewControllerIdentifier];
    detailView.task = [self.taskService taskByIndex:(NSUInteger) indexPath.row];
    [self showViewController:detailView sender:nil];
}

- (IBAction)addTapped:(id)sender {
    YMAAddAndEditTaskViewController *addViewController = [[YMAAddAndEditTaskViewController alloc]initWithNibName:YMAAddTaskViewControllerNibName bundle:nil];
    [self showViewController:addViewController sender:nil];
}

@end
