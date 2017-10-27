//
//  Webim.swift
//  WebimClientLibraryWrapper
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


import Foundation
import WebimClientLibrary


// MARK: - Webim
@objc(Webim)
final class _ObjCWebim: NSObject {
    
    // MARK: - Methods
    
    @objc
    static func newSessionBuilder() -> _ObjCSessionBuilder {
        return _ObjCSessionBuilder(sessionBuilder: Webim.newSessionBuilder())
    }
    
    @objc(parseRemoteNotification:)
    static func parse(remoteNotification: [AnyHashable: Any]) -> _ObjCWebimPushNotification? {
        if let webimPushNotification = try? Webim.parse(remoteNotification: remoteNotification) {
            return _ObjCWebimPushNotification(webimPushNotification: webimPushNotification!)
        } else {
            return nil
        }
    }
    
    @objc(isWebimRemoteNotification:error:)
    static func isWebim(remoteNotification: [AnyHashable : Any]) throws -> NSNumber {
        return try Webim.isWebim(remoteNotification: remoteNotification) as NSNumber
    }
    
    
    // MARK: - PushNotificationSystem
    @objc(PushNotificationSystem)
    enum _ObjCPushNotificationSystem: Int {
        case APNS
        case NONE
    }
    
}

// MARK: - SessionBuilder
@objc(SessionBuilder)
final class _ObjCSessionBuilder: NSObject {
    
    // MARK: - Properties
    private (set) var sessionBuilder: SessionBuilder
    
    
    // MARK: - Initialization
    init(sessionBuilder: SessionBuilder) {
        self.sessionBuilder = sessionBuilder
    }
    
    
    // MARK: - Methods
    
    @objc(setAccountName:)
    func set(accountName: String) -> _ObjCSessionBuilder {
        sessionBuilder = sessionBuilder.set(accountName: accountName)
        return self
    }
    
    @objc(setLocation:)
    func set(location: String) -> _ObjCSessionBuilder {
        sessionBuilder = sessionBuilder.set(location: location)
        return self
    }
    
    @objc(setAppVersion:)
    func set(appVersion: String) -> _ObjCSessionBuilder {
        sessionBuilder = sessionBuilder.set(appVersion: appVersion)
        return self
    }
    
    @objc(setVisitorFieldsJSONString:)
    func set(visitorFieldsJSONString: String) -> _ObjCSessionBuilder {
        sessionBuilder = sessionBuilder.set(visitorFieldsJSONString: visitorFieldsJSONString)
        return self
    }
    
    @objc(setVisitorFieldsJSONData:)
    func set(visitorFieldsJSONData: Data) -> _ObjCSessionBuilder {
        sessionBuilder = sessionBuilder.set(visitorFieldsJSONData: visitorFieldsJSONData)
        return self
    }
    
    @objc(setPageTitle:)
    func set(pageTitle: String) -> _ObjCSessionBuilder {
        sessionBuilder = sessionBuilder.set(pageTitle: pageTitle)
        return self
    }
    
    @objc(setFatalErrorHandler:)
    func set(fatalErrorHandler: _ObjCFatalErrorHandler) -> _ObjCSessionBuilder {
        sessionBuilder = sessionBuilder.set(fatalErrorHandler: FatalErrorHandlerWrapper(fatalErrorHandler: fatalErrorHandler))
        return self
    }
    
    @objc(setPushNotificationSystem:)
    func set(pushNotificationSystem: _ObjCWebim._ObjCPushNotificationSystem) -> _ObjCSessionBuilder {
        var webimPushNotificationSystem: Webim.PushNotificationSystem?
        switch pushNotificationSystem {
        case .APNS:
            webimPushNotificationSystem = Webim.PushNotificationSystem.APNS
        default:
            webimPushNotificationSystem = Webim.PushNotificationSystem.NONE
        }
        sessionBuilder = sessionBuilder.set(pushNotificationSystem: webimPushNotificationSystem!)
        
        return self
    }
    
    @objc(setDeviceToken:)
    func set(deviceToken: String?) -> _ObjCSessionBuilder {
        sessionBuilder = sessionBuilder.set(deviceToken: deviceToken)
        return self
    }
    
    @objc(setIsLocalHistoryStoragingEnabled:)
    public func set(isLocalHistoryStoragingEnabled: Bool) -> _ObjCSessionBuilder {
        sessionBuilder = sessionBuilder.set(isLocalHistoryStoragingEnabled: isLocalHistoryStoragingEnabled)
        return self
    }
    
    @objc(setIsVisitorDataClearingEnabled:)
    func set(isVisitorDataClearingEnabled: Bool) -> _ObjCSessionBuilder {
        sessionBuilder = sessionBuilder.set(isVisitorDataClearingEnabled: isVisitorDataClearingEnabled)
        return self
    }
    
    @objc(build:)
    func build() throws -> _ObjCWebimSession {
        return try _ObjCWebimSession(webimSession: sessionBuilder.build())
    }
    
}


// MARK: - Protocols' wrappers
fileprivate final class FatalErrorHandlerWrapper: FatalErrorHandler {
    
    // MARK: - Properties
    private let fatalErrorHandler: _ObjCFatalErrorHandler
    
    // MARK: - Initialization
    init(fatalErrorHandler: _ObjCFatalErrorHandler) {
        self.fatalErrorHandler = fatalErrorHandler
    }
    
    // MARK: - Methods
    // MARK: FatalErrorHandler methods
    func on(error: WebimError) {
        fatalErrorHandler.on(error: _ObjCWebimError(webimError: error))
    }
    
}
