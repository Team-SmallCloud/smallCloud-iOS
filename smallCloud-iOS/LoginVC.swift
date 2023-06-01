//
//  LoginVC.swift
//  smallCloud-iOS
//
//  Created by WS on 2023/05/31.
//

import UIKit
import CoreData

class LoginVC: UIViewController {

    var context: NSManagedObjectContext{
            
        guard let app = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        return app.persistentContainer.viewContext
    }
    
    @IBOutlet weak var loginLbl: UILabel!
    let stackView = UIStackView()
    
    var userInfo: UserInfoStruct!
    let emailFormFieldView = FormFieldView(text:"Email")
    let pwFormFieldView = FormFieldView(text:"Password")
    let loginButton = makeButton(withText: "로그인")
    var loginNavController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        ///
        emailFormFieldView.textField.text = "123@naver.com"
        pwFormFieldView.textField.text = "aA1234567!"
    }
}

extension LoginVC {
    
    func style() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .leading

        loginButton.addTarget(self, action: #selector(loginBtnTapped), for: .primaryActionTriggered)
    }
    
    func layout() {
        stackView.addArrangedSubview(emailFormFieldView)
        stackView.addArrangedSubview(pwFormFieldView)
        stackView.addArrangedSubview(loginButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emailFormFieldView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: emailFormFieldView.trailingAnchor, multiplier: 2),
            
            pwFormFieldView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: pwFormFieldView.trailingAnchor, multiplier: 2),
            
            loginButton.heightAnchor.constraint(equalTo: pwFormFieldView.heightAnchor),
            loginButton.widthAnchor.constraint(equalTo: pwFormFieldView.widthAnchor)
        ])
    }
}

// MARK: - Actions
extension LoginVC {
    
    @objc func loginBtnTapped() {
        
        let semaphore = DispatchSemaphore(value: 0)
        var urlString = "http://3.39.188.228:9090/account/login"

        //텍스트필드 빈값 검증
        guard let email = emailFormFieldView.textField.text,
              let password = pwFormFieldView.textField.text else { return }
        if email.isEmpty || password.isEmpty {
            print("모든값을 채워야 합니다.")
            return
        }
        //로그인값 parameter에 추가
        urlString += "?email=\(email)&password=\(password)"
        
        guard let url = URL(string: urlString) else {
            print("유효하지 않은 URL입니다.")
            return
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"


        // URLSession 요청 보내기
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("요청 실패: \(error.localizedDescription)")
                return
            }
            
            // 응답 처리
            guard let JSONdata = data else {return}
            
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(UserInfoStruct.self, from: JSONdata)
                self.userInfo = decodedData
            }catch{
                print(error)
            }
            semaphore.signal()
        }
        task.resume()
        
        semaphore.wait()
        let userEntity = NSEntityDescription.insertNewObject(forEntityName: "UserInfo", into: self.context)

        userEntity.setValue(self.userInfo.email, forKey: "email")
        userEntity.setValue(self.userInfo.password, forKey: "password")
        userEntity.setValue(self.userInfo.name, forKey: "name")
        userEntity.setValue(self.userInfo.phone, forKey: "phone")
        userEntity.setValue(self.userInfo.birthday, forKey: "birthday")
        userEntity.setValue(self.userInfo.safeMoney, forKey: "safeMoney")
        userEntity.setValue(self.userInfo.reject, forKey: "reject")
        
        //영구저장소에 반영
        do {
            try self.context.save()
            print("User Data saved successfully")

        } catch {
            print("Failed to save data: \(error)")
        }
            
        dismiss(animated: true)
    }
}

