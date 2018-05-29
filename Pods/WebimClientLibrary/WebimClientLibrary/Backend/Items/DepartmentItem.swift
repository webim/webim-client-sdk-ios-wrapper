//
//  DepartmentItem.swift
//  Cosmos
//
//  Created by Nikita Lazarev-Zubov on 11.12.17.
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
 Encapsulates internal representation of single department.
 - author:
 Nikita Lazarev-Zubov
 - copyright:
 2017 Webim
 */
final class DepartmentItem {
    
    // MARK: - Constants
    
    // Raw values equal to field names received in responses from server.
    private enum JSONField: String {
        case key = "key"
        case localizedNames = "localeToName"
        case name = "name"
        case onlineStatus = "online"
        case order = "order"
        case logo = "logo"
    }
    
    enum InternalDepartmentOnlineStatus: String {
        case busyOffline = "busy_offline"
        case busyOnline = "busy_online"
        case offline = "offline"
        case online = "online"
        case unknown
    }
    
    // MARK: - Properties
    private let key: String
    private let name: String
    private let onlineStatus: InternalDepartmentOnlineStatus
    private let order: Int
    private var localizedNames: [String: String]?
    private var logo: String?
    
    // MARK: - Initialization
    init?(jsonDictionary: [String: Any?]) {
        guard let key = jsonDictionary[JSONField.key.rawValue] as? String,
            let name = jsonDictionary[JSONField.name.rawValue] as? String,
            let onlineStatusString = jsonDictionary[JSONField.onlineStatus.rawValue] as? String,
            let order = jsonDictionary[JSONField.order.rawValue] as? Int else {
            return nil
        }
        
        self.key = key
        self.name = name
        self.onlineStatus = InternalDepartmentOnlineStatus(rawValue: onlineStatusString) ?? .unknown
        self.order = order
        
        if let logoURLString = jsonDictionary[JSONField.logo.rawValue] as? String {
            self.logo = logoURLString
        }
        
        if let localizedNames = jsonDictionary[JSONField.localizedNames.rawValue] as? [String: String] {
            self.localizedNames = localizedNames
        }
    }
    
    // MARK: - Methods
    
    func getKey() -> String {
        return key
    }
    
    func getName() -> String {
        return name
    }
    
    func getOnlineStatus() -> InternalDepartmentOnlineStatus {
        return onlineStatus
    }
    
    func getOrder() -> Int {
        return order
    }
    
    func getLocalizedNames() -> [String: String]? {
        return localizedNames
    }
    
    func getLogoURLString() -> String? {
        return logo
    }
    
}
