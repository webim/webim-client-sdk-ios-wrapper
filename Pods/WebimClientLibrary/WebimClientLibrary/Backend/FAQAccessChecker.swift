//
//  AccessChecker.swift
//  WebimClientLibrary
//
//  Created by Nikita Lazarev-Zubov on 11.09.17.
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
 Class that checks if FAQ methods are called in appropriate conditions.
 - author:
 Nikita Kaberov
 - copyright:
 2019 Webim
 */
class FAQAccessChecker {
    
    // MARK: - Properties
    let thread: Thread
    let faqDestroyer: FAQDestroyer
    
    // MARK: - Initialization
    init(thread: Thread,
         faqDestroyer: FAQDestroyer) {
        self.thread = thread
        self.faqDestroyer = faqDestroyer
    }
    
    // MARK: - Methods
    func checkAccess() throws {
        guard thread == Thread.current else {
            throw FAQAccessError.INVALID_THREAD
        }
        
        guard !faqDestroyer.isDestroyed() else {
            throw FAQAccessError.INVALID_FAQ
        }
    }
    
}
