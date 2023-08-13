//
//  LoginVC.swift
//  smallCloud-iOS
//
//  Created by WS on 2023/05/31.
//

import UIKit

final class LoginVC: UIViewController {

    @IBOutlet weak var loginLbl: UILabel!
    let stackView = UIStackView()
    let alertLbl = UILabel()
    
    let emailFormFieldView = FormFieldView(text:"Email", true)
    let pwFormFieldView = FormFieldView(text:"Password", true)
    let loginButton = makeButton(withText: "로그인")
    let loginManager = LoginManager()
    var loginNavController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
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
        view.addSubview(alertLbl)
        
        alertLbl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emailFormFieldView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: emailFormFieldView.trailingAnchor, multiplier: 2),
            
            pwFormFieldView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: pwFormFieldView.trailingAnchor, multiplier: 2),
            
            loginButton.heightAnchor.constraint(equalTo: pwFormFieldView.heightAnchor),
            loginButton.widthAnchor.constraint(equalTo: pwFormFieldView.widthAnchor),
            
            alertLbl.centerXAnchor.constraint(equalTo: loginLbl.centerXAnchor),
            alertLbl.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -20)
        ])
    }
}

// MARK: - Actions
extension LoginVC {
    
    @objc func loginBtnTapped() {
        
        //텍스트필드 빈값 검증
        guard let email = emailFormFieldView.textField.text,
              let password = pwFormFieldView.textField.text else { return }
        if email.isEmpty || password.isEmpty {
            print("모든값을 채워야 합니다.")
            return
        }
        
        guard loginManager.getLogin(email: email, password: password) else {
            //로그인 실패시
            self.alertLbl.textColor = .red
            self.alertLbl.text = "로그인 실패"
            return
        }
            
        dismiss(animated: true)
    }
}

