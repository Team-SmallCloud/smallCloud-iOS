//
//  NSObject.swift
//  smallCloud-iOS
//
//  Created by WS on 2023/06/10.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
