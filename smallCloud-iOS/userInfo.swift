//
//  userInfo.swift
//  smallCloud-iOS
//
//  Created by WS on 2023/06/01.
//

import Foundation

struct UserInfoStruct:Codable{
    let id:Int
    let email:String
    let password:String
    let name:String
    let phone:String
    let reject:Bool
    let birthday:String?
    let safeMoney:Int
}
