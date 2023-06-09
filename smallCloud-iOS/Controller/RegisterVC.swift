//
//  SignUpVC.swift
//  smallCloud-iOS
//
//  Created by WS on 2023/05/29.
//

import UIKit
import CoreData

class RegisterVC: UIViewController {
    
    var context: NSManagedObjectContext{
            
        guard let app = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        return app.persistentContainer.viewContext
    }

    @IBOutlet weak var alertLbl: UILabel!
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var goLoginBtn: UIButton!

    var loginNavController: UINavigationController?
    let stackView = UIStackView()

    let emailFormFieldView = FormFieldView(text:"Email")
    let pwFormFieldView = FormFieldView(text:"Password")
    let nameFormFieldView = FormFieldView(text:"Name")
    let phoneFormFieldView = FormFieldView(text:"Phone")
    let registerButton = makeButton(withText: "회원가입")

    var userInfo:UserInfoStruct!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        layout()
    }
}

extension RegisterVC {
    
    func style() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .leading
        
        registerButton.addTarget(self, action: #selector(registerTapped), for: .primaryActionTriggered)
    }
    
    func layout() {
        stackView.addArrangedSubview(emailFormFieldView)
        stackView.addArrangedSubview(pwFormFieldView)
        stackView.addArrangedSubview(nameFormFieldView)
        stackView.addArrangedSubview(phoneFormFieldView)
        stackView.addArrangedSubview(registerButton)
        stackView.addArrangedSubview(goLoginBtn)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: welcomeLbl.bottomAnchor, constant: 40),
            emailFormFieldView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: emailFormFieldView.trailingAnchor, multiplier: 2),
            
            pwFormFieldView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: pwFormFieldView.trailingAnchor, multiplier: 2),
            
            nameFormFieldView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: nameFormFieldView.trailingAnchor, multiplier: 2),
            
            phoneFormFieldView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: phoneFormFieldView.trailingAnchor, multiplier: 2),
            
            registerButton.heightAnchor.constraint(equalTo: pwFormFieldView.heightAnchor),
            registerButton.widthAnchor.constraint(equalTo: pwFormFieldView.widthAnchor),
            goLoginBtn.centerXAnchor.constraint(equalTo: stackView.centerXAnchor)
        ])
    }
}

// MARK: - Actions
extension RegisterVC {
    
    @objc func registerTapped() {
        
        let semaphore = DispatchSemaphore(value: 0)
        guard let url = URL(string: "http://3.39.188.228:9090/account/signup") else {
            print("유효하지 않은 URL입니다.")
            return
        }
        
        //텍스트필드 빈값 검증
        guard let name = nameFormFieldView.textField.text,
              let email = emailFormFieldView.textField.text,
              let password = pwFormFieldView.textField.text,
              let phone = phoneFormFieldView.textField.text else { return }
        if name.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty {
            print("모든값을 채워야 합니다.")
            return
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
            
            alertLbl.textColor = .red
            alertLbl.text = "이미 존재하는 계정입니다"
            return
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
        
        //동물등록 페이지로 이동
        if let animalRegisterVC = storyboard?.instantiateViewController(withIdentifier: "AnimalRegisterView") as? AnimalRegisterVC{
            self.navigationController?.navigationItem.leftBarButtonItem?.isHidden = true
            self.navigationController?.pushViewController(animalRegisterVC, animated: true)
        }
    }
}

// MARK: - Factories
func makeButton(withText text: String) -> UIButton {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(text, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    button.titleLabel?.adjustsFontSizeToFitWidth = true
    button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    button.backgroundColor = UIColor(cgColor: CGColor(red: 109/255, green: 157/255, blue: 229/255, alpha: 1.0))
    button.layer.cornerRadius = 60/4
    return button
}
