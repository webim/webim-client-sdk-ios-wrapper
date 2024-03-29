//
//  Operator.swift
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


// MARK: - Operator
@objc(Operator)
final class _ObjCOperator: NSObject {
    
    // MARK: - Private
    private let `operator`: Operator
    
    
    // MARK: - Initialization
    init(operator: Operator) {
        self.`operator` = `operator`
    }
    
    
    // MARK: - Methods
    
    @objc(getID)
    func getID() -> String {
        return `operator`.getID()
    }
    
    @objc(getName)
    func getName() -> String {
        return `operator`.getName()
    }
    
    @objc(getAvatarURL)
    func getAvatarURL() -> URL? {
        return `operator`.getAvatarURL()
    }
    
    @objc(getTitle)
    func getTitle() -> String? {
        return `operator`.getTitle()
    }
    
    @objc(getInfo)
    func getInfo() -> String? {
        return `operator`.getInfo()
    }
}
