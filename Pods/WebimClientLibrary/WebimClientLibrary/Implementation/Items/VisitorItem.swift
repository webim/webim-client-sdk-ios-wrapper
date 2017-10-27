//
//  VisitorItem.swift
//  WebimClientLibrary
//
//  Created by Nikita Lazarev-Zubov on 15.08.17.
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

// This class is not used anywhere yet. Implemented for the future tasks.
// FIXME: Fix SessionParametersListenerImpl for using this class instead of visitorJSONString and manual deserialization.
final class VisitorItem {
    
    // MARK: - Constants
    // Raw values equal to field names received in responses from server.
    private enum JSONField: String {
        case ICON = "icon"
        case ID = "id"
        case VISITOR_FIELDS = "fields"
    }
    
    
    // MARK: - Properties
    private var id: String?
    private var icon: IconItem?
    private var visitorFields: VisitorFields?
    
    
    // MARK: - Initialization
    init(withJSONDictionary jsonDictionary: [String : Any?]) {
        if let iconValue = jsonDictionary[JSONField.ICON.rawValue] as? [String : Any?] {
            icon = IconItem(withJSONDictionary: iconValue)
        }
        
        if let visitorFieldsValue = jsonDictionary[JSONField.VISITOR_FIELDS.rawValue] as? [String : Any?] {
            visitorFields = VisitorFields(withJSONDictionary: visitorFieldsValue)
        }
        
        if let id = jsonDictionary[JSONField.ID.rawValue] as? String {
            self.id = id
        }
    }
    
    
    // MARK: - Methods
    
    func getVisitorFields() -> VisitorFields? {
        return visitorFields
    }
    
    func getName() -> String? {
        return visitorFields?.getName()
    }
    
    func getID() -> String? {
        return id
    }
    
    func getIcon() -> IconItem? {
        return icon
    }
    
}

// MARK: -
struct VisitorFields {
    
    // MARK: - Constants
    // Raw values equal to field names received in responses from server.
    private enum JSONField: String {
        case EMAIL = "email"
        case NAME = "name"
        case PHONE = "phone"
    }
    
    // MARK: - Properties
    private var email: String?
    private var name: String?
    private var phone: String?
    
    
    // MARK: - Initialization
    
    init(withName name: String?,
         phone: String?,
         email: String?) {
        self.name = name
        self.phone = phone
        self.email = email
    }
    
    init(withJSONDictionary jsonDictionary: [String: Any?]) {
        if let email = jsonDictionary[JSONField.EMAIL.rawValue] as? String {
            self.email = email
        }
        
        if let name = jsonDictionary[JSONField.NAME.rawValue] as? String {
            self.name = name
        }
        
        if let phone = jsonDictionary[JSONField.PHONE.rawValue] as? String {
            self.phone = phone
        }
    }
    
    
    // MARK: - Methods
    
    func getName() -> String? {
        return name
    }
    
    func getPhone() -> String? {
        return phone
    }
    
    func getEMail() -> String? {
        return email
    }
    
}
