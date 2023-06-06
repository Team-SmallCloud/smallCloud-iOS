//
//  Bundle.swift
//  smallCloud-iOS
//
//  Created by WS on 2023/06/06.
//

import Foundation

extension Bundle {
    
    var animalApiKey: String {
        guard let file = self.path(forResource: "Secrets", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["ANIMAL_API_KEY"] as? String else { return "" }
        return key
    }
    
}
