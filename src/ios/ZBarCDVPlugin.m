//
//  ZBarCDVPlugin.m
//  Planstery
//
//  Created by Timofey Tatarinov on 07.01.14.
//
//

#import "ZBarCDVPlugin.h"

@implementation ZBarCDVPlugin

@synthesize readerController;

- (void)showZbar:(CDVInvokedUrlCommand *)command
{
    double screenWidth = [UIScreen mainScreen].bounds.size.width;
    double screenHeight = [UIScreen mainScreen].bounds.size.height;

    if (!self.readerController)
    {
        self.readerController = [ZBarReaderViewController new];
        
        double overlayWidth = screenWidth;
        double overlayHeight = screenWidth * 0.3;
        double overlayX = (screenWidth - overlayWidth) / 2;
        double overlayY = (screenHeight - overlayHeight) / 2;
        
        
        NSLog(@"%f %f %f %f", overlayX, overlayY, overlayWidth, overlayHeight);
        
        UIView *cameraOverlayView = [[UIView alloc] initWithFrame:CGRectMake(overlayX, overlayY, overlayWidth, overlayHeight)];
        cameraOverlayView.backgroundColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.1];
        
        self.readerController.cameraOverlayView = cameraOverlayView;
    }
    self.readerController.readerDelegate = self;
    
    ZBarImageScanner *scanner = self.readerController.scanner;
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    

    CGFloat x,y,width,height;
    x = self.readerController.cameraOverlayView.frame.origin.x / screenWidth;
    y = self.readerController.cameraOverlayView.frame.origin.y / screenHeight;
    width = self.readerController.cameraOverlayView.frame.size.width / screenWidth;
    height = self.readerController.cameraOverlayView.frame.size.height / screenHeight;
    
    [self.readerController setScanCrop:CGRectMake(y, x, height, width)];      // for portrait
//    [self.readerController setScanCrop:CGRectMake(x, y, width, height)];        // for landscape

    // present and release the controller
    [[super viewController] presentModalViewController:self.readerController animated: YES];
    
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"ShowZBar"];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    //UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
    ZBarSymbol *symbol = nil;
    
    for(symbol in results) {
        NSString* retStr = [ NSString stringWithFormat:@"ZBarCDVPlugin.addResult(\"%@\");", symbol.data];
        [[super webView] stringByEvaluatingJavaScriptFromString:retStr];
    }
    
    // if you need a javascript callback I would put it here (example)
    // the callback can use the barcode data that was stored in window.plugins.ZbarPlug.data
    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [[super viewController] dismissModalViewControllerAnimated:YES];
    NSString* callbackStr = [ NSString stringWithFormat:@"ZBarCDVPlugin.resultCallback()"];
    // this will execute the your javascript callback
    [[super webView] stringByEvaluatingJavaScriptFromString:callbackStr];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [[super viewController] dismissModalViewControllerAnimated:YES];
    
    NSString* callbackStr = [ NSString stringWithFormat:@"ZBarCDVPlugin.cancelCallback()"];
    [[super webView] stringByEvaluatingJavaScriptFromString:callbackStr];
}

-(void) readerControllerDidFailToRead:(ZBarReaderController*)reader withRetry:(BOOL)retry
{
    [[super viewController] dismissModalViewControllerAnimated:YES];
    
    NSString* callbackStr = [ NSString stringWithFormat:@"ZBarCDVPlugin.failCallback()"];
    [[super webView] stringByEvaluatingJavaScriptFromString:callbackStr];

}

@end
