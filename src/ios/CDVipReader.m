//
//  CDVipReader.m
//  IP Reader
//
//  Created by Rodrigo Curiel on 2/5/15.
//
//

#import <Cordova/CDV.h>
#import "CDVipReader.h"

@implementation CDVipReader
BOOL showLogs=NO;

-(UIAlertView *)displayAlert:(NSString *)title message:(NSString *)message
{
    if(alert)
    {
        [alert dismissWithClickedButtonIndex:0 animated:FALSE];
        alert=nil;
    }

    alert = [[UIAlertView alloc]
             initWithTitle:title
             message:message
             delegate:nil
             cancelButtonTitle:@"Ok"
             otherButtonTitles:nil, nil];
    [alert show];
    return alert;
}

- (void)enableLogs:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    BOOL enableLogsFlag = [[command.arguments objectAtIndex:0] boolValue];

    if (enableLogsFlag) {
        showLogs=enableLogsFlag;
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"enableLogs flag is required"];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)magneticCardData:(NSString *)track1 track2:(NSString *)track2 track3:(NSString *)track3
{

    NSString *jsStatement = [NSString stringWithFormat:@"ipReader.onMagneticCardData('%@', '%@', '%@');",
                             track1, track2, track3];
    [self.webView stringByEvaluatingJavaScriptFromString:jsStatement];
}

-(void)magneticCardEncryptedData:(int)encryption tracks:(int)tracks data:(NSData *)data track1masked:(NSString *)track1masked track2masked:(NSString *)track2masked track3:(NSString *)track3 source:(int)source;
{
    NSString *parameters = [NSString stringWithFormat: @"%d, %d, '%@', '%@', '%@', '%@', %d", encryption, tracks, data, track1masked, track2masked, track3, source];
    [self displayAlert:@"magneticCardEncryptedData" message:parameters];
    NSString *jsStatement = [NSString stringWithFormat:@"ipReader.onMagneticCardEncryptedData(%@);", parameters];
    [self.webView stringByEvaluatingJavaScriptFromString:jsStatement];
}

-(void)connectionState:(int)state {
    BOOL scPresent=NO;
    NSString *jsStatement = [NSString stringWithFormat:@"ipReader.onConnectionState('%d');", state];
    [self.webView stringByEvaluatingJavaScriptFromString:jsStatement];

    switch (state) {
        case CONN_DISCONNECTED:
        case CONN_CONNECTING:
            NSLog(@"IP not connected");
            break;
        case CONN_CONNECTED:
        {
            if (showLogs) {
                [self displayAlert:@"connected" message:[NSString stringWithFormat:@"PPad connected!\nSDK version: %d.%d\nHardware revision: %@\nFirmware revision: %@\nSerial number: %@",dtdev.sdkVersion/100,dtdev.sdkVersion%100,dtdev.hardwareRevision,dtdev.firmwareRevision,dtdev.serialNumber]];
            }

            scPresent=[dtdev scInit:SLOT_MAIN error:nil];
            scPresent=[dtdev scCardPowerOn:SLOT_MAIN error:nil];
            [dtdev emsrSetEncryption:ALG_EH_AES256 params:nil error:nil];
            scPresent=[dtdev emsrConfigMaskedDataShowExpiration:YES unmaskedDigitsAtStart:4 unmaskedDigitsAtEnd:4 unmaskedDigitsAfter:4 error:nil];
            break;
        }
    }
}

- (void)getCardReaderInfo:(CDVInvokedUrlCommand*)command
{
    NSString* echo = @"NOT_CONNECTED";
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:echo];

    if(dtdev.connstate==CONN_CONNECTED){
        NSDictionary *cardReaderInfo = @{
                                         @"SDK" : [NSNumber numberWithFloat:dtdev.sdkVersion],
                                         @"hardware" : dtdev.hardwareRevision,
                                         @"firmware" : dtdev.firmwareRevision,
                                         @"serial_number" : dtdev.serialNumber,
                                         };
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:cardReaderInfo];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)initializeCardReader:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        dtdev=[DTDevices sharedDevice];
        [dtdev addDelegate:self];
        [dtdev connect];
    }];

    NSString* echo = @"Card Reader not connected";
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
