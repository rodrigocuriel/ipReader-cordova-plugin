//
//  CDVipReader.h
//  IP Reader
//
//  Created by Rodrigo Curiel on 2/5/15.
//
//

#import <Cordova/CDV.h>
#import "DTDevices.h"

@interface CDVipReader : CDVPlugin {
    UIAlertView *alert;
    DTDevices *dtdev;
}

- (void)initializeCardReader:(CDVInvokedUrlCommand*)command;
- (void)getCardReaderInfo:(CDVInvokedUrlCommand*)command;
- (void)enableLogs:(CDVInvokedUrlCommand*)command;

@end
