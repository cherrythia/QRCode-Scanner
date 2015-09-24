//
//  ViewController.h
//  ChinaAIA
//
//  Created by Quix Creations Singapore iOS 1 on 8/9/15.
//  Copyright © 2015 Terry Chia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Camera.h"

@interface ViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSMutableArray *tableData;

@end

