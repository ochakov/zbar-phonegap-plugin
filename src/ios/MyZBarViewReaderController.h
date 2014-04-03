//
//  MyZBarViewReaderController.h
//  ToddTool
//
//  Created by Timofey Tatarinov on 03.02.14.
//
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

typedef void(^MyZBarCancelCallback)();

@interface MyZBarViewReaderController : ZBarReaderViewController
{
    UIView* redLine;
    UIButton* cancelButton;
}

@property (nonatomic, copy) MyZBarCancelCallback cancelCallback;

@end
