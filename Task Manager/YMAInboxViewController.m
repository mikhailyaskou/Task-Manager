//
//  YMAInboxViewController.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 03.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAAddAndEditTaskViewController.h"
#import "YMAInboxViewController.h"
#import "YMATaskServiceModel.h"
#import "YMATaskModel.h"
#import "YMADetailViewController.h"

@interface YMAInboxViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YMAInboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.taskServiceModel = [YMATaskServiceModel new];
    YMATaskModel *task = [[YMATaskModel alloc] initWithIdTask:1 name:@"Купи молока" note:@"Купить хорошего молока" startDate:[NSDate date]];
    [self.taskServiceModel addTask:task];
    task = [[YMATaskModel alloc] initWithIdTask:2 name:@"Sell milk" note:@"sell milk in store" startDate:[NSDate date]];
    [self.taskServiceModel addTask:task];
    task = [[YMATaskModel alloc] initWithIdTask:3 name:@"buy new staff" note:@"buy new staff" startDate:[NSDate date]];
    [self.taskServiceModel addTask:task];
    //notification that add task;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskReccived:) name:@"recciveTask" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTaskInLis:) name:@"updateTask" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

#pragma mark - Notification

-(void) taskReccived:(NSNotification *) notification {
    NSDictionary *dict = notification.userInfo;
    NSInteger indexOfTask  = [[dict valueForKey:@"indexOfTask"] integerValue];
    YMATaskModel *task = [dict valueForKey:@"task"];
    if (indexOfTask < 0) {
        //adding mode;
        [self.taskServiceModel addTask:task];
    }
    else
    {
        //editing mode;
        [self.taskServiceModel update:indexOfTask task:task];
    }
}

#pragma mark - Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.taskServiceModel.numberOftasks;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YMATaskCell"];
    NSUInteger index = [indexPath row];
    cell.textLabel.text = [self.taskServiceModel taskByIndex:index].name;
    return cell;
}

#pragma mark - Actions

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YMADetailViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"detailView"];
    
    detailView.task = [self.taskServiceModel taskByIndex:indexPath.row];
    detailView.indexOfTaskInList = indexPath.row;
    [self showViewController:detailView sender:nil];
}

- (IBAction)addTaped:(id)sender {
    YMAAddAndEditTaskViewController *addView = [[YMAAddAndEditTaskViewController alloc]initWithNibName:@"YMAAddTaskViewController" bundle:nil];
    addView.indexOfTaskInList = -1;
    [self showViewController:addView sender:nil];
}

@end
