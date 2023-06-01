//
//  SignUpVC.swift
//  smallCloud-iOS
//
//  Created by WS on 2023/05/29.
//

import UIKit

class RegisterVC: UIViewController {
    
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var goLoginBtn: UIButton!

    var loginNavController: UINavigationController?
    let stackView = UIStackView()

    let emailFormFieldView = FormFieldView(text:"Email")
    let pwFormFieldView = FormFieldView(text:"Password")
    let nameFormFieldView = FormFieldView(text:"Name")
    let phoneFormFieldView = FormFieldView(text:"Phone")
    let registerButton = makeButton(withText: "회원가입")

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
            stackView.topAnchor.constraint(equalTo: welcomeLbl.bottomAnchor, constant: 30),
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
            guard let data = data else {return}
            let responseString = String(data: data, encoding: .utf8)
            print("응답 데이터: \(responseString ?? "")")
            
            //리턴된 json값을 key:value 형식으로 변환
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                
            }
        }
        task.resume()
        
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
