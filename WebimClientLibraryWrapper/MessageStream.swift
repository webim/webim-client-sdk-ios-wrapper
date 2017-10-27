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
    
    @objc(getLocationSettings)
    func getLocationSettings() -> _ObjCLocationSettings {
        return _ObjCLocationSettings(locationSettings: messageStream.getLocationSettings())
    }
    
    @objc(getCurrentOperator)
    func getCurrentOperator() -> _ObjCOperator? {
        return _ObjCOperator(operator: messageStream.getCurrentOperator())
    }
    
    @objc(getLastRatingOfOperatorWithID:)
    func getLastRatingOfOperatorWith(id: String) -> Int {
        return messageStream.getLastRatingOfOperatorWith(id: id)
    }
    
    @objc(rateOperatorWithID:byRating:error:)
    func rateOperatorWith(id: String,
                          byRating rating: Int) throws {
        try messageStream .rateOperatorWith(id: id,
                                            byRating: rating)
    }
    
    @objc(startChat:)
    func startChat() throws {
        try messageStream.startChat()
    }
    
    @objc(closeChat:)
    func closeChat() throws {
        try messageStream.closeChat()
    }
    
    @objc(setVisitorTypingDraftMessage:error:)
    func setVisitorTyping(draftMessage: String?) throws {
        try messageStream.setVisitorTyping(draftMessage: draftMessage)
    }
    
    @objc(sendMessage:isHintQuestion:error:)
    func send(message: String,
              isHintQuestion: Bool) throws -> String {
        return try messageStream.send(message: message,
                                      isHintQuestion: isHintQuestion)
    }
    
    @objc(sendMessage:error:)
    func send(message: String) throws -> String {
        return try messageStream.send(message: message)
    }
    
    @objc(sendFile:filename:mimeType:completionHandler:error:)
    func send(file: Data,
              filename: String,
              mimeType: String,
              completionHandler: _ObjCSendFileCompletionHandler?) throws -> String {
        return try messageStream.send(file: file,
                                      filename: filename,
                                      mimeType: mimeType,
                                      completionHandler: SendFileCompletionHandlerWrapper(sendFileCompletionHandler: completionHandler))
    }
    
    @objc(newMessageTrackerWithMessageListener:error:)
    func new(messageTracker messageListener: _ObjCMessageListener) throws -> _ObjCMessageTracker {
        return try _ObjCMessageTracker(messageTracker: messageStream.new(messageTracker: MessageListenerWrapper(messageListener: messageListener)))
    }
    
    @objc(setChatStateListener:)
    func set(chatStateListener: _ObjCChatStateListener) {
        messageStream.set(chatStateListener: ChatStateListenerWrapper(chatStateListener: chatStateListener))
    }
    
    @objc(setCurrentOperatorChangeListener:)
    func set(currentOperatorChangeListener: _ObjCCurrentOperatorChangeListener) {
        messageStream.set(currentOperatorChangeListener: CurrentOperatorChangeListenerWrapper(currentOperatorChangeListener: currentOperatorChangeListener))
    }
    
    @objc(setOperatorTypingListener:)
    func set(operatorTypingListener: _ObjCOperatorTypingListener) {
        messageStream.set(operatorTypingListener: OperatorTypingListenerWrapper(operatorTypingListener: operatorTypingListener))
    }
    
    @objc(LocationSettingsChangeListener:)
    func set(locationSettingsChangeListener: _ObjCLocationSettingsChangeListener) {
        messageStream.set(locationSettingsChangeListener: LocationSettingsChangeListenerWrapper(locationSettingsChangeListener: locationSettingsChangeListener))
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

// MARK: - ChatStateListener
@objc(ChatStateListener)
protocol _ObjCChatStateListener {
    
    @objc(ChangedState:To:)
    func changed(state previousState: _ObjCChatState,
                 to newState: _ObjCChatState)
    
}

// MARK: - CurrentOperatorChangeListener
@objc(CurrentOperatorChangeListener)
protocol _ObjCCurrentOperatorChangeListener {
    
    @objc(changedOperator:To:)
    func changed(operator previousOperator: _ObjCOperator,
                 to newOperator: _ObjCOperator)
    
}

// MARK: - OperatorTypingListener
@objc(OperatorTypingListener)
protocol _ObjCOperatorTypingListener {
    
    @objc(onOperatorTypingStateChangedTo:)
    func onOperatorTypingStateChanged(isTyping: Bool)
    
}

// MARK: - LocationSettingsChangeListener
@objc(LocationSettingsChangeListener)
protocol _ObjCLocationSettingsChangeListener {
    
    @objc(changedLocationSettings:To:)
    func changed(locationSettings previousLocationSettings: _ObjCLocationSettings,
                 to newLocationSettings: _ObjCLocationSettings)
    
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

// MARK: - SendFileError
@objc(SendFileError)
enum _ObjCSendFileError: Int, Error {
    case FILE_SIZE_EXCEEDED
    case FILE_TYPE_NOT_ALLOWED
}


// MARK: - Protocols' wrappers

// MARK: - SendFileCompletionHandler
fileprivate final class SendFileCompletionHandlerWrapper: SendFileCompletionHandler {
    
    // MARK: - Properties
    private (set) var sendFileCompletionHandler: _ObjCSendFileCompletionHandler?
    
    
    // MARK: - Initialization
    init?(sendFileCompletionHandler: _ObjCSendFileCompletionHandler?) {
        if let sendFileCompletionHandler = sendFileCompletionHandler {
            self.sendFileCompletionHandler = sendFileCompletionHandler
        } else {
            return nil
        }
    }
    
    
    // MARK: - Methods
    // MARK: SendFileCompletionHandler protocol methods
    
    func onSuccess(messageID: String) {
        if let sendFileCompletionHandler = sendFileCompletionHandler {
            sendFileCompletionHandler.onSuccess(messageID: messageID)
        }
    }
    
    func onFailure(messageID: String,
                   error: SendFileError) {
        if let sendFileCompletionHandler = sendFileCompletionHandler {
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
        var previousChatState: _ObjCChatState?
        switch previousState {
        case .CHATTING:
            previousChatState = .CHATTING
        case .CLOSED_BY_OPERATOR:
            previousChatState = .CLOSED_BY_OPERATOR
        case .CLOSED_BY_VISITOR:
            previousChatState = .CLOSED_BY_VISITOR
        case .INVITATION:
            previousChatState = .INVITATION
        case .NONE:
            previousChatState = .NONE
        case .QUEUE:
            previousChatState = .QUEUE
        case .UNKNOWN:
            previousChatState = .UNKNOWN
        }
        
        var newChatState: _ObjCChatState?
        switch newState {
        case .CHATTING:
            newChatState = .CHATTING
        case .CLOSED_BY_OPERATOR:
            newChatState = .CLOSED_BY_OPERATOR
        case .CLOSED_BY_VISITOR:
            newChatState = .CLOSED_BY_VISITOR
        case .INVITATION:
            newChatState = .INVITATION
        case .NONE:
            newChatState = .NONE
        case .QUEUE:
            newChatState = .QUEUE
        case .UNKNOWN:
            newChatState = .UNKNOWN
        }
        
        chatStateListener.changed(state: previousChatState!,
                                  to: newChatState!)
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
                 to newOperator: Operator) {
        currentOperatorChangeListener.changed(operator: _ObjCOperator(operator: previousOperator)!,
                                              to: _ObjCOperator(operator: newOperator)!)
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
