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
@synthesize callbackId;

- (void)showZbar:(CDVInvokedUrlCommand *)command
{
    if (!self.readerController)
    {
        MyZBarViewReaderController* myReaderController = [[MyZBarViewReaderController alloc] init];
        myReaderController.cancelCallback = ^() {
            CDVPluginResult* pluginResult = nil;
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:nil];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
        };
        
        self.readerController = myReaderController;
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
    
    self.callbackId = command.callbackId;
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    //UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
    ZBarSymbol *symbol = nil;
    NSString* result = nil;
    
    for(symbol in results) {
        result = symbol.data;
        break;
    }
    
    // if you need a javascript callback I would put it here (example)
    // the callback can use the barcode data that was stored in window.plugins.ZbarPlug.data
    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [[super viewController] dismissModalViewControllerAnimated:YES];

    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [[super viewController] dismissModalViewControllerAnimated:YES];
}

@end
