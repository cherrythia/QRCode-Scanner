//
//  Camera.m
//  ChinaAIA
//
//  Created by Quix Creations Singapore iOS 1 on 8/9/15.
//  Copyright © 2015 Terry Chia. All rights reserved.
//

//http://www.appcoda.com/qr-code-ios-programming-tutorial/

#import "Camera.h"
#import "ViewController.h"

@interface Camera ()
@property (nonatomic) BOOL isReading;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic) NSString *stringFromQRCode;
@property(nonatomic,strong) NSDictionary *dicFromQRString;


-(BOOL)startReading;
-(void)stopReading;
-(void)loadBeepSound;
-(void)alertUserOfWhatIsRead;
@end

@implementation Camera

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isReading = NO;
    self.captureSession = nil;
    
    [self loadBeepSound];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)startStopReaeding:(id)sender{
    if (!self.isReading) {
        if ([self startReading]) {
            [self.bbitemStart setTitle:@"Stop!"];
            [self.lblStatus setText:@"Scanning for QR Code"];
        }
    }
    else{
        [self stopReading];
        [self.bbitemStart setTitle:@"Start!"];
    }
    self.isReading = !self.isReading;
}

-(BOOL)startReading{
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        NSLog(@"%@",[error localizedDescription]);
        return NO;
    }
    
    self.captureSession = [[AVCaptureSession alloc]init];
    [self.captureSession addInput:input];
    
    //output with metadata
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc]init];
    [self.captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    //show what the camera sees
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.videoPreviewLayer setFrame:self.viewPreview.layer.bounds];
    [self.viewPreview.layer addSublayer:self.videoPreviewLayer];
    
    [self.captureSession startRunning];
    
    return YES;
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects !=nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObjc = [metadataObjects objectAtIndex:0];
        if ([[metadataObjc type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            //Here is where it has read a succesful QR code
            [self.lblStatus performSelectorOnMainThread:@selector(setText:) withObject:[metadataObjc stringValue] waitUntilDone:NO];
            self.stringFromQRCode = [NSString stringWithFormat:@"%@",[metadataObjc valueForKey:@"stringValue"]]; //set string to QRCode text
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            [self.bbitemStart performSelectorOnMainThread:@selector(setTitle:) withObject:@"Start!" waitUntilDone:NO];
            self.isReading = NO;
            [self performSelectorOnMainThread:@selector(alertUserOfWhatIsRead) withObject:nil waitUntilDone:NO];   //method breaks the string and store them into a dictionary and tells the user what is being read
            
            if (self.audioPlayer) {
                [self.audioPlayer play];
            }
            
        }
    }
}

-(void)stopReading{
    [self.captureSession stopRunning];
    self.captureSession = nil;
    
    
    [self.videoPreviewLayer removeFromSuperlayer];
}

-(void)loadBeepSound{
    NSString *beepFilePath = [[NSBundle mainBundle]pathForResource:@"beep" ofType:@".mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    NSError *error;
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        NSLog(@"Could not play a beep file");
        NSLog(@"%@",[error localizedDescription]);
    }else{
        [self.audioPlayer prepareToPlay];
    }
}

-(void)alertUserOfWhatIsRead{
    NSArray *tempArrayToStoreComponenetsSeperateByString = [[NSArray alloc]init];
    tempArrayToStoreComponenetsSeperateByString = [self.stringFromQRCode componentsSeparatedByString:@","];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    self.dicFromQRString = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            tempArrayToStoreComponenetsSeperateByString[0],@"name",
                            tempArrayToStoreComponenetsSeperateByString[1],@"age",
                            tempArrayToStoreComponenetsSeperateByString[2],@"birthday",
                            dateString,@"date & time",
                             nil];
    
    NSLog(@"%@",self.dicFromQRString);
    
    
//    //Success
//    NSString *messageForAlert = [NSString stringWithFormat:@"Name is %@\r Age = %@ \r Date of Birth = %@ \r Time Saved = %@",
//                                 self.dicFromQRString[@"name"],
//                                 self.dicFromQRString[@"age"],
//                                 self.dicFromQRString[@"birthday"],
//                                 self.dicFromQRString[@"date & time"]];
    
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"User Particulars"
//                                                   message:messageForAlert
//                                                  delegate:self
//                                         cancelButtonTitle:@"Save!"
//                                         otherButtonTitles:nil];
    
//    [alert show];
    
    
    //failure
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]) {

        [self.navigationController popToRootViewControllerAnimated:YES];
        
        //pass the dicitonary into tableviewcontroller using protocol here
//        [self.delegate dataFromCameraView:self.dicFromQRString];
        
    }
}

@end
