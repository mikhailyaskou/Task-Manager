//
//  YMATaskTableViewCell.h
//  Task Manager
//
//  Created by Mikhail Yaskou on 13.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMATaskTableViewCell : UITableViewCell
@property(weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(weak, nonatomic) IBOutlet UILabel *noteLabel;
@property(weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
