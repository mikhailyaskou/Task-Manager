//
//  YMAInboxViewController.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 03.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAAddTaskViewController.h"
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
    
}

-(void)viewWillAppear:(BOOL)animated{
     [self.tableView reloadData];
}

#pragma mark - Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.taskServiceModel.numberOftasks;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YMATaskCell"];
    long index = [indexPath row];
    cell.textLabel.text = [self.taskServiceModel taskByIndex:index].name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YMADetailViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"detailView"];
    detailView.tasks = self.taskServiceModel;
    detailView.index = indexPath.row;
    [self showViewController:detailView sender:nil];
    
}

#pragma mark - Actions

- (IBAction)addTaped:(id)sender {
    YMAAddTaskViewController *addView = [[YMAAddTaskViewController alloc]initWithNibName:@"YMAAddTaskViewController" bundle:nil];
    addView.delegate = self;
    [self showViewController:addView sender:nil];
}

#pragma mark - Delegate

-(void)addTaskToList:(YMATaskModel *)task{
    [self.taskServiceModel addTask:task];
}

@end
