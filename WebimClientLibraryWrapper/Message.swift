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
    private (set) var message: Message?
    
    
    // MARK: - Initialization
    init?(message: Message?) {
        if let message = message {
            self.message = message
        } else {
            return nil
        }
    }
    
    // MARK: - Methods
    
    @objc(getAttachment)
    func getAttachment() -> _ObjCMessageAttachment? {
        return _ObjCMessageAttachment(messageAttachment: message?.getAttachment())
    }
    
    @objc(getData)
    func getData() -> [String : Any]? {
        if let data = message?.getData() {
            var objCData = [String : Any]()
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
    func getID() -> String? {
        return message?.getID()
    }
    
    @objc(getOperatorID)
    func getOperatorID() -> String? {
        return message?.getOperatorID()
    }
    
    @objc(getSenderAvatarFullURL)
    func getSenderAvatarFullURL() -> URL? {
        return message?.getSenderAvatarFullURL()
    }
    
    @objc(getSenderName)
    func getSenderName() -> String {
        return getSenderName()
    }
    
    @objc(getSendStatus)
    func getSendStatus() -> _ObjCMessageSendStatus {
        if let messageSendStatus = message?.getSendStatus() {
            switch messageSendStatus {
            case .SENDING:
                return .SENDING
            case .SENT:
                return .SENT
            }
        } else {
            return .NONE
        }
    }
    
    @objc(getText)
    func getText() -> String? {
        return message?.getText()
    }
    
    @objc(getTime)
    func getTime() -> Date? {
        return message?.getTime() as Date?
    }
    
    @objc(getType)
    func getType() -> _ObjCMessageType {
        if let messageType = message?.getType() {
            switch messageType {
            case .ACTION_REQUEST:
                return .ACTION_REQUEST
            case .FILE_FROM_OPERATOR:
                return .FILE_FROM_OPERATOR
            case .FILE_FROM_VISITOR:
                return .FILE_FROM_VISITOR
            case .INFO:
                return .INFO
            case .OPERATOR:
                return .OPERATOR
            case .OPERATOR_BUSY:
                return .OPERATOR_BUSY
            case .VISITOR:
                return .VISITOR
            }
        } else {
            return .NONE
        }
    }
    
    @objc(isEqualTo:)
    func isEqual(to message: _ObjCMessage) -> Bool {
        if let firstInternalMessage = self.message,
            let secondInternalMessage = message.message {
            return firstInternalMessage.isEqual(to: secondInternalMessage)
        } else {
            return false
        }
    }
    
}

// MARK: - MessageAttachment
@objc(MessageAttachment)
final class _ObjCMessageAttachment: NSObject {
    
    // MARK: - Properties
    private (set) var messageAttachment: MessageAttachment?
    
    
    // MARK: - Initialization
    init?(messageAttachment: MessageAttachment?) {
        if let messageAttachment = messageAttachment {
            self.messageAttachment = messageAttachment
        } else {
            return nil
        }
    }
    
    
    // MARK: - Methods
    
    @objc(getContentType)
    func getContentType() -> String? {
        return messageAttachment?.getContentType()
    }
    
    @objc(getFileName)
    func getFileName() -> String? {
        return messageAttachment?.getFileName()
    }
    
    @objc(getImageInfo)
    func getImageInfo() -> _ObjCImageInfo? {
        return _ObjCImageInfo(imageInfo: messageAttachment?.getImageInfo())
    }
    
    @objc(getSize)
    func getSize() -> NSNumber? {
        return messageAttachment?.getSize() as NSNumber?
    }
    
    @objc(getURLString)
    func getURLString() -> String? {
        return messageAttachment?.getURLString()
    }
    
}

// MARK: - ImageInfo
@objc(ImageInfo)
final class _ObjCImageInfo: NSObject {
    
    // MARK: - Properties
    private (set) var imageInfo: ImageInfo?
    
    
    // MARK: - Initialization
    init?(imageInfo: ImageInfo?) {
        if let imageInfo = imageInfo {
            self.imageInfo = imageInfo
        } else {
            return nil
        }
    }
    
    
    // MARK: - Methods
    
    @objc(getThumbURLString)
    func getThumbURLString() -> String? {
        return imageInfo?.getThumbURLString()
    }
    
    @objc(getHeight)
    func getHeight() -> NSNumber? {
        return imageInfo?.getHeight() as NSNumber?
    }
    
    @objc(getWidth)
    func getWidth() -> NSNumber? {
        return imageInfo?.getWidth() as NSNumber?
    }
    
}


// MARK: - MessageType
@objc(MessageType)
enum _ObjCMessageType: Int {
    case NONE = 0
    case ACTION_REQUEST = 1
    case FILE_FROM_OPERATOR = 2
    case FILE_FROM_VISITOR = 3
    case INFO = 4
    case OPERATOR = 5
    case OPERATOR_BUSY = 6
    case VISITOR = 7
}

// MARK: - MessageSendStatus
@objc(MessageSendStatus)
enum _ObjCMessageSendStatus: Int {
    case NONE = 0
    case SENDING = 1
    case SENT = 2
}
