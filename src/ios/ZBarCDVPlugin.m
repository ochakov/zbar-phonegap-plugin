//
//  ZBarCDVPlugin.m
//  Planstery
//
//  Created by Timofey Tatarinov on 07.01.14.
//
//

#import "ZBarCDVPlugin.h"
#import "MyZBarViewReaderController.h"

@implementation ZBarCDVPlugin

@synthesize readerController;

- (void)showZbar:(CDVInvokedUrlCommand *)command
{
    if (!self.readerController)
    {
        self.readerController = [[MyZBarViewReaderController alloc] init];
        UIView *cameraOverlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        self.readerController.cameraOverlayView = cameraOverlayView;
        self.readerController.readerDelegate = self;
        ZBarImageScanner *scanner = self.readerController.scanner;
        [scanner setSymbology: ZBAR_I25
                       config: ZBAR_CFG_ENABLE
                           to: 0];
        
        [readerController setSupportedOrientationsMask:UIInterfaceOrientationPortrait];

    }
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
        
        break;
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
