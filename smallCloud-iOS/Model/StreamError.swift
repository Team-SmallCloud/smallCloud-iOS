//
//  StreamError.swift
//  smallCloud-iOS
//
//  Created by WS on 2023/06/10.
//


import Foundation

enum StreamError: Error {
    case firestoreError(Error?)
    case decodedError(Error?)
}
