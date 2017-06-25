//
//  YMATaskTableViewCell.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 13.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMATaskTableViewCell.h"
#import "YMATask.h"
#import "YMADateHelper.h"
#import "YMAConstants.h"

@implementation YMATaskTableViewCell

+ (instancetype)idequeueReusableCellWithTask:(YMATask *)task tableView:(UITableView *)tableView {
    YMATaskTableViewCell *instance = [tableView dequeueReusableCellWithIdentifier:YMATaskTableViewCellNibName];
    instance.nameLabel.text = task.name;
    instance.noteLabel.text = task.note;
    instance.dateLabel.text = [YMADateHelper stringFromDate:task.startDate];
    return instance;
}

@end
