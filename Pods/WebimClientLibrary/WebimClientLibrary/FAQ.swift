//
//  FAQ.swift
//  WebimClientLibrary
//
//  Created by Nikita Kaberov on 07.02.19.
//  Copyright © 2019 Webim. All rights reserved.
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
 - author:
 Nikita Kaberov
 - copyright:
 2019 Webim
 */
public protocol FAQ {
    
    /**
     Resumes FAQ networking.
     - important:
     FAQ is created as paused. To start using it firstly you should call this method.
     - throws:
     `FAQAccessError.INVALID_THREAD` if the method was called not from the thread the WebimSession was created in.
     `FAQAccessError.INVALID_FAQ` if FAQ was destroyed.
     - author:
     Nikita Kaberov
     - copyright:
     2019 Webim
     */
    func resume() throws
    
    /**
     Pauses FAQ networking.
     - throws:
     `FAQAccessError.INVALID_THREAD` if the method was called not from the thread the FAQ was created in.
     `FAQAccessError.INVALID_FAQ` if FAQ was destroyed.
     - author:
     Nikita Kaberov
     - copyright:
     2019 Webim
     */
    func pause() throws
    
    /**
     Destroys FAQ. After that any FAQ methods are not available.
     - throws:
     `FAQAccessError.INVALID_THREAD` if the method was called not from the thread the FAQ was created in.
     `FAQAccessError.INVALID_FAQ` if FAQ was destroyed.
     - author:
     Nikita Kaberov
     - copyright:
     2019 Webim
     */
    func destroy() throws
    
    /**
     Requests category. If nil is passed inside completion, there no category with this id.
     - seealso:
     `destroy()` method.
     `FAQCategory` protocol.
     - parameter id:
     Category ID.
     - parameter completion:
     Completion to be called on category if method call succeeded.
     - parameter result:
     Resulting category if method call succeeded.
     - throws:
     `FAQAccessError.INVALID_THREAD` if the method was called not from the thread the FAQ was created in.
     `FAQAccessError.INVALID_FAQ` if the method was called after FAQ object was destroyed.
     - author:
     Nikita Kaberov
     - copyright:
     2019 Webim
     */
    func getCategory(id: Int, completion: @escaping (_ result: FAQCategory?) -> ()) throws
    
    /**
     Requests item. If nil is passed inside completion, there no item with this id.
     - seealso:
     `destroy()` method.
     `FAQItem` protocol.
     - parameter id:
     Item ID.
     - parameter completion:
     Completion to be called on item if method call succeeded.
     - parameter result:
     Resulting item if method call succeeded.
     - throws:
     `FAQAccessError.INVALID_THREAD` if the method was called not from the thread the FAQ was created in.
     `FAQAccessError.INVALID_FAQ` if the method was called after FAQ object was destroyed.
     - author:
     Nikita Kaberov
     - copyright:
     2019 Webim
     */
    func getItem(id: String, completion: @escaping (_ result: FAQItem?) -> ()) throws
    
    /**
     Requests structure. If nil is passed inside completion, there no structure with this id.
     - seealso:
     `destroy()` method.
     `FAQStructure` protocol.
     - parameter id:
     Structure ID.
     - parameter completion:
     Completion to be called on structure if method call succeeded.
     - parameter result:
     Resulting structure if method call succeeded.
     - throws:
     `FAQAccessError.INVALID_THREAD` if the method was called not from the thread the FAQ was created in.
     `FAQAccessError.INVALID_FAQ` if the method was called after FAQ object was destroyed.
     - author:
     Nikita Kaberov
     - copyright:
     2019 Webim
     */
    func getStructure(id: Int, completion: @escaping (_ result: FAQStructure?) -> ()) throws
}

// MARK: -
/**
 Error types that can be throwed by FAQ methods.
 - seealso:
 `FAQ` methods.
 - author:
 Nikita Kaberov
 - copyright:
 2019 Webim
 */
public enum FAQAccessError: Error {
    
    /**
     Error that is thrown if the method was called not from the thread the FAQ was created in.
     - author:
     Nikita Kaberov
     - copyright:
     2019 Webim
     */
    case INVALID_THREAD
    
    /**
     Error that is thrown if FAQ was destroyed.
     - author:
     Nikita Kaberov
     - copyright:
     2019 Webim
     */
    case INVALID_FAQ
}
