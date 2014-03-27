//
//  MyZBarViewReaderController.m
//  ToddTool
//
//  Created by Timofey Tatarinov on 03.02.14.
//
//

#import "MyZBarViewReaderController.h"

@implementation MyZBarViewReaderController

- (void)cancel:(UIButton*)button {
    NSLog(@"!!!");
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)changeOverlayFrame:(UIInterfaceOrientation)interfaceOrientation readerController:(ZBarReaderViewController*) readerController
{
    BOOL isPortrait = (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    double screenWidth = isPortrait ? [UIScreen mainScreen].bounds.size.width: [UIScreen mainScreen].bounds.size.height;
    double screenHeight = isPortrait ? [UIScreen mainScreen].bounds.size.height: [UIScreen mainScreen].bounds.size.width;
    
    double overlayWidth = isPortrait ? screenWidth : screenWidth * 2 / 3;
    double overlayHeight = [UIScreen mainScreen].bounds.size.width * 0.3;
    double overlayX = (screenWidth - overlayWidth) / 2;
    double overlayY = (screenHeight - overlayHeight) / 2;
    
    NSLog(@"%f %f %f %f", overlayX, overlayY, overlayWidth, screenHeight);
    
    [readerController.cameraOverlayView setFrame:CGRectMake(overlayX, overlayY, overlayWidth, overlayHeight)];
    
    readerController.cameraOverlayView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3];

    if (!redLine) {
        redLine = [UIView new];
        redLine.backgroundColor = [UIColor redColor];
        [cameraOverlayView addSubview:redLine];
    }
    [redLine setFrame:CGRectMake(0, self.cameraOverlayView.frame.size.height / 2, cameraOverlayView.frame.size.width, 2)];
    
    if (!cancelButton) {
        cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        cancelButton.titleLabel.textColor = [UIColor blueColor];
        cancelButton.titleLabel.textAlignment = UITextAlignmentLeft;
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [cancelButton addTarget:self
                         action:@selector(cancel:)
               forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cancelButton];
    }
    [cancelButton setFrame:CGRectMake(0, screenHeight - 40, cameraOverlayView.frame.size.width / 4, 40)];
     
    
    CGFloat x,y,width,height;
    x = readerController.cameraOverlayView.frame.origin.x / screenWidth;
    y = readerController.cameraOverlayView.frame.origin.y / screenHeight;
    width = readerController.cameraOverlayView.frame.size.width / screenWidth;
    height = readerController.cameraOverlayView.frame.size.height / screenHeight;
    
    if (isPortrait) {
        [readerController setScanCrop:CGRectMake(y, x, height, width)];     // for portrait
    } else {
        [readerController setScanCrop:CGRectMake(x, y, width, height)];     // landscape
    }
}


-(id)init {
    return [super init];
}

-(void)viewDidLoad {
    //NSLog(@"%@", [[self.view.subviews objectAtIndex:1] subviews]);
    [self setShowsZBarControls:FALSE];
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setShowsZBarControls:FALSE];
    [self changeOverlayFrame:UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) readerController:self];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self changeOverlayFrame:toInterfaceOrientation readerController:self];
    [readerView start];
}


@end
