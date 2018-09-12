//
//  ViewController.m
//  ObjectiveCExample
//
//  Created by Nikita Lazarev-Zubov on 26.10.17.
//  Copyright © 2017 Webim. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//


#import "ViewController.h"


// MARK: - Constants
static NSString *ACCOUNT_NAME = @"demo";
static NSString *LOCATION = @"mobile";


// MARK: -
@interface ViewController ()

@end


// MARK: -
@implementation ViewController

// MARK: - Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error = nil;

    SessionBuilder *sessionBuilder = [Webim newSessionBuilder];
    sessionBuilder = [sessionBuilder setAccountName:ACCOUNT_NAME];
    sessionBuilder = [sessionBuilder setLocation:LOCATION];
    sessionBuilder = [sessionBuilder setWebimLogger:self verbosityLevel:WebimLoggerVerbosityLevelVERBOSE];
    sessionBuilder = [sessionBuilder setFatalErrorHandler:self];
    WebimSession *webimSession = [sessionBuilder build:&error];
    
    /* This syntax is closer to README.MD examples:
    WebimSession *anotherWebimSession = [[[[Webim newSessionBuilder]
                                           setAccountName:ACCOUNT_NAME]
                                          setLocation:LOCATION]
                                         build:&error];
    */
    
    [webimSession resume:&error];
    
    MessageStream *messageStream = [webimSession getStream];
    MessageTracker *messageTracker = [messageStream newMessageTrackerWithMessageListener:self
                                                                                   error:&error];
    [messageTracker getNextMessagesByLimit:25
                                completion:^(NSArray *messages) {
                                    // Handle response.
                                }
                                     error:&error];
    if (error != nil) {
        // Handle error.
    }
    
    NSString *messageID = [messageStream sendMessage:@"Wrapper test."
                                               error:&error];
    if (error != nil) {
        // Handle error.
    }
}

// MARK: MessageListener protocol methods

- (void)addedMessage:(Message * _Nonnull)newMessage
               after:(Message * _Nullable)previousMessage {
    // Handle adding.
}

- (void)changedMessage:(Message * _Nonnull)oldVersion
                    to:(Message * _Nonnull)newVersion {
    // Handle changing.
}

- (void)removedAllMessages {
    // Handle removing.
}

- (void)removedMessage:(Message * _Nonnull)message {
    // Handle removing.
}

- (void) logEntry:(NSString *)entry {
    NSLog(@"%@", entry);
}

- (void)onError:(WebimError * _Nonnull)error {
    NSLog(@"%@", @"Here error!");
}

@end
