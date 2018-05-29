//
//  DepartmentFactory.swift
//  WebimClientLibrary
//
//  Created by Nikita Lazarev-Zubov on 19.02.18.
//  Copyright © 2018 Webim. All rights reserved.
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
 Mapper class that is responsible for converting internal department model objects to public ones.
 - author:
 Nikita Lazarev-Zubov
 - copyright:
 2018 Webim
 */
final class DepartmentFactory {
    
    // MARK: - Properties
    let serverURLString: String
    
    // MARK - Initialization
    init(serverURLString: String) {
        self.serverURLString = serverURLString
    }
    
    // MARK: - Methods
    
    func convert(departmentItem: DepartmentItem) -> DepartmentImpl {
        var fullLogoURL: URL? = nil
        if let logoURLString = departmentItem.getLogoURLString() {
            fullLogoURL = URL(string: serverURLString + logoURLString)
        }
        
        return DepartmentImpl(key: departmentItem.getKey(),
                              name: departmentItem.getName(),
                              departmentOnlineStatus: publicState(ofDepartmentOnlineStatus: departmentItem.getOnlineStatus()),
                              order: departmentItem.getOrder(),
                              localizedNames: departmentItem.getLocalizedNames(),
                              logo: fullLogoURL)
    }
    
    // MARK: Private methods
    private func publicState(ofDepartmentOnlineStatus departmentOnlineStatus: DepartmentItem.InternalDepartmentOnlineStatus) -> DepartmentOnlineStatus {
        switch departmentOnlineStatus {
        case .busyOffline:
            return .BUSY_OFFLINE
        case .busyOnline:
            return .BUSY_ONLINE
        case .offline:
            return .OFFLINE
        case .online:
            return .ONLINE
        case .unknown:
            return .UNKNOWN
        }
    }
    
}
