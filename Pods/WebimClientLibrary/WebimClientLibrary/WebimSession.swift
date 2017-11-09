//
//  WebimSession.swift
//  WebimClientLibrary
//
//  Created by Nikita Lazarev-Zubov on 02.08.17.
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
public protocol WebimSession {
    
    /**
     Resumes session networking.
     - important:
     Session is created as paused. To start using it firstly you should call this method.
     - throws:
     `AccessError.INVALID_THREAD` if the method was called not from the thread the WebimSession was created in.
     `AccessError.INVALID_SESSION` if WebimSession was destroyed.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func resume() throws
    
    /**
     Pauses session networking.
     - throws:
     `AccessError.INVALID_THREAD` if the method was called not from the thread the WebimSession was created in.
     `AccessError.INVALID_SESSION` if WebimSession was destroyed.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func pause() throws
    
    /**
     Destroys session. After that any session methods are not available.
     - throws:
     `AccessError.INVALID_THREAD` if the method was called not from the thread the WebimSession was created in.
     `AccessError.INVALID_SESSION` if WebimSession was destroyed.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func destroy() throws
    
    /**
     - returns:
     A `MessageStream` object attached to this session. Each invocation of this method returns the same object.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func getStream() -> MessageStream
    
    /**
     Changes location without creating a new session.
     - parameter location:
     New location name.
     - throws:
     `FatalErrorType`.
     - SeeAlso:
     `FatalErrorHandler`.
     - Author:
     Nikita Lazarev-Zubov
     - Copyright:
     2017 Webim
     */
    func change(location: String) throws
    
}
