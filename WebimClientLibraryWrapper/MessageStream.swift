//
//  MessageStream.swift
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


// MARK: - MessageStream
@objc(MessageStream)
final class _ObjCMessageStream: NSObject {
    
    // MARK: - Properties
    private (set) var messageStream: MessageStream
    
    
    // MARK: - Initialization
    init(messageStream: MessageStream) {
        self.messageStream = messageStream
    }
    
    
    // MARK: - Methods
    
    @objc(getVisitSessionState)
    func getVisitSessionState() -> _ObjCVisitSessionState {
        switch messageStream.getVisitSessionState() {
        case .CHAT:
            return .CHAT
        case .DEPARTMENT_SELECTION:
            return .DEPARTMENT_SELECTION
        case .IDLE:
            return .IDLE
        case .IDLE_AFTER_CHAT:
            return .IDLE_AFTER_CHAT
        case .OFFLINE_MESSAGE:
            return .OFFLINE_MESSAGE
        case .UNKNOWN:
            return .UNKNOWN
        }
    }
    
    @objc(getChatState)
    func getChatState() -> _ObjCChatState {
        switch messageStream.getChatState() {
        case .CHATTING:
            return .CHATTING
        case .CLOSED_BY_OPERATOR:
            return .CLOSED_BY_OPERATOR
        case .CLOSED_BY_VISITOR:
            return .CLOSED_BY_VISITOR
        case .INVITATION:
            return .INVITATION
        case .NONE:
            return .NONE
        case .QUEUE:
            return .QUEUE
        default:
            return .UNKNOWN
        }
    }
    
    @objc(getUnreadByOperatorTimestamp)
    func getUnreadByOperatorTimestamp() -> Date? {
        return messageStream.getUnreadByOperatorTimestamp()
    }
    
    @objc(getUnreadByVisitorTimestamp)
    func getUnreadByVisitorTimestamp() -> Date? {
        return messageStream.getUnreadByVisitorTimestamp()
    }
    
    @objc(getDepartmentList)
    func getDepartmentList() -> [_ObjCDepartment]? {
        if let departmentList = messageStream.getDepartmentList() {
            var objCDepartmentList = [_ObjCDepartment]()
            for department in departmentList {
                let objCDepartment = _ObjCDepartment(department: department)
                objCDepartmentList.append(objCDepartment)
            }
            
            return objCDepartmentList
        }
        
        return nil
    }
    
    @objc(getLocationSettings)
    func getLocationSettings() -> _ObjCLocationSettings {
        return _ObjCLocationSettings(locationSettings: messageStream.getLocationSettings())
    }
    
    @objc(getCurrentOperator)
    func getCurrentOperator() -> _ObjCOperator? {
        if let `operator` = messageStream.getCurrentOperator() {
            return _ObjCOperator(operator: `operator`)
        }
        
        return nil
    }
    
    @objc(getLastRatingOfOperatorWithID:)
    func getLastRatingOfOperatorWith(id: String) -> Int {
        return messageStream.getLastRatingOfOperatorWith(id: id)
    }
    
    @objc(rateOperatorWithID:byRating:completionHandler:error:)
    func rateOperatorWith(id: String,
                          byRating rating: Int,
                          completionHandler: _ObjCRateOperatorCompletionHandler) throws {
        try messageStream.rateOperatorWith(id: id,
                                           byRating: rating,
                                           comletionHandler: RateOperatorCompletionHandlerWrapper(rateOperatorCompletionHandler: completionHandler))
    }
    
    @objc(startChat:)
    func startChat() throws {
        try messageStream.startChat()
    }
    
    @objc(startChatWithDepartmentKey:error:)
    func startChat(departmentKey: String?) throws {
        try messageStream.startChat(departmentKey: departmentKey)
    }
    
    @objc(startChatWithFirstQuestion:error:)
    func startChat(firstQuestion: String?) throws {
        try messageStream.startChat(firstQuestion: firstQuestion)
    }
    
    @objc(startChatWithDepartmentKey:firstQuestion:error:)
    func startChat(departmentKey: String?,
                   firstQuestion: String?) throws {
        try messageStream.startChat(departmentKey: departmentKey,
                                    firstQuestion: firstQuestion)
    }
    
    @objc(closeChat:)
    func closeChat() throws {
        try messageStream.closeChat()
    }
    
    @objc(setVisitorTypingDraftMessage:error:)
    func setVisitorTyping(draftMessage: String?) throws {
        try messageStream.setVisitorTyping(draftMessage: draftMessage)
    }
    
    @objc(sendMessage:error:)
    func send(message: String) throws -> String {
        return try messageStream.send(message: message)
    }
    
    @objc(sendMessage:data:error:)
    func send(message: String,
              data: [String: Any]?) throws -> String {
        return try messageStream.send(message: message,
                                      data: data)
    }
    
    @objc(sendMessage:isHintQuestion:error:)
    func send(message: String,
              isHintQuestion: Bool) throws -> String {
        return try messageStream.send(message: message,
                                      isHintQuestion: isHintQuestion)
    }
    
    @objc(sendFile:filename:mimeType:completionHandler:error:)
    func send(file: Data,
              filename: String,
              mimeType: String,
              completionHandler: _ObjCSendFileCompletionHandler?) throws -> String {
        return try messageStream.send(file: file,
                                      filename: filename,
                                      mimeType: mimeType,
                                      completionHandler: ((completionHandler == nil) ? nil : SendFileCompletionHandlerWrapper(sendFileCompletionHandler: completionHandler!)))
    }
    
    @objc(newMessageTrackerWithMessageListener:error:)
    func new(messageTracker messageListener: _ObjCMessageListener) throws -> _ObjCMessageTracker {
        return try _ObjCMessageTracker(messageTracker: messageStream.new(messageTracker: MessageListenerWrapper(messageListener: messageListener)))
    }
    
    @objc(setVisitSessionStateListener:)
    func set(visitSessionStateListener: _ObjCVisitSessionStateListener) {
        messageStream.set(visitSessionStateListener: VisitSessionStateListenerWrapper(visitSessionStateListener: visitSessionStateListener))
    }
    
    @objc(setChatStateListener:)
    func set(chatStateListener: _ObjCChatStateListener) {
        messageStream.set(chatStateListener: ChatStateListenerWrapper(chatStateListener: chatStateListener))
    }
    
    @objc(setCurrentOperatorChangeListener:)
    func set(currentOperatorChangeListener: _ObjCCurrentOperatorChangeListener) {
        messageStream.set(currentOperatorChangeListener: CurrentOperatorChangeListenerWrapper(currentOperatorChangeListener: currentOperatorChangeListener))
    }
    
    @objc(setDepartmentListChangeListener:)
    func set(departmentListChangeListener: _ObjCDepartmentListChangeListener) {
        messageStream.set(departmentListChangeListener: DepartmentListChangeListenerWrapper(departmentListChangeListener: departmentListChangeListener))
    }
    
    @objc(LocationSettingsChangeListener:)
    func set(locationSettingsChangeListener: _ObjCLocationSettingsChangeListener) {
        messageStream.set(locationSettingsChangeListener: LocationSettingsChangeListenerWrapper(locationSettingsChangeListener: locationSettingsChangeListener))
    }
    
    @objc(setOperatorTypingListener:)
    func set(operatorTypingListener: _ObjCOperatorTypingListener) {
        messageStream.set(operatorTypingListener: OperatorTypingListenerWrapper(operatorTypingListener: operatorTypingListener))
    }
    
    @objc(setOnlineStatusChangeListener:)
    func set(onlineStatusChangeListener: _ObjCOnlineStatusChangeListener) {
        messageStream.set(onlineStatusChangeListener: OnlineStatusChangeListenerWrapper(onlineStatusChangeListener: onlineStatusChangeListener))
    }
    
}

// MARK: - LocationSettings
@objc(LocationSettings)
final class _ObjCLocationSettings: NSObject {
    
    // MARK: - Properties
    private (set) var locationSettings: LocationSettings
    
    // MARK: - Initialization
    init(locationSettings: LocationSettings) {
        self.locationSettings = locationSettings
    }
    
    // MARK: - Methods
    @objc(areHintsEnabled)
    func areHintsEnabled() -> Bool {
        return locationSettings.areHintsEnabled()
    }
    
}


// MARK: - SendFileCompletionHandler
@objc(SendFileCompletionHandler)
protocol _ObjCSendFileCompletionHandler {
    
    @objc(onSuccessWithMessageID:)
    func onSuccess(messageID: String)
    
    @objc(OnFailureWithMessageID:error:)
    func onFailure(messageID: String,
                   error: _ObjCSendFileError)
    
}

// MARK: - RateOperatorCompletionHandler
@objc(RateOperatorCompletionHandler)
protocol _ObjCRateOperatorCompletionHandler {
    
    @objc(onSuccess)
    func onSuccess()
    
    @objc(onFailure:)
    func onFailure(error: _ObjCRateOperatorError)
    
}

// MARK: - VisitSessionStateListener
@objc(VisitSessionStateListener)
protocol _ObjCVisitSessionStateListener {
    
    @objc(changedState:to:)
    func changed(state previousState: _ObjCVisitSessionState,
                 to newState: _ObjCVisitSessionState)
    
}

// MARK: - ChatStateListener
@objc(ChatStateListener)
protocol _ObjCChatStateListener {
    
    @objc(changedState:to:)
    func changed(state previousState: _ObjCChatState,
                 to newState: _ObjCChatState)
    
}

// MARK: - CurrentOperatorChangeListener
@objc(CurrentOperatorChangeListener)
protocol _ObjCCurrentOperatorChangeListener {
    
    @objc(changedOperator:to:)
    func changed(operator previousOperator: _ObjCOperator,
                 to newOperator: _ObjCOperator?)
    
}

// MARK: - DepartmentListChangeListener
@objc(DepartmentListChangeListener)
protocol _ObjCDepartmentListChangeListener {
    
    @objc(receivedDepartmentList:)
    func received(departmentList: [_ObjCDepartment])
    
}

// MARK: - LocationSettingsChangeListener
@objc(LocationSettingsChangeListener)
protocol _ObjCLocationSettingsChangeListener {
    
    @objc(changedLocationSettings:to:)
    func changed(locationSettings previousLocationSettings: _ObjCLocationSettings,
                 to newLocationSettings: _ObjCLocationSettings)
    
}

// MARK: - OperatorTypingListener
@objc(OperatorTypingListener)
protocol _ObjCOperatorTypingListener {
    
    @objc(onOperatorTypingStateChangedTo:)
    func onOperatorTypingStateChanged(isTyping: Bool)
    
}

// MARK: - OnlineStatusChangeListener
@objc(SessionOnlineStatusChangeListener)
protocol _ObjCOnlineStatusChangeListener {
    
    @objc(changedOnlineStatus:to:)
    func changed(onlineStatus previousOnlineStatus: _ObjCOnlineStatus,
                 to newOnlineStatus: _ObjCOnlineStatus)
    
}


// MARK: - ChatState
@objc(ChatState)
enum _ObjCChatState: Int {
    case CHATTING
    case CLOSED_BY_OPERATOR
    case CLOSED_BY_VISITOR
    case INVITATION
    case NONE
    case QUEUE
    case UNKNOWN
}

// MARK: - OnlineStatus
@objc(OnlineStatus)
enum _ObjCOnlineStatus: Int {
    case BUSY_OFFLINE
    case BUSY_ONLINE
    case OFFLINE
    case ONLINE
    case UNKNOWN
}

// MARK: - VisitSessionState
@objc(VisitSessionState)
enum _ObjCVisitSessionState: Int {
    case CHAT
    case DEPARTMENT_SELECTION
    case IDLE
    case IDLE_AFTER_CHAT
    case OFFLINE_MESSAGE
    case UNKNOWN
}

// MARK: - SendFileError
@objc(SendFileError)
enum _ObjCSendFileError: Int, Error {
    case FILE_SIZE_EXCEEDED
    case FILE_TYPE_NOT_ALLOWED
}

// MARK: - RateOperatorError
@objc(RateOperatorError)
enum _ObjCRateOperatorError: Int, Error {
    case NO_CHAT
    case WRONG_OPERATOR_ID
}


// MARK: - Protocols' wrappers

// MARK: - SendFileCompletionHandler
fileprivate final class SendFileCompletionHandlerWrapper: SendFileCompletionHandler {
    
    // MARK: - Properties
    private (set) var sendFileCompletionHandler: _ObjCSendFileCompletionHandler
    
    
    // MARK: - Initialization
    init(sendFileCompletionHandler: _ObjCSendFileCompletionHandler) {
        self.sendFileCompletionHandler = sendFileCompletionHandler
    }
    
    
    // MARK: - Methods
    // MARK: SendFileCompletionHandler protocol methods
    
    func onSuccess(messageID: String) {
        sendFileCompletionHandler.onSuccess(messageID: messageID)
    }
    
    func onFailure(messageID: String,
                   error: SendFileError) {
        var objCError: _ObjCSendFileError?
        switch error {
        case .FILE_SIZE_EXCEEDED:
            objCError = .FILE_SIZE_EXCEEDED
        case .FILE_TYPE_NOT_ALLOWED:
            objCError = .FILE_TYPE_NOT_ALLOWED
        }
        
        sendFileCompletionHandler.onFailure(messageID: messageID,
                                            error: objCError!)
    }
    
}

// MARK: - RateOperatorCompletionHandler
fileprivate final class RateOperatorCompletionHandlerWrapper: RateOperatorCompletionHandler {
    
    // MARK: - Properties
    private (set) var rateOperatorCompletionHandler: _ObjCRateOperatorCompletionHandler
    
    
    // MARK: - Initialization
    init(rateOperatorCompletionHandler: _ObjCRateOperatorCompletionHandler) {
        self.rateOperatorCompletionHandler = rateOperatorCompletionHandler
    }
    
    
    // MARK: - Methods
    // MARK: RateOperatorCompletionHandler protocol methods
    
    func onSuccess() {
        rateOperatorCompletionHandler.onSuccess()
    }
    
    func onFailure(error: RateOperatorError) {
        var objCError: _ObjCRateOperatorError?
        switch error {
        case .NO_CHAT:
            objCError = .NO_CHAT
        case .WRONG_OPERATOR_ID:
            objCError = .WRONG_OPERATOR_ID
        }
        
        rateOperatorCompletionHandler.onFailure(error: objCError!)
    }
    
}

// MARK: - VisitSessionStateListener
fileprivate final class VisitSessionStateListenerWrapper: VisitSessionStateListener {
    
    // MARK: - Properties
    private (set) var visitSessionStateListener: _ObjCVisitSessionStateListener
    
    // MARK: - Initialization
    init(visitSessionStateListener: _ObjCVisitSessionStateListener) {
        self.visitSessionStateListener = visitSessionStateListener
    }
    
    // MARK: - Methods
    // MARK: VisitSessionStateListener protocol methods
    func changed(state previousState: VisitSessionState,
                 to newState: VisitSessionState) {
        var previousObjCVisitSessionState: _ObjCVisitSessionState?
        switch previousState {
        case .CHAT:
            previousObjCVisitSessionState = .CHAT
        case .DEPARTMENT_SELECTION:
            previousObjCVisitSessionState = .DEPARTMENT_SELECTION
        case .IDLE:
            previousObjCVisitSessionState = .IDLE
        case .IDLE_AFTER_CHAT:
            previousObjCVisitSessionState = .IDLE_AFTER_CHAT
        case .OFFLINE_MESSAGE:
            previousObjCVisitSessionState = .OFFLINE_MESSAGE
        case .UNKNOWN:
            previousObjCVisitSessionState = .UNKNOWN
        }
        
        var newObjCVisitSessionState: _ObjCVisitSessionState?
        switch previousState {
        case .CHAT:
            newObjCVisitSessionState = .CHAT
        case .DEPARTMENT_SELECTION:
            newObjCVisitSessionState = .DEPARTMENT_SELECTION
        case .IDLE:
            newObjCVisitSessionState = .IDLE
        case .IDLE_AFTER_CHAT:
            newObjCVisitSessionState = .IDLE_AFTER_CHAT
        case .OFFLINE_MESSAGE:
            newObjCVisitSessionState = .OFFLINE_MESSAGE
        case .UNKNOWN:
            newObjCVisitSessionState = .UNKNOWN
        }
        
        visitSessionStateListener.changed(state: previousObjCVisitSessionState!,
                                          to: newObjCVisitSessionState!)
    }
    
}

// MARK: - ChatStateListener
fileprivate final class ChatStateListenerWrapper: ChatStateListener {
    
    // MARK: - Properties
    private (set) var chatStateListener: _ObjCChatStateListener
    
    // MARK: - Initialization
    init(chatStateListener: _ObjCChatStateListener) {
        self.chatStateListener = chatStateListener
    }
    
    // MARK: - Methods
    // MARK: ChatStateListener protocol methods
    func changed(state previousState: ChatState,
                 to newState: ChatState) {
        var previousObjCChatState: _ObjCChatState?
        switch previousState {
        case .CHATTING:
            previousObjCChatState = .CHATTING
        case .CLOSED_BY_OPERATOR:
            previousObjCChatState = .CLOSED_BY_OPERATOR
        case .CLOSED_BY_VISITOR:
            previousObjCChatState = .CLOSED_BY_VISITOR
        case .INVITATION:
            previousObjCChatState = .INVITATION
        case .NONE:
            previousObjCChatState = .NONE
        case .QUEUE:
            previousObjCChatState = .QUEUE
        case .UNKNOWN:
            previousObjCChatState = .UNKNOWN
        }
        
        var newObjCChatState: _ObjCChatState?
        switch newState {
        case .CHATTING:
            newObjCChatState = .CHATTING
        case .CLOSED_BY_OPERATOR:
            newObjCChatState = .CLOSED_BY_OPERATOR
        case .CLOSED_BY_VISITOR:
            newObjCChatState = .CLOSED_BY_VISITOR
        case .INVITATION:
            newObjCChatState = .INVITATION
        case .NONE:
            newObjCChatState = .NONE
        case .QUEUE:
            newObjCChatState = .QUEUE
        case .UNKNOWN:
            newObjCChatState = .UNKNOWN
        }
        
        chatStateListener.changed(state: previousObjCChatState!,
                                  to: newObjCChatState!)
    }
    
}

// MARK: - CurrentOperatorChangeListener
fileprivate final class CurrentOperatorChangeListenerWrapper: CurrentOperatorChangeListener {
    
    // MARK: - Properties
    private (set) var currentOperatorChangeListener: _ObjCCurrentOperatorChangeListener
    
    // MARK: - Initialization
    init(currentOperatorChangeListener: _ObjCCurrentOperatorChangeListener) {
        self.currentOperatorChangeListener = currentOperatorChangeListener
    }
    
    // MARK: - Methods
    // MARK: - CurrentOperatorChangeListener protocol methods
    func changed(operator previousOperator: Operator,
                 to newOperator: Operator?) {
        currentOperatorChangeListener.changed(operator: _ObjCOperator(operator: previousOperator),
                                              to: ((newOperator == nil) ? nil : _ObjCOperator(operator: newOperator!)))
    }
    
}

// MARK: - DepartmentListChangeListener
fileprivate final class DepartmentListChangeListenerWrapper: DepartmentListChangeListener {
    
    // MARK: - Properties
    private (set) var departmentListChangeListener: _ObjCDepartmentListChangeListener
    
    // MARK: - Initialization
    init(departmentListChangeListener: _ObjCDepartmentListChangeListener) {
        self.departmentListChangeListener = departmentListChangeListener
    }
    
    // MARK: - Methods
    // MARK: DepartmentListChangeListener
    func received(departmentList: [Department]) {
        var objCDepartmentList = [_ObjCDepartment]()
        for department in departmentList {
            let objCDepartment = _ObjCDepartment(department: department)
            objCDepartmentList.append(objCDepartment)
        }
        
        departmentListChangeListener.received(departmentList: objCDepartmentList)
    }
    
}

// MARK: - LocationSettingsChangeListener
fileprivate final class LocationSettingsChangeListenerWrapper: LocationSettingsChangeListener {
    
    // MARK: - Properties
    private (set) var locationSettingsChangeListener: _ObjCLocationSettingsChangeListener
    
    // MARK: - Initialization
    init(locationSettingsChangeListener: _ObjCLocationSettingsChangeListener) {
        self.locationSettingsChangeListener = locationSettingsChangeListener
    }
    
    // MARK: - Methods
    // MARK: LocationSettingsChangeListener protocol methods
    func changed(locationSettings previousLocationSettings: LocationSettings,
                 to newLocationSettings: LocationSettings) {
        locationSettingsChangeListener.changed(locationSettings: _ObjCLocationSettings(locationSettings: previousLocationSettings),
                                               to: _ObjCLocationSettings(locationSettings: newLocationSettings))
    }
    
}

// MARK: - OperatorTypingListener
fileprivate final class OperatorTypingListenerWrapper: OperatorTypingListener {
    
    // MARK: - Properties
    private (set) var operatorTypingListener: _ObjCOperatorTypingListener
    
    // MARK: - Initialization
    init(operatorTypingListener: _ObjCOperatorTypingListener) {
        self.operatorTypingListener = operatorTypingListener
    }
    
    // MARK: - Methods
    // MARK: OperatorTypingListener protocol methods
    func onOperatorTypingStateChanged(isTyping: Bool) {
        operatorTypingListener.onOperatorTypingStateChanged(isTyping: isTyping)
    }
    
}

// MARK: - OnlineStatusChangeListener
fileprivate final class OnlineStatusChangeListenerWrapper: OnlineStatusChangeListener {
    
    // MARK: - Properties
    private (set) var onlineStatusChangeListener: _ObjCOnlineStatusChangeListener
    
    // MARK: - Initialization
    init(onlineStatusChangeListener: _ObjCOnlineStatusChangeListener) {
        self.onlineStatusChangeListener = onlineStatusChangeListener
    }
    
    // MARK: - Methods
    // MARK: SessionOnlineStatusChangeListener protocol methods
    func changed(onlineStatus previousOnlineStatus: OnlineStatus,
                 to newOnlineStatus: OnlineStatus) {
        var previousObjCOnlineStatus: _ObjCOnlineStatus?
        switch previousOnlineStatus {
        case .BUSY_OFFLINE:
            previousObjCOnlineStatus = .BUSY_OFFLINE
        case .BUSY_ONLINE:
            previousObjCOnlineStatus = .BUSY_ONLINE
        case .OFFLINE:
            previousObjCOnlineStatus = .OFFLINE
        case .ONLINE:
            previousObjCOnlineStatus = .ONLINE
        case .UNKNOWN:
            previousObjCOnlineStatus = .UNKNOWN
        }
        
        var newObjCOnlineStatus: _ObjCOnlineStatus?
        switch newOnlineStatus {
        case .BUSY_OFFLINE:
            newObjCOnlineStatus = .BUSY_OFFLINE
        case .BUSY_ONLINE:
            newObjCOnlineStatus = .BUSY_ONLINE
        case .OFFLINE:
            newObjCOnlineStatus = .OFFLINE
        case .ONLINE:
            newObjCOnlineStatus = .ONLINE
        case .UNKNOWN:
            newObjCOnlineStatus = .UNKNOWN
        }
        
        onlineStatusChangeListener.changed(onlineStatus: previousObjCOnlineStatus!,
                                           to: newObjCOnlineStatus!)
    }
    
    
}
