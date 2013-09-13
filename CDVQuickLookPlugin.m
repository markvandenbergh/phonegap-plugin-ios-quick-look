//
//  CDVQuickLookPlugin.m
//  quickLookFile
//
//  Created by Mark van den Bergh, September 10th 2013.
//  
//  You may use this code under the terms of the MIT License.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//  of the Software, and to permit persons to whom the Software is furnished to do
//  so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "CDVQuickLookPlugin.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation CDVQuickLookPlugin

- (void) quickLookFile:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString *callbackID = [arguments pop];
    NSString *path = [arguments objectAtIndex:0];     
    
    // determine UTI from file extension
    NSString *extension = [[arguments objectAtIndex:0] pathExtension];
    NSString *uti = (NSString *) UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (CFStringRef)extension, NULL);
    
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *fileURL = [NSURL URLWithString:path];
    UIDocumentInteractionController *controller = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    
    controller.delegate = self;
    controller.UTI = uti;
    
    BOOL menuOpenened = [controller presentPreviewAnimated:YES];
    
    CDVPluginResult* pluginResult;
    if (!menuOpenened) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: @""];
        [self writeJavascript: [pluginResult toErrorCallbackString:callbackID]];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: @""];
        [self writeJavascript: [pluginResult toSuccessCallbackString:callbackID]];
    }
}

- (UIViewController *) documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *) controller {
    return self.viewController;
}

@end
