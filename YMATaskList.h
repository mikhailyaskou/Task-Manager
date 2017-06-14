//
//  YMATaskList.h
//  Task Manager
//
//  Created by Mikhail Yaskou on 05.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMATaskList : NSObject

@property (nonatomic, assign) NSNumber *IdTaskList;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, copy) NSArray *tasksList;


@end
