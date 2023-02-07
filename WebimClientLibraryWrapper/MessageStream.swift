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
    private let messageStream: MessageStream
    
    private var dataMessageCompletionHandlerWrapper: DataMessageCompletionHandlerWrapper?
    private var rateOperatorCompletionHandlerWrapper: RateOperatorCompletionHandlerWrapper?
    private var sendFileCompletionHandlerWrapper: SendFileCompletionHandlerWrapper?
    private var chatStateListenerWrapper: ChatStateListenerWrapper?
    private var departmentListChangeListenerWrapper: DepartmentListChangeListenerWrapper?
    private var currentOperatorChangeListenerWrapper: CurrentOperatorChangeListenerWrapper?
    private var locationSettingsChangeListenerWrapper: LocationSettingsChangeListenerWrapper?
    private var operatorTypingListenerWrapper: OperatorTypingListenerWrapper?
    private var onlineStatusChangeListenerWrapper: OnlineStatusChangeListenerWrapper?
    private var visitSessionStateListenerWrapper: VisitSessionStateListenerWrapper?
    private var messageListenerWrapper: MessageListenerWrapper?
    private var unreadByOperatorTimestampChangeListenerWrapper: UnreadByOperatorTimestampChangeListenerWrapper?
    private var unreadByVisitorTimestampChangeListenerWrapper: UnreadByVisitorTimestampChangeListenerWrapper?
    private var unreadByVisitorMessageCountChangeListenerWrapper: UnreadByVisitorMessageCountChangeListenerWrapper?
    
    
    // MARK: - Initialization
    init(messageStream: MessageStream) {
        self.messageStream = messageStream
    }
    
    
    // MARK: - Methods
    
    @objc(getVisitSessionState)
    func getVisitSessionState() -> _ObjCVisitSessionState {
        switch messageStream.getVisitSessionState() {
        case .chat:
            return .CHAT
        case .departmentSelection:
            return .DEPARTMENT_SELECTION
        case .idle:
            return .IDLE
        case .idleAfterChat:
            return .IDLE_AFTER_CHAT
        case .offlineMessage:
            return .OFFLINE_MESSAGE
        case .unknown:
            return .UNKNOWN
        }
    }
    
    @objc(getChatState)
    func getChatState() -> _ObjCChatState {
        switch messageStream.getChatState() {
        case .chatting:
            return .CHATTING
        case .chattingWithRobot:
            return .CHATTING_WITH_ROBOT
        case .closedByOperator:
            return .CLOSED_BY_OPERATOR
        case .closedByVisitor:
            return .CLOSED_BY_VISITOR
        case .invitation:
            return .INVITATION
        case .closed:
            return .NONE
        case .queue:
            return .QUEUE
        default:
            return .UNKNOWN
        }
    }
    
    @objc(getChatId)
    func getChatId() -> Int {
        return messageStream.getChatId() ?? -1
    }
    
    @objc(getUnreadByOperatorTimestamp)
    func getUnreadByOperatorTimestamp() -> Date? {
        return messageStream.getUnreadByOperatorTimestamp()
    }
    
    @objc(getUnreadByVisitorTimestamp)
    func getUnreadByVisitorTimestamp() -> Date? {
        return messageStream.getUnreadByVisitorTimestamp()
    }
    
    @objc(getUnreadByVisitorMessageCount)
    func getUnreadByVisitorMessageCount() -> Int {
        return messageStream.getUnreadByVisitorMessageCount()
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
    func rateOperatorWith(id: String?,
                          byRating rating: Int,
                          completionHandler: _ObjCRateOperatorCompletionHandler) throws {
        try messageStream.rateOperatorWith(id: id,
                                           byRating: rating,
                                           completionHandler: RateOperatorCompletionHandlerWrapper(rateOperatorCompletionHandler: completionHandler))
    }
    
    @objc(startChat:)
    func startChat() throws {
        try messageStream.startChat()
    }
    
    @objc(startChatWithDepartmentKey:error:)
    func startChat(departmentKey: String?) throws {
        try messageStream.startChat(departmentKey: departmentKey)
    }
    
    @objc(startChatWithCustomFields:error:)
    func startChat(customFields: String?) throws {
        try messageStream.startChat(customFields: customFields)
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
    
    @objc(startChatWithFirstQuestion:customFields:error:)
    func startChat(firstQuestion: String?,
                   customFields: String?) throws {
        try messageStream.startChat(firstQuestion: firstQuestion,
                                    customFields: customFields)
    }
    
    @objc(startChatWithDepartmentKey:customFields:error:)
    func startChat(departmentKey: String?,
                   customFields: String?) throws {
        try messageStream.startChat(departmentKey: departmentKey,
                                    customFields: customFields)
    }
    
    @objc(startChatWithDepartmentKey:firstQuestion:customFields:error:)
    func startChat(departmentKey: String?,
                   firstQuestion: String?,
                   customFields: String?) throws {
        try messageStream.startChat(departmentKey: departmentKey,
                                    firstQuestion: firstQuestion,
                                    customFields: customFields)
    }
    
    @objc(closeChat:)
    func closeChat() throws {
        try messageStream.closeChat()
    }
    
    @objc(setVisitorTypingDraftMessage:error:)
    func setVisitorTyping(draftMessage: String?) throws {
        try messageStream.setVisitorTyping(draftMessage: draftMessage)
    }
    
    @objc(setPrechatFields:error:)
    func set(prechatFields: String) throws {
        try messageStream.set(prechatFields: prechatFields)
    }
    
    @objc(sendMessage:error:)
    func send(message: String) throws -> String {
        return try messageStream.send(message: message)
    }
    
    @objc(sendMessage:data:completionHandler:error:)
    func send(message: String,
              data: [String: Any]?,
              completionHandler: _ObjCDataMessageCompletionHandler?) throws -> String {
        return try messageStream.send(message: message,
                                      data: data,
                                      completionHandler: ((completionHandler == nil) ? nil : DataMessageCompletionHandlerWrapper(dataMessageCompletionHandler: completionHandler!)))
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
    
    @objc(sendKeyboardRequestWithButton:message:completionHandler:error:)
    func sendKeyboardRequest(button: _ObjCKeyboardButton,
                             message: _ObjCMessage,
                             completionHandler: _ObjCSendKeyboardRequestCompletionHandler?) throws {
        return try messageStream.sendKeyboardRequest(button: button.keyboardButton,
                                                     message: message.message,
                                                     completionHandler: ((completionHandler == nil) ? nil : SendKeyboardRequestCompletionHandlerWrapper(sendKeyboardRequestCompletionHandler: completionHandler!)))
    }
    
    @objc(sendKeyboardRequestWithButtonID:messageCurrentChatID:completionHandler:error:)
    func sendKeyboardRequest(buttonID: String,
                             messageCurrentChatID: String,
                             completionHandler: _ObjCSendKeyboardRequestCompletionHandler?) throws {
        return try messageStream.sendKeyboardRequest(buttonID: buttonID,
                                                     messageCurrentChatID: messageCurrentChatID,
                                                     completionHandler: ((completionHandler == nil) ? nil : SendKeyboardRequestCompletionHandlerWrapper(sendKeyboardRequestCompletionHandler: completionHandler!)))
    }
    
    @objc(replyMessage:repliedMessage:error:)
    func reply(message: String,
               repliedMessage: _ObjCMessage) throws -> String {
        return try messageStream.reply(message: message, repliedMessage: repliedMessage.message) ?? ""
    }
    
    
    @objc(editMessage:text:completionHandler:error:)
    func edit(message: _ObjCMessage,
              text: String,
              completionHandler: _ObjCEditMessageCompletionHandler?) throws -> NSNumber {
        let canBeEdited = try messageStream.edit(message: message.message,
                                                 text: text,
                                                 completionHandler: ((completionHandler == nil) ? nil : EditMessageCompletionHandlerWrapper(editMessageCompletionHandler: completionHandler!)))
        if canBeEdited {
            return 1
        } else {
            return 0
        }
    }
    
    @objc(deleteMessage:completionHandler:error:)
    func delete(message: _ObjCMessage,
                completionHandler: _ObjCDeleteMessageCompletionHandler?) throws -> NSNumber {
        let canBeEdited = try messageStream.delete(message: message.message,
                                               completionHandler: ((completionHandler == nil) ? nil : DeleteMessageCompletionHandlerWrapper(deleteMessageCompletionHandler: completionHandler!)))
        if canBeEdited {
            return 1
        } else {
            return 0
        }
    }
    
    @objc(setChatRead:)
    func setChatRead() throws {
        try messageStream.setChatRead()
    }
    
    @objc(newMessageTrackerWithMessageListener:error:)
    func newMessageTracker(messageListener: _ObjCMessageListener) throws -> _ObjCMessageTracker {
        let wrapper = MessageListenerWrapper(messageListener: messageListener)
        messageListenerWrapper = wrapper
        return try _ObjCMessageTracker(messageTracker: messageStream.newMessageTracker(messageListener: wrapper))
    }
    
    @objc(setVisitSessionStateListener:)
    func set(visitSessionStateListener: _ObjCVisitSessionStateListener) {
        let wrapper = VisitSessionStateListenerWrapper(visitSessionStateListener: visitSessionStateListener)
        visitSessionStateListenerWrapper = wrapper
        messageStream.set(visitSessionStateListener: wrapper)
    }
    
    @objc(setChatStateListener:)
    func set(chatStateListener: _ObjCChatStateListener) {
        let wrapper = ChatStateListenerWrapper(chatStateListener: chatStateListener)
        chatStateListenerWrapper = wrapper
        messageStream.set(chatStateListener: wrapper)
    }
    
    @objc(setCurrentOperatorChangeListener:)
    func set(currentOperatorChangeListener: _ObjCCurrentOperatorChangeListener) {
        let wrapper = CurrentOperatorChangeListenerWrapper(currentOperatorChangeListener: currentOperatorChangeListener)
        currentOperatorChangeListenerWrapper = wrapper
        messageStream.set(currentOperatorChangeListener: wrapper)
    }
    
    @objc(setDepartmentListChangeListener:)
    func set(departmentListChangeListener: _ObjCDepartmentListChangeListener) {
        let wrapper = DepartmentListChangeListenerWrapper(departmentListChangeListener: departmentListChangeListener)
        departmentListChangeListenerWrapper = wrapper
        messageStream.set(departmentListChangeListener: wrapper)
    }
    
    @objc(LocationSettingsChangeListener:)
    func set(locationSettingsChangeListener: _ObjCLocationSettingsChangeListener) {
        let wrapper = LocationSettingsChangeListenerWrapper(locationSettingsChangeListener: locationSettingsChangeListener)
        locationSettingsChangeListenerWrapper = wrapper
        messageStream.set(locationSettingsChangeListener: wrapper)
    }
    
    @objc(setOperatorTypingListener:)
    func set(operatorTypingListener: _ObjCOperatorTypingListener) {
        let wrapper = OperatorTypingListenerWrapper(operatorTypingListener: operatorTypingListener)
        operatorTypingListenerWrapper = wrapper
        messageStream.set(operatorTypingListener: wrapper)
    }
    
    @objc(setOnlineStatusChangeListener:)
    func set(onlineStatusChangeListener: _ObjCOnlineStatusChangeListener) {
        let wrapper = OnlineStatusChangeListenerWrapper(onlineStatusChangeListener: onlineStatusChangeListener)
        onlineStatusChangeListenerWrapper = wrapper
        messageStream.set(onlineStatusChangeListener: wrapper)
    }
    
    @objc(setUnreadByOperatorTimestampChangeListener:)
    func set(unreadByOperatorTimestampChangeListener: _ObjCUnreadByOperatorTimestampChangeListener) {
        let wrapper = UnreadByOperatorTimestampChangeListenerWrapper(unreadByOperatorTimestampChangeListener: unreadByOperatorTimestampChangeListener)
        unreadByOperatorTimestampChangeListenerWrapper = wrapper
        messageStream.set(unreadByOperatorTimestampChangeListener: wrapper)
    }
    
    @objc(setUnreadByVisitorTimestampChangeListener:)
    func set(unreadByVisitorTimestampChangeListener: _ObjCUnreadByVisitorTimestampChangeListener) {
        let wrapper = UnreadByVisitorTimestampChangeListenerWrapper(unreadByVisitorTimestampChangeListener: unreadByVisitorTimestampChangeListener)
        unreadByVisitorTimestampChangeListenerWrapper = wrapper
        messageStream.set(unreadByVisitorTimestampChangeListener: wrapper)
    }
    
    @objc(setUnreadByVisitorMessageCountChangeListener:)
    func set(unreadByVisitorMessageCountChangeListener: _ObjCUnreadByVisitorMessageCountChangeListener) {
        let wrapper = UnreadByVisitorMessageCountChangeListenerWrapper(unreadByVisitorMessageCountChangeListener: unreadByVisitorMessageCountChangeListener)
        unreadByVisitorMessageCountChangeListenerWrapper = wrapper
        messageStream.set(unreadByVisitorMessageCountChangeListener: wrapper)
    }
        
}

// MARK: - LocationSettings
@objc(LocationSettings)
final class _ObjCLocationSettings: NSObject {
    
    // MARK: - Properties
    private let locationSettings: LocationSettings
    
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


// MARK: - DataMessageCompletionHandler
@objc(DataMessageCompletionHandler)
protocol _ObjCDataMessageCompletionHandler {
    
    @objc(onSuccessWithMessageID:)
    func onSuccess(messageID: String)
    
    @objc(onFailureWithMessageID:error:)
    func onFailure(messageID: String,
                   error: _ObjCDataMessageError)
    
}

// MARK: - SendKeyboardRequestCompletionHandler
@objc(SendKeyboardRequestCompletionHandler)
protocol _ObjCSendKeyboardRequestCompletionHandler {
    
    @objc(onSuccessWithMessageID:)
    func onSuccess(messageID: String)
    
    @objc(onFailureWithMessageID:error:)
    func onFailure(messageID: String,
                   error: _ObjCKeyboardResponseError)
    
}

// MARK: - EditMessageCompletionHandler
@objc(EditMessageCompletionHandler)
protocol _ObjCEditMessageCompletionHandler {
    
    @objc(onSuccessWithMessageID:)
    func onSuccess(messageID: String)
    
    @objc(onFailureWithMessageID:error:)
    func onFailure(messageID: String,
                   error: _ObjCEditMessageError)
    
}

// MARK: - DeleteMessageCompletionHandler
@objc(DeleteMessageCompletionHandler)
protocol _ObjCDeleteMessageCompletionHandler {
    
    @objc(onSuccessWithMessageID:)
    func onSuccess(messageID: String)
    
    @objc(onFailureWithMessageID:error:)
    func onFailure(messageID: String,
                   error: _ObjCDeleteMessageError)
    
}

// MARK: - SendFileCompletionHandler
@objc(SendFileCompletionHandler)
protocol _ObjCSendFileCompletionHandler {
    
    @objc(onSuccessWithMessageID:)
    func onSuccess(messageID: String)
    
    @objc(onFailureWithMessageID:error:)
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
    func changed(operator previousOperator: _ObjCOperator?,
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

// MARK: - UnreadByOperatorTimestampChangeListener
@objc(UnreadByOperatorTimestampChangeListener)
protocol _ObjCUnreadByOperatorTimestampChangeListener {
    
    @objc(changedUnreadByOperatorTimestampTo:)
    func changedUnreadByOperatorTimestampTo(newValue: Date?)
    
}

// MARK: - UnreadByVisitorTimestampChangeListener
@objc(UnreadByVisitorTimestampChangeListener)
protocol _ObjCUnreadByVisitorTimestampChangeListener {
    
    @objc(changedUnreadByVisitorTimestampTo:)
    func changedUnreadByVisitorTimestampTo(newValue: Date?)
    
}

// MARK: - UnreadByVisitorMessageCountChangeListener
@objc(UnreadByVisitorMessageCountChangeListener)
protocol _ObjCUnreadByVisitorMessageCountChangeListener {
    
    @objc(changedUnreadByVisitorMessageCountTo:)
    func changedUnreadByVisitorMessageCountTo(newValue: Int)
    
}

// MARK: - ChatState
@objc(ChatState)
enum _ObjCChatState: Int {
    case CHATTING
    case CHATTING_WITH_ROBOT
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

// MARK: - DataMessageError
@objc(DataMessageError)
enum _ObjCDataMessageError: Int, Error {
    case QUOTED_MESSAGE_CANNOT_BE_REPLIED
    case QUOTED_MESSAGE_FROM_ANOTHER_VISITOR
    case QUOTED_MESSAGE_MULTIPLE_IDS
    case QUOTED_MESSAGE_REQUIRED_ARGUMENTS_MISSING
    case QUOTED_MESSAGE_WRONG_ID
    case UNKNOWN
}

// MARK: - KeyboardResponseError
@objc(KeyboardResponseError)
enum _ObjCKeyboardResponseError: Int, Error {
    case UNKNOWN
    case NO_CHAT
    case BUTTON_ID_NOT_SET
    case REQUEST_MESSAGE_ID_NOT_SET
    case CAN_NOT_CREATE_RESPONSE
}

// MARK: - EditMessageError
@objc(EditMessageError)
enum _ObjCEditMessageError: Int, Error {
    case UNKNOWN
    case NOT_ALLOWED
    case MESSAGE_EMPTY
    case MESSAGE_NOT_OWNED
    case MAX_LENGTH_EXCEEDED
    case WRONG_MESSAGE_KIND
}

// MARK: - DeleteMessageError
@objc(DeleteMessageError)
enum _ObjCDeleteMessageError: Int, Error {
    case UNKNOWN
    case NOT_ALLOWED
    case MESSAGE_NOT_OWNED
    case MESSAGE_NOT_FOUND
}

// MARK: - SendFileError
@objc(SendFileError)
enum _ObjCSendFileError: Int, Error {
    case FILE_SIZE_EXCEEDED
    case FILE_TYPE_NOT_ALLOWED
    case UPLOADED_FILE_NOT_FOUND
    case UNKNOWN
    case FILE_SIZE_TOO_SMALL
    case MAX_FILES_COUNT_PER_CHAT_EXCEEDED
    case UNAUTHORIZED
}

// MARK: - RateOperatorError
@objc(RateOperatorError)
enum _ObjCRateOperatorError: Int, Error {
    case NO_CHAT
    case WRONG_OPERATOR_ID
    case NOTE_IS_TOO_LONG
}


// MARK: - Protocols' wrappers

// MARK: - DataMessageCompletionHandler
fileprivate final class DataMessageCompletionHandlerWrapper: DataMessageCompletionHandler {
    
    // MARK: - Properties
    private weak var dataMessageCompletionHandler: _ObjCDataMessageCompletionHandler?
    
    
    // MARK: - Initialization
    init(dataMessageCompletionHandler: _ObjCDataMessageCompletionHandler) {
        self.dataMessageCompletionHandler = dataMessageCompletionHandler
    }
    
    
    // MARK: - Methods
    // MARK: DataMessageCompletionHandler protocol methods
    
    func onSuccess(messageID: String) {
        dataMessageCompletionHandler?.onSuccess(messageID: messageID)
    }
    
    func onFailure(messageID: String, error: DataMessageError) {
        var objCError: _ObjCDataMessageError?
        switch error {
        case .quotedMessageCanNotBeReplied:
            objCError = .QUOTED_MESSAGE_CANNOT_BE_REPLIED
        case .quotedMessageFromAnotherVisitor:
            objCError = .QUOTED_MESSAGE_FROM_ANOTHER_VISITOR
        case .quotedMessageMultipleIds:
            objCError = .QUOTED_MESSAGE_MULTIPLE_IDS
        case .quotedMessageRequiredArgumentsMissing:
            objCError = .QUOTED_MESSAGE_REQUIRED_ARGUMENTS_MISSING
        case .quotedMessageWrongId:
            objCError = .QUOTED_MESSAGE_WRONG_ID
        case .unknown:
            objCError = .UNKNOWN
        }
        
        dataMessageCompletionHandler?.onFailure(messageID: messageID,
                                               error: objCError!)
    }
    
}

// MARK: - SendKeyboardRequestCompletionHandler
fileprivate final class SendKeyboardRequestCompletionHandlerWrapper: SendKeyboardRequestCompletionHandler {
    
    // MARK: - Properties
    private weak var sendKeyboardRequestCompletionHandler: _ObjCSendKeyboardRequestCompletionHandler?
    
    
    // MARK: - Initialization
    init(sendKeyboardRequestCompletionHandler: _ObjCSendKeyboardRequestCompletionHandler) {
        self.sendKeyboardRequestCompletionHandler = sendKeyboardRequestCompletionHandler
    }
    
    
    // MARK: - Methods
    // MARK: SendKeyboardRequestCompletionHandler protocol methods
    
    func onSuccess(messageID: String) {
        sendKeyboardRequestCompletionHandler?.onSuccess(messageID: messageID)
    }
    
    func onFailure(messageID: String, error: KeyboardResponseError) {
        var objCError: _ObjCKeyboardResponseError?
        switch error {
        case .unknown:
            objCError = .UNKNOWN
        case .noChat:
            objCError = .NO_CHAT
        case .buttonIdNotSet:
            objCError = .BUTTON_ID_NOT_SET
        case .requestMessageIdNotSet:
            objCError = .REQUEST_MESSAGE_ID_NOT_SET
        case .canNotCreateResponse:
            objCError = .CAN_NOT_CREATE_RESPONSE
        }
        
        sendKeyboardRequestCompletionHandler?.onFailure(messageID: messageID,
                                                        error: objCError!)
    }
    
}

// MARK: - EditMessageCompletionHandler
fileprivate final class EditMessageCompletionHandlerWrapper: EditMessageCompletionHandler {
    
    // MARK: - Properties
    private weak var editMessageCompletionHandler: _ObjCEditMessageCompletionHandler?
    
    
    // MARK: - Initialization
    init(editMessageCompletionHandler: _ObjCEditMessageCompletionHandler) {
        self.editMessageCompletionHandler = editMessageCompletionHandler
    }
    
    
    // MARK: - Methods
    // MARK: EditMessageCompletionHandler protocol methods
    
    func onSuccess(messageID: String) {
        editMessageCompletionHandler?.onSuccess(messageID: messageID)
    }
    
    func onFailure(messageID: String, error: EditMessageError) {
        var objCError: _ObjCEditMessageError?
        switch error {
        case .notAllowed:
            objCError = .NOT_ALLOWED
        case .messageEmpty:
            objCError = .MESSAGE_EMPTY
        case .messageNotOwned:
            objCError = .MESSAGE_NOT_OWNED
        case .maxLengthExceeded:
            objCError = .MAX_LENGTH_EXCEEDED
        case .wrongMesageKind:
            objCError = .WRONG_MESSAGE_KIND
        case .unknown:
            objCError = .UNKNOWN
        }
        
        editMessageCompletionHandler?.onFailure(messageID: messageID,
                                                error: objCError!)
    }
    
}

// MARK: - DeleteMessageCompletionHandler
fileprivate final class DeleteMessageCompletionHandlerWrapper: DeleteMessageCompletionHandler {
    
    // MARK: - Properties
    private weak var deleteMessageCompletionHandler: _ObjCDeleteMessageCompletionHandler?
    
    
    // MARK: - Initialization
    init(deleteMessageCompletionHandler: _ObjCDeleteMessageCompletionHandler) {
        self.deleteMessageCompletionHandler = deleteMessageCompletionHandler
    }
    
    
    // MARK: - Methods
    // MARK: DeleteMessageCompletionHandler protocol methods
    
    func onSuccess(messageID: String) {
        deleteMessageCompletionHandler?.onSuccess(messageID: messageID)
    }
    
    func onFailure(messageID: String, error: DeleteMessageError) {
        var objCError: _ObjCDeleteMessageError?
        switch error {
        case .unknown:
            objCError = .UNKNOWN
        case .notAllowed:
            objCError = .NOT_ALLOWED
        case .messageNotOwned:
            objCError = .MESSAGE_NOT_OWNED
        case .messageNotFound:
            objCError = .MESSAGE_NOT_FOUND
        }
        
        deleteMessageCompletionHandler?.onFailure(messageID: messageID,
                                                  error: objCError!)
    }
    
}

// MARK: - SendFileCompletionHandler
fileprivate final class SendFileCompletionHandlerWrapper: SendFileCompletionHandler {
    
    // MARK: - Properties
    private weak var sendFileCompletionHandler: _ObjCSendFileCompletionHandler?
    
    
    // MARK: - Initialization
    init(sendFileCompletionHandler: _ObjCSendFileCompletionHandler) {
        self.sendFileCompletionHandler = sendFileCompletionHandler
    }
    
    
    // MARK: - Methods
    // MARK: SendFileCompletionHandler protocol methods
    
    func onSuccess(messageID: String) {
        sendFileCompletionHandler?.onSuccess(messageID: messageID)
    }
    
    func onFailure(messageID: String,
                   error: SendFileError) {
        var objCError: _ObjCSendFileError?
        switch error {
        case .fileSizeExceeded:
            objCError = .FILE_SIZE_EXCEEDED
        case .fileTypeNotAllowed:
            objCError = .FILE_TYPE_NOT_ALLOWED
        case .uploadedFileNotFound:
            objCError = .UPLOADED_FILE_NOT_FOUND
        case .unknown:
            objCError = .UNKNOWN
        case .fileSizeTooSmall:
            objCError = .FILE_SIZE_TOO_SMALL
        case .maxFilesCountPerChatExceeded:
            objCError = .MAX_FILES_COUNT_PER_CHAT_EXCEEDED
        case .unauthorized:
            objCError = .UNAUTHORIZED
        }
        
        sendFileCompletionHandler?.onFailure(messageID: messageID,
                                            error: objCError!)
    }
    
}

// MARK: - RateOperatorCompletionHandler
fileprivate final class RateOperatorCompletionHandlerWrapper: RateOperatorCompletionHandler {
    
    // MARK: - Properties
    private weak var rateOperatorCompletionHandler: _ObjCRateOperatorCompletionHandler?
    
    
    // MARK: - Initialization
    init(rateOperatorCompletionHandler: _ObjCRateOperatorCompletionHandler) {
        self.rateOperatorCompletionHandler = rateOperatorCompletionHandler
    }
    
    
    // MARK: - Methods
    // MARK: RateOperatorCompletionHandler protocol methods
    
    func onSuccess() {
        rateOperatorCompletionHandler?.onSuccess()
    }
    
    func onFailure(error: RateOperatorError) {
        var objCError: _ObjCRateOperatorError?
        switch error {
        case .noChat:
            objCError = .NO_CHAT
        case .wrongOperatorId:
            objCError = .WRONG_OPERATOR_ID
        case .noteIsTooLong:
            objCError = .NOTE_IS_TOO_LONG
        }
        
        rateOperatorCompletionHandler?.onFailure(error: objCError!)
    }
    
}

// MARK: - VisitSessionStateListener
fileprivate final class VisitSessionStateListenerWrapper: VisitSessionStateListener {
    
    // MARK: - Properties
    private weak var visitSessionStateListener: _ObjCVisitSessionStateListener?
    
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
        case .chat:
            previousObjCVisitSessionState = .CHAT
        case .departmentSelection:
            previousObjCVisitSessionState = .DEPARTMENT_SELECTION
        case .idle:
            previousObjCVisitSessionState = .IDLE
        case .idleAfterChat:
            previousObjCVisitSessionState = .IDLE_AFTER_CHAT
        case .offlineMessage:
            previousObjCVisitSessionState = .OFFLINE_MESSAGE
        case .unknown:
            previousObjCVisitSessionState = .UNKNOWN
        }
        
        var newObjCVisitSessionState: _ObjCVisitSessionState?
        switch newState {
        case .chat:
            newObjCVisitSessionState = .CHAT
        case .departmentSelection:
            newObjCVisitSessionState = .DEPARTMENT_SELECTION
        case .idle:
            newObjCVisitSessionState = .IDLE
        case .idleAfterChat:
            newObjCVisitSessionState = .IDLE_AFTER_CHAT
        case .offlineMessage:
            newObjCVisitSessionState = .OFFLINE_MESSAGE
        case .unknown:
            newObjCVisitSessionState = .UNKNOWN
        }
        
        visitSessionStateListener?.changed(state: previousObjCVisitSessionState!,
                                          to: newObjCVisitSessionState!)
    }
    
}

// MARK: - ChatStateListener
fileprivate final class ChatStateListenerWrapper: ChatStateListener {
    
    // MARK: - Properties
    private let chatStateListener: _ObjCChatStateListener
    
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
        case .chatting:
            previousObjCChatState = .CHATTING
        case .chattingWithRobot:
            previousObjCChatState = .CHATTING_WITH_ROBOT
        case .closedByOperator:
            previousObjCChatState = .CLOSED_BY_OPERATOR
        case .closedByVisitor:
            previousObjCChatState = .CLOSED_BY_VISITOR
        case .invitation:
            previousObjCChatState = .INVITATION
        case .closed:
            previousObjCChatState = .NONE
        case .queue:
            previousObjCChatState = .QUEUE
        case .unknown:
            previousObjCChatState = .UNKNOWN
        }
        
        var newObjCChatState: _ObjCChatState?
        switch newState {
        case .chatting:
            newObjCChatState = .CHATTING
        case .chattingWithRobot:
            newObjCChatState = .CHATTING_WITH_ROBOT
        case .closedByOperator:
            newObjCChatState = .CLOSED_BY_OPERATOR
        case .closedByVisitor:
            newObjCChatState = .CLOSED_BY_VISITOR
        case .invitation:
            newObjCChatState = .INVITATION
        case .closed:
            newObjCChatState = .NONE
        case .queue:
            newObjCChatState = .QUEUE
        case .unknown:
            newObjCChatState = .UNKNOWN
        }
        
        chatStateListener.changed(state: previousObjCChatState!,
                                  to: newObjCChatState!)
    }
    
}

// MARK: - CurrentOperatorChangeListener
fileprivate final class CurrentOperatorChangeListenerWrapper: CurrentOperatorChangeListener {
    
    // MARK: - Properties
    private weak var currentOperatorChangeListener: _ObjCCurrentOperatorChangeListener?
    
    // MARK: - Initialization
    init(currentOperatorChangeListener: _ObjCCurrentOperatorChangeListener) {
        self.currentOperatorChangeListener = currentOperatorChangeListener
    }
    
    // MARK: - Methods
    // MARK: - CurrentOperatorChangeListener protocol methods
    func changed(operator previousOperator: Operator?,
                 to newOperator: Operator?) {
        currentOperatorChangeListener?.changed(operator: ((previousOperator == nil) ? nil : _ObjCOperator(operator: previousOperator!)),
                                              to: ((newOperator == nil) ? nil : _ObjCOperator(operator: newOperator!)))
    }
    
}

// MARK: - DepartmentListChangeListener
fileprivate final class DepartmentListChangeListenerWrapper: DepartmentListChangeListener {
    
    // MARK: - Properties
    private weak var departmentListChangeListener: _ObjCDepartmentListChangeListener?
    
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
        
        departmentListChangeListener?.received(departmentList: objCDepartmentList)
    }
    
}

// MARK: - LocationSettingsChangeListener
fileprivate final class LocationSettingsChangeListenerWrapper: LocationSettingsChangeListener {
    
    // MARK: - Properties
    private weak var locationSettingsChangeListener: _ObjCLocationSettingsChangeListener?
    
    // MARK: - Initialization
    init(locationSettingsChangeListener: _ObjCLocationSettingsChangeListener) {
        self.locationSettingsChangeListener = locationSettingsChangeListener
    }
    
    // MARK: - Methods
    // MARK: LocationSettingsChangeListener protocol methods
    func changed(locationSettings previousLocationSettings: LocationSettings,
                 to newLocationSettings: LocationSettings) {
        locationSettingsChangeListener?.changed(locationSettings: _ObjCLocationSettings(locationSettings: previousLocationSettings),
                                               to: _ObjCLocationSettings(locationSettings: newLocationSettings))
    }
    
}

// MARK: - OperatorTypingListener
fileprivate final class OperatorTypingListenerWrapper: OperatorTypingListener {
    
    // MARK: - Properties
    private weak var operatorTypingListener: _ObjCOperatorTypingListener?
    
    // MARK: - Initialization
    init(operatorTypingListener: _ObjCOperatorTypingListener) {
        self.operatorTypingListener = operatorTypingListener
    }
    
    // MARK: - Methods
    // MARK: OperatorTypingListener protocol methods
    func onOperatorTypingStateChanged(isTyping: Bool) {
        operatorTypingListener?.onOperatorTypingStateChanged(isTyping: isTyping)
    }
    
}

// MARK: - OnlineStatusChangeListener
fileprivate final class OnlineStatusChangeListenerWrapper: OnlineStatusChangeListener {
    
    // MARK: - Properties
    private weak var onlineStatusChangeListener: _ObjCOnlineStatusChangeListener?
    
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
        case .busyOffline:
            previousObjCOnlineStatus = .BUSY_OFFLINE
        case .busyOnline:
            previousObjCOnlineStatus = .BUSY_ONLINE
        case .offline:
            previousObjCOnlineStatus = .OFFLINE
        case .online:
            previousObjCOnlineStatus = .ONLINE
        case .unknown:
            previousObjCOnlineStatus = .UNKNOWN
        }
        
        var newObjCOnlineStatus: _ObjCOnlineStatus?
        switch newOnlineStatus {
        case .busyOffline:
            newObjCOnlineStatus = .BUSY_OFFLINE
        case .busyOnline:
            newObjCOnlineStatus = .BUSY_ONLINE
        case .offline:
            newObjCOnlineStatus = .OFFLINE
        case .online:
            newObjCOnlineStatus = .ONLINE
        case .unknown:
            newObjCOnlineStatus = .UNKNOWN
        }
        
        onlineStatusChangeListener?.changed(onlineStatus: previousObjCOnlineStatus!,
                                           to: newObjCOnlineStatus!)
    }
    
    
}

// MARK: - UnreadByOperatorTimestampChangeListener
fileprivate final class UnreadByOperatorTimestampChangeListenerWrapper: UnreadByOperatorTimestampChangeListener {
    
    // MARK: - Properties
    private weak var unreadByOperatorTimestampChangeListener: _ObjCUnreadByOperatorTimestampChangeListener?
    
    // MARK: - Initialization
    init(unreadByOperatorTimestampChangeListener: _ObjCUnreadByOperatorTimestampChangeListener) {
        self.unreadByOperatorTimestampChangeListener = unreadByOperatorTimestampChangeListener
    }
    
    // MARK: - Methods
    // MARK: UnreadByOperatorTimestampChangeListener protocol methods
    func changedUnreadByOperatorTimestampTo(newValue: Date?) {
        unreadByOperatorTimestampChangeListener?.changedUnreadByOperatorTimestampTo(newValue: newValue)
    }
    
}

// MARK: - UnreadByVisitorTimestampChangeListener
fileprivate final class UnreadByVisitorTimestampChangeListenerWrapper: UnreadByVisitorTimestampChangeListener {
    
    // MARK: - Properties
    private weak var unreadByVisitorTimestampChangeListener: _ObjCUnreadByVisitorTimestampChangeListener?
    
    // MARK: - Initialization
    init(unreadByVisitorTimestampChangeListener: _ObjCUnreadByVisitorTimestampChangeListener) {
        self.unreadByVisitorTimestampChangeListener = unreadByVisitorTimestampChangeListener
    }
    
    // MARK: - Methods
    // MARK: - UnreadByVisitorTimestampChangeListener protocol methods
    func changedUnreadByVisitorTimestampTo(newValue: Date?) {
        unreadByVisitorTimestampChangeListener?.changedUnreadByVisitorTimestampTo(newValue: newValue)
    }
    
}

// MARK: - UnreadByVisitorMessageCountChangeListener
fileprivate final class UnreadByVisitorMessageCountChangeListenerWrapper: UnreadByVisitorMessageCountChangeListener {
    
    // MARK: - Properties
    private weak var unreadByVisitorMessageCountChangeListener: _ObjCUnreadByVisitorMessageCountChangeListener?
    
    // MARK: - Initialization
    init(unreadByVisitorMessageCountChangeListener: _ObjCUnreadByVisitorMessageCountChangeListener) {
        self.unreadByVisitorMessageCountChangeListener = unreadByVisitorMessageCountChangeListener
    }
    
    // MARK: - Methods
    // MARK: - UnreadByVisitorMessageCountChangeListener protocol methods
    func changedUnreadByVisitorMessageCountTo(newValue: Int) {
        unreadByVisitorMessageCountChangeListener?.changedUnreadByVisitorMessageCountTo(newValue: newValue)
    }
    
}
