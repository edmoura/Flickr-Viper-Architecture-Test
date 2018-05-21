//
//  ReuseIdentifierProtocol.swift
//  FlickrViperArchitecture
//
//  Created by Edson iMAC on 20/05/2018.
//  Copyright © 2018 Edson Moura. All rights reserved.
//

import UIKit

public protocol ReuseIdentifierProtocol: class {
    //Get identifier from class
    static var defaultReuseIdentifier:String { get }
}

public extension ReuseIdentifierProtocol where Self: UIView {
    static var defaultReuseIdentifier:String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
