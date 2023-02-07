//
//  UploadedFile.swift
//  WebimClientLibrary
//
//  Created by Nikita Kaberov on 15.11.20.
//  Copyright © 2020 Webim. All rights reserved.
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
 Uploaded file.
 - author:
 Nikita Kaberov
 - copyright:
 2020 Webim
 */
public protocol UploadedFile {
    var description: String { get }
    
    /**
     - returns:
     File size in bytes
     - author:
     Nikita Kaberov
     - copyright:
     2020 Webim
     */
    func getSize() -> Int64

    /**
     * @return guid of a file
     */
    func getGuid() -> String
    
    /**
     - returns:
     File name.
     - author:
     Nikita Kaberov
     - copyright:
     2020 Webim
     */
    func getFileName() -> String

    /**
     * @return MIME-type of a file
     */
    /**
     - returns:
     MIME-type of a file
     - author:
     Nikita Kaberov
     - copyright:
     2020 Webim
     */
    func getContentType() -> String?

    /**
     * @return visitor Id of a file
     */
    /**
     - returns:
     Visitor ID.
     - author:
     Nikita Kaberov
     - copyright:
     2020 Webim
     */
    func getVisitorID() -> String

    /**
     - returns:
     MIME-type of a file
     - author:
     Nikita Kaberov
     - copyright:
     2020 Webim
     */
    func getClientContentType() -> String
    
    /**
     - seealso:
     `ImageInfo` protocol.
     - returns:
     If a file is an image, returns information about an image; in other cases returns nil.
     - author:
     Nikita Kaberov
     - copyright:
     2020 Webim
     */
    func getImageInfo() -> ImageInfo?
}
