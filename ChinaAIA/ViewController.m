//
//  ViewController.m
//  ChinaAIA
//
//  Created by Quix Creations Singapore iOS 1 on 8/9/15.
//  Copyright © 2015 Terry Chia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableData = [[NSMutableArray alloc]initWithObjects:@"test1",@"test2", nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *tableCellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifier];
    }
    
    cell.textLabel.text = [self.tableData objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)dataFromCameraView:(NSDictionary *)dicFromQRString{
    [self.tableData addObject:dicFromQRString];
    NSLog(@"Table data = %@",self.tableData);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"toCameraView"]) {
        Camera *cameraViewController = [[Camera alloc]init];
//        cameraViewController.delegate = self;
    }
}

@end
