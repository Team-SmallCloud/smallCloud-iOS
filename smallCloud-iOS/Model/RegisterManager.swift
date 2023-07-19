//
//  RegisterManager.swift
//  smallCloud-iOS
//
//  Created by WS on 2023/07/20.
//

import Foundation
import CoreData

final class RegisterManager{
    
    private var context: NSManagedObjectContext{
            
        guard let app = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        return app.persistentContainer.viewContext
    }
    
    private var userInfo:UserInfoStruct!
    
    func getRegister(name:String, email:String, password:String, phone:String) -> Bool{
        
        let semaphore = DispatchSemaphore(value: 0)
        guard let url = URL(string: "http://3.39.188.228:9090/account/signup") else {
            print("유효하지 않은 URL입니다.")
            return false
        }
        
        let parameters: [String: String] = [
            "name": name,
            "email": email,
            "password": password,
            "phone": phone
        ]
        
        //dictionary -> key=value& 방식 String으로 변환
        let parameterString = parameters.map { key, value in
            return "\(key)=\(value)"
        }.joined(separator: "&")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.httpBody = parameterString.data(using: .utf8)

        // URLSession 요청 보내기
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("요청 실패: \(error.localizedDescription)")
                return
            }
            
            // 응답 처리
            guard let JSONdata = data else {return}
            print("응답 데이터: \(String(data: JSONdata, encoding: .utf8) ?? "")")
            
            // 응답 처리
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(UserInfoStruct.self, from: JSONdata)
                self.userInfo = decodedData
            }catch{
                print(error)
                semaphore.signal()
                return
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        
        guard let userInfo = userInfo else {
            return false
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
        do {
            // Fetch Request 실행
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try context.execute(batchDeleteRequest)

        } catch {
            // 오류 처리
            print("Failed to delete User entity: \(error)")
        }
        
        let userEntity = NSEntityDescription.insertNewObject(forEntityName: "UserInfo", into: self.context)

        //CoreData에 유저정보 저장
        userEntity.setValue(userInfo.email, forKey: "email")
        userEntity.setValue(userInfo.password, forKey: "password")
        userEntity.setValue(userInfo.name, forKey: "name")
        userEntity.setValue(userInfo.phone, forKey: "phone")
        userEntity.setValue(userInfo.birthday, forKey: "birthday")
        userEntity.setValue(userInfo.safeMoney, forKey: "safeMoney")
        userEntity.setValue(userInfo.reject, forKey: "reject")
        
        //영구저장소에 반영
        do {
            try self.context.save()
            print("User Data saved successfully")

        } catch {
            print("Failed to save data: \(error)")
        }
        return true
    }
    
}
