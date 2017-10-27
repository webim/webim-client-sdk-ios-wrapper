//
//  Webim.swift
//  WebimClientLibrary
//
//  Created by Nikita Lazarev-Zubov on 02.08.17.
//  Copyright © 2017 Webim. All rights reserved.
//

import Foundation


public final class Webim {
    
    /**
     - returns:
     The instance of WebimSession builder.
     */
    static public func newSessionBuilder() -> SessionBuilder {
        return SessionBuilder()
    }
    
    /**
     Deserializes received remote notification.
     This method can be called with `userInfo` parameter of your UIApplicationDelegate method `application(_:,didReceiveRemoteNotification:)`.
     - parameter pushNotification:
     User info of received remote notification.
     - returns:
     Push notification object or nil if there's no useful payload or this notification is sent not by Webim service.
     - throws:
     `PushNotificationError.UnknownNotificationFormat` if passed remote notification format is incorrect or unknown. Remote notification dictionary must be stored inside standard APNs key "aps".
     - SeeAlso:
     `SessionBuilder.set(pushNotificationsSystem:)`
     `isWebim(pushNotification:)`
     */
    static public func parse(remoteNotification: [AnyHashable: Any]) throws -> WebimPushNotification? {
        return try InternalUtils.parse(remoteNotification: remoteNotification)
    }
    
    /**
     If push notifications (SessionBuilder.setPushSystem) are enabled for the session, then you can receive push notifications belonging to this session.
     This method can be called with `userInfo` parameter of your UIApplicationDelegate method `application(_:,didReceiveRemoteNotification:)`.
     - parameter pushNotification:
     User info of received remote notification.
     - returns:
     Boolean value that indicates is received remote notification is sent by Webim service.
     - throws:
     `PushNotificationError.UnknownNotificationFormat` if passed remote notification format is incorrect or unknown. Remote notification dictionary must be stored inside standard APNs key "aps".
     - SeeAlso:
     `SessionBuilder.set(pushNotificationSystem:)`
     `parsePushNotification()`
     */
    static public func isWebim(remoteNotification: [AnyHashable : Any]) throws -> Bool {
        return try InternalUtils.isWebim(remoteNotification: remoteNotification)
    }
    
    // MARK: -
    /**
     - SeeAlso:
     `SessionBuilder.setPushSystem()`
     */
    public enum PushNotificationSystem {
        case APNS
        case NONE
    }
    
    // MARK: -
    /**
     - SeeAlso:
     `isWebim(pushNotification:)`
     */
    public enum PushNotificationError: Error {
        case UnknownNotificationFormat
    }
    
}


// MARK: -
/**
 `WebimSession` builder.
 - SeeAlso:
 `Webim.newSessionBuilder()`
 */
public final class SessionBuilder  {
    
    // MARK: - Properties
    
    private var accountName: String?
    private var appVersion: String?
    private var deviceToken: String?
    private var fatalErrorHandler: FatalErrorHandler?
    private var location: String?
    private var pageTitle: String?
    private var pushNotificationSystem: Webim.PushNotificationSystem? = .NONE
    private var visitorFields: ProvidedVisitorFields?
    
    // Properties used for debugging
    private var localHistoryStoragingEnabled: Bool = true
    private var visitorDataClearingEnabled: Bool?
    
    
    // MARK: - Builder methods
    
    /**
     Sets company account name in Webim system.
     Usually presented by full domain URL of the server (e.g "https://demo.webim.ru").
     For testing purposes it is possible to use account name "demo".
     - parameter accountName:
     Webim account name.
     - returns:
     `SessionBuilder` object with account name setted.
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
     `SessionBuilder` object with location setted.
     - SeeAlso:
     https://webim.ru/help/help-terms/#location
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
     `SessionBuilder` object with app version setted.
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
     - parameter jsonString:
     JSON-string containing the signed fields of a visitor.
     - returns:
     `SessionBuilder` object with visitor fields setted.
     - SeeAlso:
     https://webim.ru/help/identification/
     set(visitorFieldsJSON jsonData:)
     */
    public func set(visitorFieldsJSONString jsonString: String) -> SessionBuilder {
        self.visitorFields = ProvidedVisitorFields(withJSONString: jsonString)
        return self
    }
    
    /**
     A visitor can be anonymous or authorized. Without calling this method when creating a session visitor is anonymous.
     In this case visitor receives a random ID, which is written in `UserDefaults`. If the data is lost (for example when application was reinstalled), the user ID is also lost, as well as the message history.
     Authorizing of a visitor can be useful when there are internal mechanisms of authorization in your application and you want the message history to exist regardless of a device communication occurs from.
     This method takes as a parameter a string containing the signed fields of a user in JSON format. Since the fields are necessary to be signed with a private key that can never be included into the code of a client's application, this string must be created and signed somewhere on your backend side. Read more about forming a string and a signature here: https://webim.ru/help/identification/
     - parameter jsonData:
     JSON-data containing the signed fields of a visitor.
     - returns:
     `SessionBuilder` object with visitor fields setted.
     - SeeAlso:
     https://webim.ru/help/identification/
     `set(visitorFieldsJSON jsonString:)`
     */
    public func set(visitorFieldsJSONData jsonData: Data) -> SessionBuilder {
        self.visitorFields = ProvidedVisitorFields(withJSONObject: jsonData)
        return self
    }
    
    /**
     Sets the page title visible to an operator. In the web version of a chat it is a title of a web page a user opens a chat from.
     By default "iOS Client".
     - parameter pageTitle:
     Page title that visible to an operator.
     - returns:
     `SessionBuilder` object with page title setted.
     */
    public func set(pageTitle: String) -> SessionBuilder {
        self.pageTitle = pageTitle
        return self
    }
    
    /**
     Sets a fatal error handler. An error is considered fatal if after processing it the session can not be continued anymore.
     - parameter fatalErrorHandler:
     Fatal error handler.
     - returns:
     `SessionBuilder` object with fatal error handler setted.
     */
    public func set(fatalErrorHandler: FatalErrorHandler?) -> SessionBuilder {
        self.fatalErrorHandler = fatalErrorHandler
        return self
    }
    
    /**
     Webim service can send push notifications when new messages are received in chat.
     By default it does not. You have to handle receiving by yourself.
     To differentiate notifications from your app and from Webim service check the field "from" (see `Webim.isWebim(pushNotification:)`).
     - important:
     If push notification system is setted you must set device token.
     - parameter pushNotificationSystem:
     Enum that indicates which system of push notification is used. By default – NONE (push notifications are not sent).
     - returns:
     `SessionBuilder` object with push notification system setted.
     */
    public func set(pushNotificationSystem: Webim.PushNotificationSystem) -> SessionBuilder {
        self.pushNotificationSystem = pushNotificationSystem
        return self
    }
    
    /**
     Sets device token.
     - parameter deviceToken:
     Push token.
     - returns:
     `SessionBuilder` object with device token setted.
     - SeeAlso:
     `setPushSystem`
     */
    public func set(deviceToken: String?) -> SessionBuilder {
        self.deviceToken = deviceToken
        return self
    }
    
    // MARK: Debugging methods
    
    /**
     By default a session stores a message history locally. This method allows to disable history storage.
     - important:
     Use only for debugging!
     - parameter localHistoryStorageEnabled:
     Boolean parameter that indicated if an app should enable or disable local history storing.
     - returns:
     `SessionBuilder` object with isLocalHistoryStoragingEnabled parameter setted.
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
     `SessionBuilder` object with isVisitorDataClearingEnabled parameter setted.
     */
    public func set(isVisitorDataClearingEnabled: Bool) -> SessionBuilder {
        self.visitorDataClearingEnabled = isVisitorDataClearingEnabled
        return self
    }
    
    
    /**
     Builds new `WebimSession` object.
     - important:
     All the follow-up work with the session must be implemented from the same thread this method was called in.
     Notice that a session is created as a paused. To start using it the first thing to do is to call `WebimSession.resume()`.
     - throws:
     `SessionBuilderError.NIL_ACCOUNT_NAME` if account name wasn't setted to a non-nil value.
     `SessionBuilderError.NIL_LOCATION` if location wasn't setted to a non-nil value.
     `SessionBuilderError.INVALID_PUSH_NOTIFICATION_CONFIGURATION` if there is a try to set up a push notifications without device token provided.
     - returns:
     New `WebimSession` object.
     */
    public func build() throws -> WebimSession {
        guard self.accountName != nil else {
            throw SessionBuilderError.NIL_ACCOUNT_NAME
        }
        
        guard self.location != nil else {
            throw SessionBuilderError.NIL_LOCATION
        }
        
        let arePushNotificationsEnabled = (self.pushNotificationSystem != Webim.PushNotificationSystem.NONE)
        if arePushNotificationsEnabled {
            guard self.deviceToken != nil else {
                throw SessionBuilderError.INVALID_PUSH_NOTIFICATION_CONFIGURATION
            }
        }
        
        return try WebimSessionImpl.newInstanceWith(accountName: accountName!,
                                                    location: location!,
                                                    appVersion: appVersion,
                                                    visitorFields: visitorFields,
                                                    pageTitle: pageTitle,
                                                    fatalErrorHandler: fatalErrorHandler,
                                                    arePushNotificationsEnabled: arePushNotificationsEnabled,
                                                    deviceToken: deviceToken,
                                                    isLocalHistoryStoragingEnabled: localHistoryStoragingEnabled,
                                                    isVisitorDataClearingEnabled: visitorDataClearingEnabled)! as WebimSession
    }
    
    
    // MARK: -
    public enum SessionBuilderError: Error {
        case NIL_ACCOUNT_NAME
        case NIL_LOCATION
        case INVALID_PUSH_NOTIFICATION_CONFIGURATION
    }
    
}
