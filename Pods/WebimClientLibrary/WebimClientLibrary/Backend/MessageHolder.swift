//
//  MessageHolder.swift
//  WebimClientLibrary
//
//  Created by Nikita Lazarev-Zubov on 20.10.17.
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
 - Author:
 Nikita Lazarev-Zubov
 - Copyright:
 2017 Webim
 */
final class MessageHolder {
    
    // MARK: - Properties
    private let accessChecker: AccessChecker
    private let historyStorage: HistoryStorage
    private let remoteHistoryProvider: RemoteHistoryProvider
    private lazy var currentChatMessages = [MessageImpl]()
    private var lastChatMessageIndex = 0
    private lazy var messagesToSend = [MessageToSend]()
    private var messageTracker: MessageTrackerImpl?
    private var reachedEndOfLocalHistory = false
    private var reachedEndOfRemoteHistory: Bool
    
    
    // MARK: - Initialization
    init(withAccessChecker accessChecker: AccessChecker,
         remoteHistoryProvider: RemoteHistoryProvider,
         historyStorage: HistoryStorage,
         reachedEndOfRemoteHistory: Bool) {
        self.accessChecker = accessChecker
        self.remoteHistoryProvider = remoteHistoryProvider
        self.historyStorage = historyStorage
        self.reachedEndOfRemoteHistory = reachedEndOfRemoteHistory
    }
    
    
    // MARK: - Methods
    
    func checkAccess() throws {
        try accessChecker.checkAccess()
    }
    
    func getCurrentChatMessages() -> [MessageImpl] {
        return currentChatMessages
    }
    
    func set(currentChatMessages: [MessageImpl]) {
        self.currentChatMessages = currentChatMessages
    }
    
    func getLastChatMessageIndex() -> Int {
        return lastChatMessageIndex
    }
    
    func getMessagesToSend() -> [MessageToSend] {
        return messagesToSend
    }
    
    func set(messagesToSend: [MessageToSend]) {
        self.messagesToSend = messagesToSend
    }
    
    func getLatestMessages(byLimit limitOfMessages: Int,
                             completion: @escaping ([Message]) -> ()) {
        if !currentChatMessages.isEmpty {
            respondTo(messages: currentChatMessages,
                      limitOfMessages: limitOfMessages,
                      completion: completion)
        } else {
            historyStorage.getLatest(byLimit: limitOfMessages,
                                     completion: completion)
        }
    }
    
    func getMessagesBy(limit: Int,
                       before message: MessageImpl,
                       completion: @escaping ([Message]) -> ()) {
        if message.getSource().isCurrentChatMessage() {
            if currentChatMessages.isEmpty {
                print("Current chat is empty. Requesting history rejected.")
                
                return
            }
            
            let firstMessage = currentChatMessages.first!
            if message === firstMessage {
                if !firstMessage.hasHistoryComponent() {
                    historyStorage.getLatest(byLimit: limit,
                                             completion: completion)
                } else {
                    getMessagesFromHistoryBefore(id: firstMessage.getHistoryID()!,
                                                 limit: limit,
                                                 completion: completion)
                }
            } else {
                getMessagesFromCurrentChatBefore(message: message,
                                                 limit: limit,
                                                 completion: completion)
            }
        } else {
            getMessagesFromHistoryBefore(id: message.getHistoryID()!,
                                         limit: limit,
                                         completion: completion)
        }
    }
    
    func set(messageTracker: MessageTrackerImpl?) {
        self.messageTracker = messageTracker
    }
    
    func getHistoryStorage() -> HistoryStorage {
        return historyStorage
    }
    
    func getRemoteHistoryProvider() -> RemoteHistoryProvider {
        return remoteHistoryProvider
    }
    
    func set(reachedEndOfLocalHistory: Bool) {
        self.reachedEndOfLocalHistory = reachedEndOfLocalHistory
    }
    
    func newMessageTracker(withMessageListener messageListener: MessageListener) throws -> MessageTrackerImpl {
        if self.messageTracker != nil {
            try self.messageTracker!.destroy()
        }
        
        self.set(messageTracker: MessageTrackerImpl(withMessageListener: messageListener,
                                                        messageHolder: self))
        
        return messageTracker!
    }
    
    func receiveHistoryUpdateWith(messages: [MessageImpl],
                                  deleted: Set<String>,
                                  completion: @escaping () -> ()) {
        historyStorage.receiveHistoryUpdate(withMessages: messages,
                                            idsToDelete: deleted) { (endOfBatch: Bool, messageDeleted: Bool, deletedMessageID: String?, messageChanged: Bool, changedMessage: MessageImpl?, messageAdded: Bool, addedMessage: MessageImpl?, idBeforeAddedMessage: HistoryID?) -> () in
                                                    if endOfBatch {
                                                        if self.messageTracker != nil {
                                                            self.messageTracker!.endedHistoryBatch()
                                                        }
                                                        
                                                        completion()
                                                    }
                                                    
                                                    if messageDeleted {
                                                        // Assuming that when messageDeleted == true deletedMessageID cannot be nil.
                                                        if self.messageTracker != nil {
                                                            self.messageTracker!.deletedHistoryMessage(withID: deletedMessageID!)
                                                        }
                                                    }
                                                    
                                                    if messageChanged {
                                                        // Assuming that when messageChanged == true changedMessage cannot be nil.
                                                        if self.messageTracker != nil {
                                                            self.messageTracker!.changedHistory(message: changedMessage!)
                                                        }
                                                    }
                                                    
                                                    if messageAdded {
                                                        // Assuming that when messageAdded == true addedMessage cannot be nil.
                                                        if !self.tryMergeWithLastChat(message: addedMessage!) &&
                                                            (self.messageTracker != nil) {
                                                            self.messageTracker!.addedHistory(message: addedMessage!,
                                                                                              before: idBeforeAddedMessage)
                                                        }
                                                    }
        }
    }
    
    func set(endOfHistoryReached: Bool) {
        reachedEndOfRemoteHistory = endOfHistoryReached
        historyStorage.set(reachedHistoryEnd: endOfHistoryReached)
    }
    
    func receiving(newChat: ChatItem?,
                   previousChat: ChatItem?,
                   newMessages: [MessageImpl]) throws {
        if currentChatMessages.isEmpty {
            try receive(newMessages: newMessages)
        } else {
            if newChat == nil {
                historifyCurrentChat()
            } else if (previousChat == nil) ||
                (newChat != previousChat) {
                historifyCurrentChat()
                try receive(newMessages: newMessages)
            } else {
                try mergeCurrentChatWith(newMessages: newMessages)
            }
        }
    }
    
    func receive(newMessage: MessageImpl) throws {
        if messageTracker != nil {
            try messageTracker!.addedNew(message: newMessage,
                                         of: self)
        } else {
            currentChatMessages.append(newMessage)
        }
    }
    
    func changed(message: MessageImpl) {
        for messageIndex in lastChatMessageIndex ..< currentChatMessages.count {
            let previousVersion = currentChatMessages[messageIndex]
            if previousVersion.getCurrentChatID() == message.getCurrentChatID() {
                currentChatMessages[messageIndex] = message
                
                if messageTracker != nil {
                    messageTracker!.changedCurrentChatMessage(from: previousVersion,
                                                              to: message,
                                                              at: messageIndex,
                                                              of: self)
                }
                
                return
            }
        }
    }
    
    func deletedMessageWith(id: String) {
        for messageIndex in lastChatMessageIndex ..< currentChatMessages.count {
            let message = currentChatMessages[messageIndex]
            if message.getCurrentChatID() == id {
                currentChatMessages.remove(at: messageIndex)
                
                if messageTracker != nil {
                    messageTracker!.deletedCurrentChat(message: message,
                                                       at: messageIndex,
                                                       messageHolder: self)
                }
                
                return
            }
        }
    }
    
    func sending(message: MessageToSend) {
        messagesToSend.append(message)
        
        if messageTracker != nil {
            messageTracker!.messageListener.added(message: message,
                                                  after: nil)
        }
    }
    
    func sendingCancelledWith(messageID: String) {
        for messageIndex in 0 ..< messagesToSend.count {
            if messagesToSend[messageIndex].getID() == messageID {
                let message = messagesToSend[messageIndex]
                
                messagesToSend.remove(at: messageIndex)
                
                if messageTracker != nil {
                    messageTracker!.messageListener.removed(message: message)
                }
                
                return
            }
        }
    }
    
    
    // MARK: Private methods
    
    private func receive(newMessages: [MessageImpl]) throws {
        if messageTracker != nil {
            try messageTracker!.addedNew(messages: newMessages,
                                         of: self)
        } else {
            for message in newMessages {
                currentChatMessages.append(message)
            }
        }
    }
    
    private func respondTo(messages: [MessageImpl],
                           limitOfMessages: Int,
                           completion: ([Message]) -> ()) {
        completion(messages.isEmpty ?
            [MessageImpl]() :
            (messages.count <= limitOfMessages) ? messages : Array(messages[(messages.count - limitOfMessages) ..< messages.count]))
    }
    
    private func respondTo(messages: [MessageImpl],
                           limitOfMessages: Int,
                           offset: Int,
                           completion: ([Message]) -> ()) {
        let messageList = Array(messages[max(0, (offset - limitOfMessages)) ..< offset])
        completion(messageList)
    }
    
    private func historifyCurrentChat() {
        var newCurrentChatMessages = [MessageImpl]()
        
        for currentChatMessage in currentChatMessages {
            if currentChatMessage.hasHistoryComponent() {
                currentChatMessage.invertHistoryStatus()
                
                if messageTracker != nil {
                    if let id = currentChatMessage.getHistoryID()?.getDBid() {
                        if let historyMessage = messageTracker!.idToHistoryMessageMap[id] {
                            if currentChatMessage != historyMessage {
                                messageTracker!.messageListener.changed(message: currentChatMessage,
                                                                        to: historyMessage)
                            } else {
                                messageTracker!.idToHistoryMessageMap[id] = currentChatMessage
                            }
                        }
                    }
                    
                }
            } else {
                newCurrentChatMessages.append(currentChatMessage)
            }
        }
        
        self.set(currentChatMessages: newCurrentChatMessages)
        
        lastChatMessageIndex = currentChatMessages.count
    }
    
    private func requestHistory(beforeID id: HistoryID,
                                limit: Int,
                                completion: @escaping ([Message]) -> ()) {
        remoteHistoryProvider.requestHistory(beforeTimeSince: id.getTimeInMicrosecond(),
                                             completion: { (messages: [MessageImpl], hasMoreMessages: Bool) in
                                                if !hasMoreMessages {
                                                    self.reachedEndOfRemoteHistory = true
                                                }
                                                
                                                if !messages.isEmpty {
                                                    self.historyStorage.receiveHistoryBefore(messages: messages,
                                                                                             hasMoreMessages: hasMoreMessages)
                                                }
                                                
                                                self.respondTo(messages: messages,
                                                               limitOfMessages: limit,
                                                               completion: completion)
        })
    }
    
    private func getMessagesFromHistoryBefore(id: HistoryID,
                                              limit: Int,
                                              completion: @escaping ([Message]) -> ()) {
        if reachedEndOfLocalHistory != true {
            historyStorage.getBefore(id: id,
                                     limitOfMessages: limit,
                                     completion: { messages in
                                            if messages.isEmpty {
                                                self.reachedEndOfLocalHistory = true
                                                self.getMessagesFromHistoryBefore(id: id,
                                                                                  limit: limit,
                                                                                  completion: completion)
                                            } else {
                                                completion(messages)
                                            }
            })
        } else if reachedEndOfRemoteHistory == true {
            completion([MessageImpl]())
        } else {
            requestHistory(beforeID: id,
                               limit: limit,
                               completion: completion)
        }
    }
    
    private func getMessagesFromCurrentChatBefore(message: MessageImpl,
                                                  limit: Int,
                                                  completion: ([Message]) -> ()) {
        do {
            try message.getSource().assertIsCurrentChat()
        } catch {
            print("Message before which messages are requested is not a part of current chat.")
            
            return
        }
        
        let messageIndex = currentChatMessages.index(of: message)!
        
        guard messageIndex >= 1 else {
            print("Message \(message.toString()) before which messages of current chat are requested can't have index less than 1.")
            
            return
        }
        
        respondTo(messages: currentChatMessages,
                  limitOfMessages: limit,
                  offset: messageIndex,
                  completion: completion)
    }
    
    private func mergeCurrentChatWith(newMessages: [MessageImpl]) throws {
        var previousMessageIndex = lastChatMessageIndex
        var areOldMessagesEnded = false
        
        for messageIndex in 0 ..< newMessages.count {
            let newMessage = newMessages[messageIndex]
            
            if !areOldMessagesEnded {
                var isMerged = false
                
                while previousMessageIndex < currentChatMessages.count {
                    let previousMessage = currentChatMessages[previousMessageIndex]
                    if previousMessage.getID() == newMessage.getID() {
                        if previousMessage != newMessage {
                            currentChatMessages[previousMessageIndex] = newMessage
                            
                            if messageTracker != nil {
                                messageTracker!.changedCurrentChatMessage(from: previousMessage,
                                                                          to: newMessage,
                                                                          at: previousMessageIndex,
                                                                          of: self)
                            }
                        }
                        
                        isMerged = true
                        
                        previousMessageIndex = previousMessageIndex + 1
                        
                        break
                    } else {
                        currentChatMessages.remove(at: previousMessageIndex)
                        
                        if messageTracker != nil {
                            messageTracker!.deletedCurrentChat(message: previousMessage,
                                                               at: previousMessageIndex,
                                                               messageHolder: self)
                        }
                    }
                }
                
                if !isMerged &&
                    (previousMessageIndex >= currentChatMessages.count) {
                    areOldMessagesEnded = true
                }
            }
            
            if areOldMessagesEnded {
                try receive(newMessage: newMessage)
            }
        }
    }
    
    private func tryMergeWithLastChat(message: MessageImpl) -> Bool {
        for (currentChatMessageIndex, currentChatMessage) in currentChatMessages.enumerated() {
            if currentChatMessage.getID() == message.getID() {
                if currentChatMessageIndex < lastChatMessageIndex {
                    currentChatMessages.remove(at: currentChatMessageIndex)
                    lastChatMessageIndex = lastChatMessageIndex - 1
                    
                    let replacementMessage = currentChatMessage.transferToHistory(message: message)
                    if messageTracker != nil {
                        messageTracker!.idToHistoryMessageMap[(message.getHistoryID()?.getDBid())!] = replacementMessage
                        
                        if replacementMessage !== currentChatMessage {
                            messageTracker!.messageListener.changed(message: currentChatMessage,
                                                                    to: replacementMessage)
                        }
                    }
                    
                } else {
                    currentChatMessage.setSecondaryHistory(historyEquivalentMessage: message)
                    
                    if messageTracker != nil {
                        messageTracker!.idToHistoryMessageMap[(message.getHistoryID()?.getDBid())!] = message
                    }
                }
                
                return true
            }
        }
        
        return false
    }
    
}
