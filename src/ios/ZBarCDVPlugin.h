//
//  ZBarCDVPlugin.h
//  Planstery
//
//  Created by Timofey Tatarinov on 07.01.14.
//
//

#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>
#import "ZBarSDK.h"

@interface ZBarCDVPlugin : CDVPlugin <ZBarReaderViewDelegate>
{
    ZBarReaderViewController* readerController;
}

- (void)showZbar:(CDVInvokedUrlCommand*)command;

@property(retain, nonatomic) ZBarReaderViewController* readerController;

@end
