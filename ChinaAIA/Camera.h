//
//  Camera.h
//  ChinaAIA
//
//  Created by Quix Creations Singapore iOS 1 on 8/9/15.
//  Copyright © 2015 Terry Chia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface Camera : UIViewController <AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>

@property(weak, nonatomic)IBOutlet UIView *viewPreview;
@property(weak, nonatomic)IBOutlet UILabel *lblStatus;
@property(weak, nonatomic)IBOutlet UIBarButtonItem *bbitemStart;


-(IBAction)startStopReaeding:(id)sender;

@end
