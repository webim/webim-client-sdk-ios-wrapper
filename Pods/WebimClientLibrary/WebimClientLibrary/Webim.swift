//
//  Webim.swift
//  WebimClientLibrary
//
//  Created by Nikita Lazarev-Zubov on 02.08.17.
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

/**
 Main point of WebimClientLibrary.
 - author:
 Nikita Lazarev-Zubov
 - copyright:
 2017 Webim
 */
public final class Webim {
    
    /**
     Returns new SessionBuilder object for creating WebimSession object.
     - returns:
     The instance of WebimSession builder.
     - author:
     Nikita Lazarev-Zubov
     - copyright:
     2017 Webim
     */
    static public func newSessionBuilder() -> SessionBuilder {
        return SessionBuilder()
    }
    
    /**
     Deserializes received remote notification.
     This method can be called with `userInfo` parameter of your UIApplicationDelegate method `application(_:didReceiveRemoteNotification:)`.
     Remote notification dictionary must be stored inside standard APNs key "aps".
     - parameter remoteNotification:
     User info of received remote notification.
     - returns:
     Remote notification object or nil if there's no useful payload or this notification is sent not by Webim service.
     - seealso:
     `SessionBuilder.set(remoteNotificationsSystem:)`
     `isWebim(remoteNotification:)`
     - author:
     Nikita Lazarev-Zubov
     - copyright:
     2017 Webim
     */
    static public func parse(remoteNotification: [AnyHashable : Any]) -> WebimRemoteNotification? {
        return InternalUtils.parse(remoteNotification: remoteNotification)
    }
    
    /**
     If remote notifications (SessionBuilder.setRemoteNotificationSystem) are enabled for the session, then you can receive remote notifications belonging to this session.
     This method can be called with `userInfo` parameter of your UIApplicationDelegate method `application(_:didReceiveRemoteNotification:)`.
     Remote notification dictionary must be stored inside standard APNs key "aps".
     - parameter remoteNotification:
     User info of received remote notification.
     - returns:
     Boolean value that indicates is received remote notification is sent by Webim service.
     - seealso:
     `SessionBuilder.set(remoteNotificationSystem:)`
     `parseRemoteNotification()`
     - author:
     Nikita Lazarev-Zubov
     - copyright:
     2017 Webim
     */
    static public func isWebim(remoteNotification: [AnyHashable: Any]) -> Bool {
        return InternalUtils.isWebim(remoteNotification: remoteNotification)
    }
    
    
    // MARK: -
    /**
     - seealso:
     `SessionBuilder.setRemoteNotificationSystem()`
     - author:
     Nikita Lazarev-Zubov
     - copyright:
     2017 Webim
     */
    public enum RemoteNotificationSystem {
        case APNS
        case NONE
    }
    
}

// MARK: -
/**
 `WebimSession` builder.
 - seealso:
 `Webim.newSessionBuilder()`
 - author:
 Nikita Lazarev-Zubov
 - copyright:
 2017 Webim
 */
public final class SessionBuilder  {
    
    // MARK: - Properties
    private var accountName: String?
    private var appVersion: String?
    private var deviceToken: String?
    private weak var fatalErrorHandler: FatalErrorHandler?
    private var localHistoryStoragingEnabled = true
    private var location: String?
    private var pageTitle: String?
    private var providedAuthorizationToken: String?
    private weak var providedAuthorizationTokenStateListener: ProvidedAuthorizationTokenStateListener?
    private var remoteNotificationSystem: Webim.RemoteNotificationSystem = .NONE
    private var visitorDataClearingEnabled = false
    private var visitorFields: ProvidedVisitorFields?
    private weak var webimLogger: WebimLogger?
    private var webimLoggerVerbosityLevel: WebimLoggerVerbosityLevel?
    
    // MARK: - Methods
    
    /**
     Sets company account name in Webim system.
     Usually presented by full domain URL of the server (e.g "https://demo.webim.ru").
     For testing purposes it is possible to use account name "demo".
     - parameter accountName:
     Webim account name.
     - returns:
     `SessionBuilder` object with account name set.
     - author:
     Nikita Lazarev-Zubov
     - copyright:
     2017 Webim
     */
    public func set(accountName: String) -> SessionBuilder {
        self.accountName = accountName
        
        return self
    }
    
    /**
     Location on server.
     You can use "mobile" or contact support for creating new one.
     - parameter location:
     Location name.
     - returns:
     `SessionBuilder` object with location set.
     - seealso:
     https://webim.ru/help/help-terms/#location
     - author:
     Nikita Lazarev-Zubov
     - copyright:
     2017 Webim
     */
    public func set(location: String) -> SessionBuilder {
        self.location = location
        
        return self
    }
    
    /**
     You can differentiate your app versions on server by setting this parameter. E.g. "2.9.11".
     This is optional.
     - parameter appVersion:
     Client app version name.
     - returns:
     `SessionBuilder` object with app version set.
     - author:
     Nikita Lazarev-Zubov
     - copyright:
     2017 Webim
     */
    public func set(appVersion: String?) -> SessionBuilder {
        self.appVersion = appVersion
        
        return self
    }
    
    /**
     A visitor can be anonymous or authorized. Without calling this method when creating a session visitor is anonymous.
     In this case visitor receives a random ID, which is written in `UserDefaults`. If the data is lost (for example when application was reinstalled), the user ID is also lost, as well as the message history.
     Authorizing of a visitor can be useful when there are internal mechanisms of authorization in your application and you want the message history to exist regardless of a device communication occurs from.
     This method takes as a parameter a string containing the signed fields of a user in JSON format. Since the fields are necessary to be signed with a private key that can never be included into the code of a client's application, this string must be created and signed somewhere on your backend side. Read more about forming a string and a signature here: https://webim.ru/help/identification/
     - important:
     Can't be used simultanously with `set(providedAuthorizationTokenStateListener:providedAuthorizationToken:)`.
     - parameter jsonString:
     JSON-string containing the signed fields of a visitor.
     - returns:
     `SessionBuilder` object with visitor fields set.
     - SeeAlso:
     https://webim.ru/help/identification/
     set(visitorFieldsJSONdata:)
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    public func set(visitorFieldsJSONString: String) -> SessionBuilder {
        self.visitorFields = ProvidedVisitorFields(withJSONString: visitorFieldsJSONString)
        
        return self
    }
    
    /**
     A visitor can be anonymous or authorized. Without calling this method when creating a session visitor is anonymous.
     In this case visitor receives a random ID, which is written in `UserDefaults`. If the data is lost (for example when application was reinstalled), the user ID is also lost, as well as the message history.
     Authorizing of a visitor can be useful when there are internal mechanisms of authorization in your application and you want the message history to exist regardless of a device communication occurs from.
     This method takes as a parameter a string containing the signed fields of a user in JSON format. Since the fields are necessary to be signed with a private key that can never be included into the code of a client's application, this string must be created and signed somewhere on your backend side. Read more about forming a string and a signature here: https://webim.ru/help/identification/
     - important:
     Can't be used simultanously with `set(providedAuthorizationTokenStateListener:providedAuthorizationToken:)`.
     - parameter jsonData:
     JSON-data containing the signed fields of a visitor.
     - returns:
     `SessionBuilder` object with visitor fields set.
     - SeeAlso:
     `set(visitorFieldsJSONstring:)`
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    public func set(visitorFieldsJSONData: Data) -> SessionBuilder {
        self.visitorFields = ProvidedVisitorFields(withJSONObject: visitorFieldsJSONData)
        
        return self
    }
    
    /**
     When client provides custom visitor authorization mechanism, it can be realised by providing custom authorization token which is used instead of visitor fields.
     - important:
     Can't be used simultaneously with `set(visitorFields:)`.
     - parameter providedAuthorizationTokenStateListener:
     `ProvidedAuthorizationTokenStateListener` object.
     - parameter providedAuthorizationToken:
     Optional. Client generated provided authorization token. If it is not passed, library generates its own.
     - seealso:
     `ProvidedAuthorizationTokenStateListener`
     - author:
     Nikita Lazarev-Zubov
     - copyright:
     2017 Webim
     */
    public func set(providedAuthorizationTokenStateListener: ProvidedAuthorizationTokenStateListener?,
                    providedAuthorizationToken: String? = nil) -> SessionBuilder {
        self.providedAuthorizationTokenStateListener = providedAuthorizationTokenStateListener
        self.providedAuthorizationToken = providedAuthorizationToken
        
        return self
    }
    
    /**
     Sets the page title visible to an operator. In the web version of a chat it is a title of a web page a user opens a chat from.
     By default "iOS Client".
     - parameter pageTitle:
     Page title that visible to an operator.
     - returns:
     `SessionBuilder` object with page title set.
     - author:
     Nikita Lazarev-Zubov
     - copyright:
     2017 Webim
     */
    public func set(pageTitle: String?) -> SessionBuilder {
        self.pageTitle = pageTitle
        
        return self
    }
    
    /**
     Sets a fatal error handler. An error is considered fatal if after processing it the session can not be continued anymore.
     - parameter fatalErrorHandler:
     Fatal error handler.
     - returns:
     `SessionBuilder` object with fatal error handler set.
     - author:
     Nikita Lazarev-Zubov
     - copyright:
     2017 Webim
     */
    public func set(fatalErrorHandler: FatalErrorHandler?) -> SessionBuilder {
        self.fatalErrorHandler = fatalErrorHandler
        
        return self
    }
    
    /**
     Webim service can send remote notifications when new messages are received in chat.
     By default it does not. You have to handle receiving by yourself.
     To differentiate notifications from your app and from Webim service check the field "from" (see `Webim.isWebim(remoteNotification:)`).
     - important:
     If remote notification system is set you must set device token.
     - parameter remoteNotificationSystem:
     Enum that indicates which system of remote notification is used. By default – `NONE` (remote notifications are not to be sent).
     - returns:
     `SessionBuilder` object with remote notification system set.
     - author:
     Nikita Lazarev-Zubov
     - copyright:
     2017 Webim
     */
    public func set(remoteNotificationSystem: Webim.RemoteNotificationSystem) -> SessionBuilder {
        self.remoteNotificationSystem = remoteNotificationSystem
        
        return self
    }
    
    /**
     Sets device token.
     Example that shows how to change device token for the proper formatted one:
     `let deviceToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()`
     - parameter deviceToken:
     Device token in hexadecimal format and without any spaces and service symbols.
     - returns:
     `SessionBuilder` object with device token set.
     - seealso:
     `setRemoteNotificationsSystem`
     - author:
     Nikita Lazarev-Zubov
     - copyright:
     2017 Webim
     */
    public func set(deviceToken: String?) -> SessionBuilder {
        self.deviceToken = deviceToken
        
        return self
    }
    
    /**
     By default a session stores a message history locally. This method allows to disable history storage.
     - important:
     Use only for debugging!
     - parameter isLocalHistoryStoragingEnabled:
     Boolean parameter that indicated if an app should enable or disable local history storing.
     - returns:
     `SessionBuilder` object with isLocalHistoryStoragingEnabled parameter set.
     - author:
     Nikita Lazarev-Zubov
     - copyright:
     2017 Webim
     */
    public func set(isLocalHistoryStoragingEnabled: Bool) -> SessionBuilder {
        self.localHistoryStoragingEnabled = isLocalHistoryStoragingEnabled
        
        return self
    }
    
    /**
     If set to true, all the visitor data is cleared before the session starts.
     - important:
     Use only for debugging!
     - parameter isVisitorDataClearingEnabled:
     Boolean parameter that indicated if an app should clear visitor data before session starts.
     - returns:
     `SessionBuilder` object with isVisitorDataClearingEnabled parameter set.
     - author:
     Nikita Lazarev-Zubov
     - copyright:
     2017 Webim
     */
    public func set(isVisitorDataClearingEnabled: Bool) -> SessionBuilder {
        self.visitorDataClearingEnabled = isVisitorDataClearingEnabled
        
        return self
    }
    
    /**
     Method to pass WebimLogger object.
     - parameter webimLogger:
     `WebimLogger` object.
     - returns:
     `SessionBuilder` object with `WebimLogger` object set.
     - seealso:
     `WebimLogger`
     - author:
     Nikita Lazarev-Zubov
     - copyright:
     2017 Webim
     */
    public func set(webimLogger: WebimLogger?,
                    verbosityLevel: WebimLoggerVerbosityLevel = .WARNING) -> SessionBuilder {
        self.webimLogger = webimLogger
        webimLoggerVerbosityLevel = verbosityLevel
        
        return self
    }
    
    /**
     Builds new `WebimSession` object.
     - important:
     All the follow-up work with the session must be implemented from the same thread this method was called in.
     Notice that a session is created as a paused. To start using it the first thing to do is to call `WebimSession.resume()`.
     - returns:
     New `WebimSession` object.
     - throws:
     `SessionBuilder.SessionBuilderError.NIL_ACCOUNT_NAME` if account name wasn't set to a non-nil value.
     `SessionBuilder.SessionBuilderError.NIL_LOCATION` if location wasn't set to a non-nil value.
     `SessionBuilder.SessionBuilderError.INVALID_REMOTE_NOTIFICATION_CONFIGURATION` if there is a try to pass device token with `RemoteNotificationSystem` not set (or set to `.NONE`).
     `SessionBuilder.SessionBuilderError.INVALID_AUTHENTICATION_PARAMETERS` if methods `set(visitorFieldsJSONString:)` or `set(visitorFieldsJSONData:)` are called with `set(providedAuthorizationTokenStateListener:,providedAuthorizationToken:)` simultaneously.
     - seealso:
     `SessionBuilder.SessionBuilderError`
     - author:
     Nikita Lazarev-Zubov
     - copyright:
     2017 Webim
     */
    public func build() throws -> WebimSession {
        guard let accountName = accountName else {
            throw SessionBuilderError.NIL_ACCOUNT_NAME
        }
        guard let location = location else {
            throw SessionBuilderError.NIL_LOCATION
        }
        
        let remoteNotificationsEnabled = (self.remoteNotificationSystem != Webim.RemoteNotificationSystem.NONE)
        if (deviceToken != nil)
            && !remoteNotificationsEnabled {
            throw SessionBuilderError.INVALID_REMOTE_NOTIFICATION_CONFIGURATION
        }
        
        if (visitorFields != nil)
            && (providedAuthorizationTokenStateListener != nil) {
            throw SessionBuilderError.INVALID_AUTHENTICATION_PARAMETERS
        }
        
        providedAuthorizationTokenStateListener?.update(providedAuthorizationToken: (providedAuthorizationToken ?? ClientSideID.generateClientSideID()))
        
        return WebimSessionImpl.newInstanceWith(accountName: accountName,
                                                location: location,
                                                appVersion: appVersion,
                                                visitorFields: visitorFields,
                                                providedAuthorizationTokenStateListener: providedAuthorizationTokenStateListener,
                                                providedAuthorizationToken: providedAuthorizationToken,
                                                pageTitle: pageTitle,
                                                fatalErrorHandler: fatalErrorHandler,
                                                deviceToken: deviceToken,
                                                isLocalHistoryStoragingEnabled: localHistoryStoragingEnabled,
                                                isVisitorDataClearingEnabled: visitorDataClearingEnabled,
                                                webimLogger: webimLogger,
                                                verbosityLevel: webimLoggerVerbosityLevel) as WebimSession
    }
    
    // MARK: -
    /**
     Verbosity level of `WebimLogger`.
     - seealso:
     `SessionBuilder.set(webimLogger:verbosityLevel:)`
     - author:
     Nikita Lazarev-Zubov
     - copyright:
     2018 Webim
     */
    public enum WebimLoggerVerbosityLevel {
        
        /**
         All available information will be delivered to `WebimLogger` instance with maximum verbosity level:
         * session network setup parameters;
         * network requests' URLs, HTTP method and parameters;
         * network responses' HTTP codes, received data and errors;
         * SQL queries and errors;
         * full debug information and additional notes.
         - author:
         Nikita Lazarev-Zubov
         - copyright:
         2018 Webim
         */
        case VERBOSE
        
        /**
         All information which is useful when debugging will be delivered to `WebimLogger` instance with necessary verbosity level:
         * session network setup parameters;
         * network requests' URLs, HTTP method and parameters;
         * network responses' HTTP codes, received data and errors;
         * SQL queries and errors;
         * moderate debug information.
         - author:
         Nikita Lazarev-Zubov
         - copyright:
         2018 Webim
         */
        case DEBUG
        
        /**
         Reference information and all warnings and errors will be delivered to `WebimLogger` instance:
         * network requests' URLS, HTTP method and parameters;
         * HTTP codes and errors descriptions of failed requests.
         * SQL errors.
         - author:
         Nikita Lazarev-Zubov
         - copyright:
         2018 Webim
         */
        case INFO
        
        /**
         Errors and warnings only will be delivered to `WebimLogger` instance:
         * network requests' URLs, HTTP method, parameters, HTTP code and error description.
         * SQL errors.
         - author:
         Nikita Lazarev-Zubov
         - copyright:
         2018 Webim
         */
        case WARNING
        
        /**
         Only errors will be delivered to `WebimLogger` instance:
         * network requests' URLs, HTTP method, parameters, HTTP code and error description.
         - author:
         Nikita Lazarev-Zubov
         - copyright:
         2018 Webim
         */
        case ERROR
        
    }
    
    /**
     Error types that can be thrown by `SessionBuilder` `build()` method.
     - seealso:
     `SessionBuilder.build()`
     - author:
     Nikita Lazarev-Zubov
     - copyright:
     2017 Webim
     */
    public enum SessionBuilderError: Error {
        
        /**
         Error that is thrown when trying to use standard and custom visitor fields authentication simultaneously.
         - seealso:
         `set(visitorFieldsJSONString:)`
         `set(visitorFieldsJSONData:)`
         `set(providedAuthorizationTokenStateListener:providedAuthorizationToken:)`
         - author:
         Nikita Lazarev-Zubov
         - copyright:
         2017 Webim
         */
        case INVALID_AUTHENTICATION_PARAMETERS
        
        /**
         Error that is thrown when trying to create session object with invalid remote notifications configuration.
         - seealso:
         `set(remoteNotificationSystem:)`
         `set(deviceToken:)`
         - author:
         Nikita Lazarev-Zubov
         - copyright:
         2017 Webim
         */
        case INVALID_REMOTE_NOTIFICATION_CONFIGURATION
        
        /**
         Error that is thrown when trying to create session object with `nil` account name.
         - seealso:
         `set(accountName:)`
         - author:
         Nikita Lazarev-Zubov
         - copyright:
         2017 Webim
         */
        case NIL_ACCOUNT_NAME
        
        /**
         Error that is thrown when trying to create session object with `nil` location name.
         - seealso:
         `set(location:)`
         - author:
         Nikita Lazarev-Zubov
         - copyright:
         2017 Webim
         */
        case NIL_LOCATION
        
    }
    
}
