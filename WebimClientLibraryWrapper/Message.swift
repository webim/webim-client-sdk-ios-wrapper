//
//  Message.swift
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


// MARK: - Message
@objc(Message)
final class _ObjCMessage: NSObject {
    
    // MARK: - Properties
    private (set) var message: Message
    
    
    // MARK: - Initialization
    init(message: Message) {
        self.message = message
    }
    
    // MARK: - Methods
    
    @objc(getAttachment)
    func getAttachment() -> _ObjCMessageAttachment? {
        if let attachment = message.getData()?.getAttachment() {
            return _ObjCMessageAttachment(messageAttachment: attachment)
        }
        
        return nil
    }
    
    @objc(getData)
    func getData() -> [String: Any]? {
        if let data = message.getRawData() {
            var objCData = [String: Any]()
            for key in data.keys {
                if let value = data[key] {
                    objCData[key] = value
                }
            }
            
            return objCData
        } else {
            return nil
        }
    }
    
    @objc(getID)
    func getID() -> String {
        return message.getID()
    }
    
    @objc(getServerSideID)
    func getServerSideID() -> String? {
        return message.getServerSideID()
    }
    
    @objc(getCurrentChatID)
    func getCurrentChatID() -> String? {
        return message.getCurrentChatID()
    }
    
    @objc(getKeyboard)
    func getKeyboard() -> _ObjCKeyboard? {
        if let keyboard = message.getKeyboard() {
            return _ObjCKeyboard(keyboard: keyboard)
        }
        return nil
    }
    
    @objc(getKeyboardRequest)
    func getKeyboardRequest() -> _ObjCKeyboardRequest? {
        if let keyboardRequest = message.getKeyboardRequest() {
            return _ObjCKeyboardRequest(keyboardRequest: keyboardRequest)
        }
        return nil
    }
    
    @objc(getOperatorID)
    func getOperatorID() -> String? {
        return message.getOperatorID()
    }
    
    @objc(getQuote)
    func getQuote() -> _ObjCQuote? {
        if let quote = message.getQuote() {
            return _ObjCQuote(quote: quote)
        }
        return nil
    }
    
    @objc(getSenderAvatarFullURL)
    func getSenderAvatarFullURL() -> URL? {
        return message.getSenderAvatarFullURL()
    }
    
    @objc(getSenderName)
    func getSenderName() -> String {
        return message.getSenderName()
    }
    
    @objc(getSendStatus)
    func getSendStatus() -> _ObjCMessageSendStatus {
        switch message.getSendStatus() {
        case .sending:
            return .SENDING
        case .sent:
            return .SENT
        }
    }
    
    @objc(getText)
    func getText() -> String {
        return message.getText()
    }
    
    @objc(getTime)
    func getTime() -> Date {
        return message.getTime()
    }
    
    @objc(getType)
    func getType() -> _ObjCMessageType {
        switch message.getType() {
        case .actionRequest:
            return .ACTION_REQUEST
        case .contactInformationRequest:
            return .CONTACTS_REQUEST
        case .fileFromOperator:
            return .FILE_FROM_OPERATOR
        case .fileFromVisitor:
            return .FILE_FROM_VISITOR
        case .info:
            return .INFO
        case .operatorMessage:
            return .OPERATOR
        case .operatorBusy:
            return .OPERATOR_BUSY
        case .visitorMessage:
            return .VISITOR
        case .keyboard:
            return .KEYBOARD
        case .keyboardResponse:
            return .KEYBOARD_RESPONSE
        case .stickerVisitor:
            return .STICKER
        }
    }
    
    @objc(isEqualTo:)
    func isEqual(to message: _ObjCMessage) -> Bool {
        return self.message.isEqual(to: message.message)
    }
    
    @objc(isReadByOperator)
    func isReadByOperator() -> Bool {
        return message.isReadByOperator()
    }
    
    @objc(canBeEdited)
    func canBeEdited() -> Bool {
        return message.canBeEdited()
    }
    
    @objc(canBeReplied)
    func canBeReplied() -> Bool {
        return message.canBeReplied()
    }
    
    @objc(isEdited)
    func isEdited() -> Bool {
        return message.isEdited()
    }
    
}

// MARK: - MessageAttachment
@objc(MessageAttachment)
final class _ObjCMessageAttachment: NSObject {
    
    // MARK: - Properties
    private let messageAttachment: MessageAttachment
    
    
    // MARK: - Initialization
    init(messageAttachment: MessageAttachment) {
        self.messageAttachment = messageAttachment
    }
    
    
    // MARK: - Methods
    
    @objc(getContentType)
    func getContentType() -> String {
        return messageAttachment.getFileInfo().getContentType() ?? ""
    }
    
    @objc(getFileName)
    func getFileName() -> String {
        return messageAttachment.getFileInfo().getFileName()
    }
    
    @objc(getImageInfo)
    func getImageInfo() -> _ObjCImageInfo? {
        if let imageInfo = messageAttachment.getFileInfo().getImageInfo() {
            return _ObjCImageInfo(imageInfo: imageInfo)
        }
        
        return nil
    }
    
    @objc(getSize)
    func getSize() -> NSNumber? {
        return messageAttachment.getFileInfo().getSize() as NSNumber?
    }
    
    @objc(getURL)
    func getURL() -> URL {
        return messageAttachment.getFileInfo().getURL() ?? URL(fileURLWithPath: "")
    }
    
}

// MARK: - ImageInfo
@objc(ImageInfo)
final class _ObjCImageInfo: NSObject {
    
    // MARK: - Properties
    private let imageInfo: ImageInfo
    
    
    // MARK: - Initialization
    init(imageInfo: ImageInfo) {
        self.imageInfo = imageInfo
    }
    
    
    // MARK: - Methods
    
    @objc(getThumbURLString)
    func getThumbURLString() -> URL {
        return imageInfo.getThumbURL()
    }
    
    @objc(getHeight)
    func getHeight() -> NSNumber? {
        return imageInfo.getHeight() as NSNumber?
    }
    
    @objc(getWidth)
    func getWidth() -> NSNumber? {
        return imageInfo.getWidth() as NSNumber?
    }
    
}

@objc(Keyboard)
final class _ObjCKeyboard: NSObject {
    
    // MARK: - Properties
    private let keyboard: Keyboard
    
    
    // MARK: - Initialization
    init(keyboard: Keyboard) {
        self.keyboard = keyboard
    }
    
    // MARK: - Methods
    @objc(getButtons)
    func getButtons() -> [[_ObjCKeyboardButton]] {
        var _objCButtons = [_ObjCKeyboardButton]()
        for buttons in keyboard.getButtons() {
            for button in buttons {
                _objCButtons.append(_ObjCKeyboardButton(keyboardButton: button))
            }
        }
        var array = [[_ObjCKeyboardButton]]()
        array.append(_objCButtons)
        return array
    }
    
    @objc(getState)
    func getState() -> _ObjCKeyboardState {
        switch keyboard.getState() {
        case .pending:
            return .PENDING
        case .completed:
            return .COMPLETED
        case .canceled:
            return .CANCELED
        }
    }
    
    @objc(getResponse)
    func getResponse() -> _ObjCKeyboardResponse? {
        if let response = keyboard.getResponse() {
            return _ObjCKeyboardResponse(keyboardResponse: response)
        }
        return nil
    }
}

@objc(KeyboardButton)
final class _ObjCKeyboardButton: NSObject {
    
    // MARK: - Properties
    private (set) var keyboardButton: KeyboardButton
    
    
    // MARK: - Initialization
    init(keyboardButton: KeyboardButton) {
        self.keyboardButton = keyboardButton
    }
    
    // MARK: - Methods
    @objc(getID)
    func getID() -> String {
        return keyboardButton.getID()
    }
    
    @objc(getText)
    func getText() -> String {
        return keyboardButton.getText()
    }
    
    @objc(getConfiguration)
    func getConfiguration() -> _ObjCConfiguration? {
        if let configuration = keyboardButton.getConfiguration() {
            return _ObjCConfiguration(configuration: configuration)
        }
        return nil
    }
}

@objc(Configuration)
final class _ObjCConfiguration: NSObject {
    
    // MARK: - Properties
    private let configuration: Configuration
    
    
    // MARK: - Initialization
    init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    // MARK: - Methods
    @objc(getData)
    func getData() -> String {
        return configuration.getData()
    }
    
    @objc(isActive)
    func isActive() -> Bool {
        return configuration.isActive()
    }
    
    @objc(getState)
    func getState() -> _ObjCButtonState {
        switch configuration.getState() {
        case .showing:
            return .SHOWING
        case .showingSelected:
            return .SHOWING_SELECTED
        case .hidden:
            return .HIDDEN
        }
    }
    
    @objc(getButtonType)
    func getButtonType() -> _ObjCButtonType {
        switch configuration.getButtonType() {
        case .url:
            return .URL
        case .insert:
            return .INSERT
        }
    }
}

@objc(KeyboardResponse)
final class _ObjCKeyboardResponse: NSObject {
    
    // MARK: - Properties
    private let keyboardResponse: KeyboardResponse
    
    
    // MARK: - Initialization
    init(keyboardResponse: KeyboardResponse) {
        self.keyboardResponse = keyboardResponse
    }
    
    // MARK: - Methods
    @objc(getButtonID)
    func getButtonID() -> String {
        return keyboardResponse.getButtonID()
    }
    
    @objc(getMessageID)
    func getMessageID() -> String {
        return keyboardResponse.getMessageID()
    }
}

@objc(KeyboardRequest)
final class _ObjCKeyboardRequest: NSObject {
    
    // MARK: - Properties
    private let keyboardRequest: KeyboardRequest
    
    
    // MARK: - Initialization
    init(keyboardRequest: KeyboardRequest) {
        self.keyboardRequest = keyboardRequest
    }
    
    // MARK: - Methods
    @objc(getMessageID)
    func getMessageID() -> String {
        return keyboardRequest.getMessageID()
    }
    
    @objc(getButton)
    func getButton() -> _ObjCKeyboardButton {
        return _ObjCKeyboardButton(keyboardButton: keyboardRequest.getButton())
    }
}

@objc(Quote)
final class _ObjCQuote: NSObject {
    
    // MARK: - Properties
    private let quote: Quote
    
    
    // MARK: - Initialization
    init(quote: Quote) {
        self.quote = quote
    }
    
    // MARK: - Methods
    @objc(getAuthorID)
    func getAuthorID() -> String? {
        return quote.getAuthorID()
    }
    
    @objc(getFileInfo)
    func getFileInfo() -> String? {
        return quote.getAuthorID()
    }
    
    @objc(getMessageTimestamp)
    func getMessageTimestamp() -> Date? {
        return quote.getMessageTimestamp()
    }
    
    @objc(getMessageID)
    func getMessageID() -> String? {
        return quote.getMessageID()
    }
    
    @objc(getMessageText)
    func getMessageText() -> String? {
        return quote.getMessageText()
    }
    
    @objc(getMessageType)
    func getMessageType() -> _ObjCMessageType {
        guard let type = quote.getMessageType() else {
            return .INFO
        }
        switch type {
        case .actionRequest:
            return .ACTION_REQUEST
        case .contactInformationRequest:
            return .CONTACTS_REQUEST
        case .fileFromOperator:
            return .FILE_FROM_OPERATOR
        case .fileFromVisitor:
            return .FILE_FROM_VISITOR
        case .info:
            return .INFO
        case .operatorMessage:
            return .OPERATOR
        case .operatorBusy:
            return .OPERATOR_BUSY
        case .visitorMessage:
            return .VISITOR
        case .keyboard:
            return .KEYBOARD
        case .keyboardResponse:
            return .KEYBOARD_RESPONSE
        case .stickerVisitor:
            return .STICKER
        }
    }
    
    @objc(getSenderName)
    func getSenderName() -> String? {
        return quote.getSenderName()
    }
    
    @objc(getState)
    func getState() -> _ObjCQuoteState {
        switch quote.getState() {
        case .pending:
            return .PENDING
        case .filled:
            return .FILLED
        case .notFound:
            return .NOT_FOUND
        }
    }
}

// MARK: - MessageType
@objc(MessageType)
enum _ObjCMessageType: Int {
    case ACTION_REQUEST
    case CONTACTS_REQUEST
    case FILE_FROM_OPERATOR
    case FILE_FROM_VISITOR
    case INFO
    case KEYBOARD
    case KEYBOARD_RESPONSE
    case OPERATOR
    case OPERATOR_BUSY
    case VISITOR
    case STICKER
}

// MARK: - MessageSendStatus
@objc(MessageSendStatus)
enum _ObjCMessageSendStatus: Int {
    case SENDING
    case SENT
}

// MARK: - KeyboardState
@objc(KeyboardState)
enum _ObjCKeyboardState: Int {
    case PENDING
    case COMPLETED
    case CANCELED
}

// MARK: - ButtonState
@objc(ButtonState)
enum _ObjCButtonState: Int {
    case SHOWING
    case SHOWING_SELECTED
    case HIDDEN
}

// MARK: - ButtonType
@objc(ButtonType)
enum _ObjCButtonType: Int {
    case URL
    case INSERT
}

@objc(QuoteState)
enum _ObjCQuoteState: Int {
    case PENDING
    case FILLED
    case NOT_FOUND
}
