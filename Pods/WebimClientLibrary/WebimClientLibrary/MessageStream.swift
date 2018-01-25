//
//  MessageStream.swift
//  WebimClientLibrary
//
//  Created by Nikita Lazarev-Zubov on 07.08.17.
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
 - SeeAlso:
 `WebimSession.getStream()`
 - Author:
 Nikita Lazarev-Zubov
 - Copyright:
 2017 Webim
 */
public protocol MessageStream {
    
    /**
     - SeeAlso:
     `VisitSessionState` type.
     - returns:
     Current session state.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func getVisitSessionState() -> VisitSessionState
    
    /**
     - returns:
     Current chat state.
     - SeeAlso:
     `ChatState` type.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func getChatState() -> ChatState
    
    /**
     - returns:
     Timestamp after which all chat messages are unread by operator (at the moment of last server update recieved.)
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func getUnreadByOperatorTimestamp() -> Date?
    
    /**
     - returns:
     Timestamp after which all chat messages are unread by visitor (at the moment of last server update recieved.)
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func getUnreadByVisitorTimestamp() -> Date?
    
    /**
     - SeeAlso:
     `Department` protocol.
     `DepartmentListChangeListener` protocol.
     - returns:
     List of departments or `nil` if there're any or department list is not received yet.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func getDepartmentList() -> [Department]?
    
    /**
     - returns:
     Current LocationSettings of the MessageStream.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func getLocationSettings() -> LocationSettings
    
    /**
     - returns:
     Operator of the current chat.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func getCurrentOperator() -> Operator?
    
    /**
     - parameter id:
     ID of the operator.
     - returns:
     Previous rating of the operator or 0 if it was not rated before.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func getLastRatingOfOperatorWith(id: String) -> Int
    
    /**
     Rates an operator.
     To get an ID of the current operator call `getCurrentOperator()`.
     - important:
     Requires existing chat.
     - SeeAlso:
     `RateOperatorCompletionHandler` protocol.
     - parameter id:
     ID of the operator to be rated. If passed `nil` current chat operator will be rated.
     - parameter rate:
     A number in range (1...5) that represents an operator rating. If the number is out of range, rating will not be sent to a server.
     - parameter comletionHandler:
     `RateOperatorCompletionHandler` object.
     - throws:
     `AccessError.INVALID_THREAD` if the method was called not from the thread the WebimSession was created in.
     `AccessError.INVALID_SESSION` if WebimSession was destroyed.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func rateOperatorWith(id: String?,
                          byRating rating: Int,
                          comletionHandler: RateOperatorCompletionHandler?) throws
    
    /**
     Changes `ChatState` to `ChatState.QUEUE`.
     Can cause `VisitSessionState.DEPARTMENT_SELECTION` session state. It means that chat must be started by `startChat(departmentKey:)` method.
     - throws:
     `AccessError.INVALID_THREAD` if the method was called not from the thread the WebimSession was created in.
     `AccessError.INVALID_SESSION` if WebimSession was destroyed.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func startChat() throws
    
    /**
     Starts chat and sends first message simultaneously.
     Changes `ChatState` to `ChatState.QUEUE`.
     - parameter firstQuestion:
     First message to send.
     - throws:
     `AccessError.INVALID_THREAD` if the method was called not from the thread the WebimSession was created in.
     `AccessError.INVALID_SESSION` if WebimSession was destroyed.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func startChat(firstQuestion: String?) throws
    
    /**
     Starts chat with particular department.
     Changes `ChatState` to `ChatState.QUEUE`.
     - SeeAlso:
     `Department` protocol.
     - parameter departmentKey:
     Department key (see `getKey()` of `Department` protocol). Calling this method without this parameter passed is the same as `startChat()` method is called.
     - throws:
     `AccessError.INVALID_THREAD` if the method was called not from the thread the WebimSession was created in.
     `AccessError.INVALID_SESSION` if WebimSession was destroyed.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func startChat(departmentKey: String?) throws
    
    /**
     Starts chat with particular department and sends first message simultaneously.
     Changes `ChatState` to `ChatState.QUEUE`.
     - SeeAlso:
     `Department` protocol.
     - parameter departmentKey:
     Department key (see `getKey()` of `Department` protocol). Calling this method without this parameter passed is the same as `startChat()` method is called.
     - parameter firstQuestion:
     First message to send.
     - throws:
     `AccessError.INVALID_THREAD` if the method was called not from the thread the WebimSession was created in.
     `AccessError.INVALID_SESSION` if WebimSession was destroyed.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func startChat(departmentKey: String?,
                   firstQuestion: String?) throws
    
    /**
     Changes `ChatState` to `ChatState.CLOSED_BY_VISITOR`.
     - throws:
     `AccessError.INVALID_THREAD` if the method was called not from the thread the WebimSession was created in.
     `AccessError.INVALID_SESSION` if WebimSession was destroyed.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func closeChat() throws
    
    /**
     This method must be called whenever there is a change of the input field of a message transferring current content of a message as a parameter.
     - parameter draftMessage:
     Current message content.
     - throws:
     `AccessError.INVALID_THREAD` if the method was called not from the thread the WebimSession was created in.
     `AccessError.INVALID_SESSION` if WebimSession was destroyed.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func setVisitorTyping(draftMessage: String?) throws
    
    /**
     Sends a text message.
     When calling this method, if there is an active `MessageTracker` (see newMessageTracker(messageListener:)). `MessageListener.added(message:after:)`) with a message `MessageSendStatus.SENDING` in the status is also called.
     - important:
     Maximum length of message is 32000 characters. Longer messages will be clipped.
     - parameter message:
     Text of the message.
     - returns:
     ID of the message.
     - throws:
     `AccessError.INVALID_THREAD` if the method was called not from the thread the WebimSession was created in.
     `AccessError.INVALID_SESSION` if WebimSession was destroyed.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func send(message: String) throws -> String
    
    /**
     Sends a text message.
     When calling this method, if there is an active `MessageTracker` object (see `newMessageTracker(messageListener:)` method). `MessageListener.added(message:after:)`) with a message `MessageSendStatus.SENDING` in the status is also called.
     - important:
     Maximum length of message is 32000 characters. Longer messages will be clipped.
     - parameter message:
     Text of the message.
     - parameter data:
     Optional. Custom message parameters dictionary. Note that this functionality does not work as is – server version must support it.
     - parameter completionHandler:
     Completion handler that executes when operation is done.
     - returns:
     ID of the message.
     - throws:
     `AccessError.INVALID_THREAD` if the method was called not from the thread the WebimSession was created in.
     `AccessError.INVALID_SESSION` if WebimSession was destroyed.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func send(message: String,
              data: [String: Any]?,
              completionHandler: DataMessageCompletionHandler?) throws -> String
    
    /**
     Sends a text message.
     When calling this method, if there is an active `MessageTracker` object (see `newMessageTracker(messageListener:)` method). `MessageListener.added(message:after:)`) with a message `MessageSendStatus.SENDING` in the status is also called.
     - important:
     Maximum length of message is 32000 characters. Longer messages will be clipped.
     - parameter message:
     Text of the message.
     - parameter isHintQuestion:
     Optional. Shows to server if a visitor chose a hint (true) or wrote his own text (false).
     - returns:
     ID of the message.
     - throws:
     `AccessError.INVALID_THREAD` if the method was called not from the thread the WebimSession was created in.
     `AccessError.INVALID_SESSION` if WebimSession was destroyed.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func send(message: String,
              isHintQuestion: Bool?) throws -> String
    
    /**
     Sends a file message.
     When calling this method, if there is an active `MessageTracker` object (see `newMessageTracker(messageListener:)` method), `MessageListener.added(message:after:)` with a message `MessageSendStatus.SENDING` in the status is also called.
     - SeeAlso:
     Method could fail. See `SendFileError`.
     - parameter path:
     Path of the file to send.
     - parameter mimeType:
     MIME type of the file to send.
     - parameter completionHandler:
     Completion handler that executes when operation is done.
     - returns:
     ID of the message.
     - throws:
     `AccessError.INVALID_THREAD` if the method was called not from the thread the WebimSession was created in.
     `AccessError.INVALID_SESSION` if WebimSession was destroyed.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func send(file: Data,
              filename: String,
              mimeType: String,
              completionHandler: SendFileCompletionHandler?) throws -> String
    
    /**
     `MessageTracker` (via `MessageTracker.getNextMessages(byLimit:completion:)`) allows to request the messages which are above in the history. Each next call `MessageTracker.getNextMessages(byLimit:completion:)` returns earlier messages in relation to the already requested ones.
     Changes of user-visible messages (e.g. ever requested from `MessageTracker`) are transmitted to `MessageListener`. That is why `MessageListener` is needed when creating `MessageTracker`.
     - important:
     For each `MessageStream` at every single moment can exist the only one active `MessageTracker`. When creating a new one at the previous there will be automatically called `MessageTracker.destroy()`.
     - parameter messageListener:
     A listener of message changes in the tracking range.
     - returns:
     A new `MessageTracker` for this stream.
     - throws:
     `AccessError.INVALID_THREAD` if the method was called not from the thread the WebimSession was created in.
     `AccessError.INVALID_SESSION` if WebimSession was destroyed.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func newMessageTracker(messageListener: MessageListener) throws -> MessageTracker
    
    /**
     Sets `VisitSessionStateListener` object.
     - SeeAlso:
     `VisitSessionStateListener` protocol.
     `VisitSessionState` type.
     - parameter visitSessionStateListener:
     `VisitSessionStateListener` object.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func set(visitSessionStateListener: VisitSessionStateListener)
    
    /**
     Sets the `ChatState` change listener.
     - parameter chatStateListener:
     The `ChatState` change listener.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func set(chatStateListener: ChatStateListener)
    
    /**
     Sets the current `Operator` change listener.
     - parameter currentOperatorChangeListener:
     Current `Operator` change listener.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func set(currentOperatorChangeListener: CurrentOperatorChangeListener)
    
    /**
     Sets `DepartmentListChangeListener` object.
     - SeeAlso:
     `DepartmentListChangeListener` protocol.
     `Department` protocol.
     - parameter departmentListChangeListener:
     `DepartmentListChangeListener` object.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func set(departmentListChangeListener: DepartmentListChangeListener)
    
    /**
     Sets the listener of the MessageStream LocationSettings changes.
     - parameter locationSettingsChangeListener:
     The listener of MessageStream LocationSettings changes.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func set(locationSettingsChangeListener: LocationSettingsChangeListener)
    
    /**
     Sets the listener of the "operator typing" status changes.
     - parameter operatorTypingListener:
     The listener of the "operator typing" status changes.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func set(operatorTypingListener: OperatorTypingListener)
    
    /**
     Sets the listener of session status changes.
     - parameter onlineStatusChangeListener:
     `OnlineStatusChangeListener` object.
     - SeeAlso:
     `OnlineStatusChangeListener`
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func set(onlineStatusChangeListener: OnlineStatusChangeListener)
    
}

/**
 Interface that provides methods for handling MessageStream LocationSettings which are received from server.
 - SeeAlso:
 `LocationSettingsChangeListener`
 - Author:
 Nikita Lazarev-Zubov
 - Copyright:
 2017 Webim
 */
public protocol LocationSettings {
    
    /**
     This method shows to an app if it should show hint questions to visitor.
     - returns:
     True if an app should show hint questions to visitor, false otherwise.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func areHintsEnabled() -> Bool
    
}


// MARK: -
/**
 - SeeAlso:
 `MessageStream.send(message:data:completionHandler:)`.
 - Author:
 Nikita Lazarev-Zubov
 - Copyright:
 2018 Webim
 */
public protocol DataMessageCompletionHandler {
    
    /**
     Executed when operation is done successfully.
     - parameter messageID:
     ID of the message.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2018 Webim
     */
    func onSussess(messageID: String)
    
    /**
     Executed when operation is failed.
     - parameter messageID:
     ID of the message.
     - parameter error:
     Error.
     - SeeAlso:
     `DataMessageError`.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2018 Webim
     */
    func onFailure(messageID: String,
                   error: DataMessageError)
    
}

/**
 - SeeAlso:
 `MessageStream.send(file:filename:mimeType:completionHandler:)`
 - Author:
 Nikita Lazarev-Zubov
 - Copyright:
 2017 Webim
 */
public protocol SendFileCompletionHandler {
    
    /**
     Executed when operation is done successfully.
     - parameter messageID:
     ID of the message.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func onSuccess(messageID: String)
    
    /**
     Executed when operation is failed.
     - parameter messageID:
     ID of the message.
     - parameter error:
     Error.
     - SeeAlso:
     `SendFileError`.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func onFailure(messageID: String,
                   error: SendFileError)
    
}

/**
 - SeeAlso:
 `MessageStream.rateOperatorWith(id:byRating:comletionHandler:)`.
 - Author:
 Nikita Lazarev-Zubov
 - Copyright:
 2017 Webim
 */
public protocol RateOperatorCompletionHandler {
    
    /**
     Executed when operation is done successfully.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func onSuccess()
    
    /**
     Executed when operation is failed.
     - parameter error:
     Error.
     - SeeAlso:
     `RateOperatorError`.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func onFailure(error: RateOperatorError)
    
}

/**
 Provides methods to track changes of `VisitSessionState` status.
 - SeeAlso:
 `VisitSessionState` protocol.
 - Author:
 Nikita Lazarev-Zubov
 - Copyright:
 2017 Webim
 */
public protocol VisitSessionStateListener {
    
    /**
     Called when `VisitSessionState` status is changed.
     - parameter previousState:
     Previous value of `VisitSessionState` status.
     - parameter newState:
     New value of `VisitSessionState` status.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func changed(state previousState: VisitSessionState,
                 to newState: VisitSessionState)
    
}

/**
 - SeeAlso:
 `MessageStream.set(chatStateListener:)`
 `MessageStream.getChatState()`
 - Author:
 Nikita Lazarev-Zubov
 - Copyright:
 2017 Webim
 */
public protocol ChatStateListener {
    
    /**
     Called during `ChatState` transition.
     - parameter previousState:
     Previous state.
     - parameter newState:
     New state.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func changed(state previousState: ChatState,
                 to newState: ChatState)
    
}

/**
 - SeeAlso:
 `MessageStream.set(currentOperatorChangeListener:)`
 `MessageStream.getCurrentOperator()`
 - Author:
 Nikita Lazarev-Zubov
 - Copyright:
 2017 Webim
 */
public protocol CurrentOperatorChangeListener {
    
    /**
     Called when `Operator` of the current chat changed.
     - parameter previousOperator:
     Previous operator.
     - parameter newOperator:
     New operator or nil if doesn't exist.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func changed(operator previousOperator: Operator,
                 to newOperator: Operator?)
    
}

/**
 Provides methods to track changes in departments list.
 - SeeAlso:
 `Department` protocol.
 - Author:
 Nikita Lazarev-Zubov
 - Copyright:
 2017 Webim
 */
public protocol DepartmentListChangeListener {
    
    /**
     Called when department list is received.
     - SeeAlso:
     `Department` protocol.
     - parameter departmentList:
     Current department list.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func received(departmentList: [Department])
    
}

/**
 Interface that provides methods for handling changes in LocationSettings.
 - SeeAlso:
 `LocationSettings`
 - Author:
 Nikita Lazarev-Zubov
 - Copyright:
 2017 Webim
 */
public protocol LocationSettingsChangeListener {
    
    /**
     Method called by an app when new LocationSettings object is received.
     - parameter previousLocationSettings:
     Previous LocationSettings state.
     - parameter newLocationSettings:
     New LocationSettings state.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func changed(locationSettings previousLocationSettings: LocationSettings,
                 to newLocationSettings: LocationSettings)
    
}

/**
 - SeeAlso:
 `MessageStream.set(operatorTypingListener:)`
 - Author:
 Nikita Lazarev-Zubov
 - Copyright:
 2017 Webim
 */
public protocol OperatorTypingListener {
    
    /**
     Called when operator typing state changed.
     - parameter isTyping:
     True if operator is typing, false otherwise.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func onOperatorTypingStateChanged(isTyping: Bool)
    
}

/**
 Interface that provides methods for handling changes of session status.
 - SeeAlso:
 `MessageStream.set(onlineStatusChangeListener:)`
 - Author:
 Nikita Lazarev-Zubov
 - Copyright:
 2017 Webim
 */
public protocol OnlineStatusChangeListener {
    
    /**
     Called when new session status is received.
     - SeeAlso:
     `OnlineStatus`
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func changed(onlineStatus previousOnlineStatus: OnlineStatus,
                 to newOnlineStatus: OnlineStatus)
    
}


// MARK: -
/**
 A chat is seen in different ways by an operator depending on ChatState.
 The initial state is `NONE`.
 Then if a visitor sends a message (`MessageStream.send(message:isHintQuestion:)`), the chat changes it's state to `QUEUE`. The chat can be turned into this state by calling `MessageStream.startChat()`.
 After that, if an operator takes the chat to process, the state changes to `CHATTING`. The chat is being in this state until the visitor or the operator closes it.
 When closing a chat by the visitor `MessageStream.closeChat()`, it turns into the state `CLOSED_BY_VISITOR`, by the operator - `CLOSED_BY_OPERATOR`.
 When both the visitor and the operator close the chat, it's state changes to the initial – `NONE`. A chat can also automatically turn into the initial state during long-term absence of activity in it.
 Furthermore, the first message can be sent not only by a visitor but also by an operator. In this case the state will change from the initial to `INVITATION`, and then, after the first message of the visitor, it changes to `CHATTING`.
 - Author:
 Nikita Lazarev-Zubov
 - Copyright:
 2017 Webim
 */
public enum ChatState {
    
    /**
     Means that an operator has taken a chat for processing.
     From this state a chat can be turned into:
     * `CLOSED_BY_OPERATOR`, if an operator closes the chat;
     * `CLOSED_BY_VISITOR`, if a visitor closes the chat (`MessageStream.closeChat()`);
     * `NONE`, automatically during long-term absence of activity.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    case CHATTING
    
    /**
     Means that an operator has closed the chat.
     From this state a chat can be turned into:
     * `NONE`, if the chat is also closed by a visitor (`MessageStream.closeChat()`), or automatically during long-term absence of activity;
     * `QUEUE`, if a visitor sends a new message (`MessageStream.send(message:isHintQuestion:)`).
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    case CLOSED_BY_OPERATOR
    
    /**
     Means that a visitor has closed the chat.
     From this state a chat can be turned into:
     * `NONE`, if the chat is also closed by an operator or automatically during long-term absence of activity;
     * `QUEUE`, if a visitor sends a new message (`MessageStream.send(message:isHintQuestion:)`).
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    case CLOSED_BY_VISITOR
    
    /**
     Means that a chat has been started by an operator and at this moment is waiting for a visitor's response.
     From this state a chat can be turned into:
     * `CHATTING`, if a visitor sends a message (`MessageStream.send(message:isHintQuestion:)`);
     * `NONE`, if an operator or a visitor closes the chat (`MessageStream.closeChat()`).
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    case INVITATION
    
    /**
     Means the absence of a chat as such, e.g. a chat has not been started by a visitor nor by an operator.
     From this state a chat can be turned into:
     * `QUEUE`, if the chat is started by a visitor (by the first message or by calling `MessageStream.startChat()`;
     * `INVITATION`, if the chat is started by an operator.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    case NONE
    
    /**
     Means that a chat has been started by a visitor and at this moment is being in the queue for processing by an operator.
     From this state a chat can be turned into:
     * `CHATTING`, if an operator takes the chat for processing;
     * `NONE`, if a visitor closes the chat (by calling (`MessageStream.closeChat()`) before it is taken for processing;
     * `CLOSED_BY_OPERATOR`, if an operator closes the chat without taking it for processing.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    case QUEUE
    
    /**
     The state is undefined.
     This state is set as the initial when creating a new session, until the first response of the server containing the actual state is got. This state is also used as a fallback if WebimClientLibrary can not identify the server state (e.g. if the server has been updated to a version that contains new states).
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    case UNKNOWN
    
}

/**
 Online state possible cases.
 - SeeAlso:
 `OnlineStatusChangeListener`
 - Author:
 Nikita Lazarev-Zubov
 - Copyright:
 2017 Webim
 */
public enum OnlineStatus {
    
    /**
     Offline state with chats' count limit exceeded.
     Means that visitor is not able to send messages at all.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    case BUSY_OFFLINE
    
    /**
     Online state with chats' count limit exceeded.
     Visitor is able send offline messages, but the server can reject it.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    case BUSY_ONLINE
    
    /**
     Visitor is able to send offline messages.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    case OFFLINE
    
    /**
     Visitor is able to send both online and offline messages.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    case ONLINE
    
    /**
     First status is not recieved yet or status is not supported by this version of the library.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    case UNKNOWN
    
}

/**
 Session possible states.
 - SeeAlso:
 `getVisitSessionState()` method of `MessageStream` protocol.
 `VisitSessionStateListener` protocol.
 - Author:
 Nikita Lazarev-Zubov
 - Copyright:
 2017 Webim
 */
public enum VisitSessionState {
    
    /**
     Chat in progress.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    case CHAT
    
    /**
     Chat must be started with department selected (there was a try to start chat without department selected).
     - SeeAlso:
     `startChat(departmentKey:)` of `MessageStream` protocol.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    case DEPARTMENT_SELECTION
    
    /**
     Session is active but no chat is occuring (chat was not started yet).
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    case IDLE
    
    /**
     Session is active but no chat is occuring (chat was closed recently).
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    case IDLE_AFTER_CHAT
    
    /**
     Offline state.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    case OFFLINE_MESSAGE
    
    /**
     First status is not received yet or status is not supported by this version of the library.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    case UNKNOWN
    
}

/**
 - SeeAlso:
 `DataMessageCompletionHandler.onFailure(messageID:error:)`.
 - Author:
 Nikita Lazarev-Zubov
 - Copyright:
 2018 Webim
 */
public enum DataMessageError: Error {
    
    /**
     Received error is not supported by current WebimClientLibrary version.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2018 Webim
     */
    case UNKNOWN
    
    // MARK: Quoted message errors.
    // Note that quoted message mechanism is not a standard feature – it must be implemented by a server. For more information please contact with Webim support service.
    
    /**
     To be raised when quoted message ID belongs to a message without `canBeReplied` flag set to `true` (this flag is to be set on the server-side).
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2018 Webim
     */
    case QUOTED_MESSAGE_CANNOT_BE_REPLIED
    
    /**
     To be raised when quoted message ID belongs to another visitor's chat.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2018 Webim
     */
    case QUOTED_MESSAGE_FROM_ANOTHER_VISITOR
    
    /**
     To be raised when quoted message ID belongs to multiple messages (server DB error).
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2018 Webim
     */
    case QUOTED_MESSAGE_MULTIPLE_IDS
    
    /**
     To be raised when one or more required arguments of quoting mechanism are missing.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2018 Webim
     */
    case QUOTED_MESSAGE_REQUIRED_ARGUMENTS_MISSING
    
    /**
     To be raised when wrong quoted message ID is sent.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2018 Webim
     */
    case QUOTED_MESSAGE_WRONG_ID
    
}

/**
 - SeeAlso:
 `SendFileCompletionHandler.onFailure(messageID:error:)`
 - Author:
 Nikita Lazarev-Zubov
 - Copyright:
 2017 Webim
 */
public enum SendFileError: Error {
    
    /**
     The server may deny a request if the file size exceeds a limit.
     The maximum size of a file is configured on the server.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    case FILE_SIZE_EXCEEDED
    
    /**
     The server may deny a request if the file type is not allowed.
     The list of allowed file types is configured on the server.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    case FILE_TYPE_NOT_ALLOWED
    
}

/**
 - SeeAlso:
 `RateOperatorCompletionHandler.onFailure(error:)`
 - Author:
 Nikita Lazarev-Zubov
 - Copyright:
 2017 Webim
 */
public enum RateOperatorError: Error {
    
    /**
     Arised when trying to send operator rating request if no chat is exists.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    case NO_CHAT
    
    /**
     Arised when trying to send operator rating request if passed operator ID doesn't belong to existing chat operator (or, in the same place, chat doesn't have an operator at all).
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    case WRONG_OPERATOR_ID
    
}
