//
//  SignUpVC.swift
//  smallCloud-iOS
//
//  Created by WS on 2023/05/29.
//

import UIKit
import CoreData

final class RegisterVC: UIViewController {

    @IBOutlet weak var alertLbl: UILabel!
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var goLoginBtn: UIButton!

    var registerManager = RegisterManager()
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

        //텍스트필드 빈값 검증
        guard let name = nameFormFieldView.textField.text,
              let email = emailFormFieldView.textField.text,
              let password = pwFormFieldView.textField.text,
              let phone = phoneFormFieldView.textField.text else { return }
        if name.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty {
            print("모든값을 채워야 합니다.")
            return
        }
        
        guard registerManager.getRegister(name: name, email: email, password: password, phone: phone) else {             alertLbl.textColor = .red
            alertLbl.text = "회원가입에 실패했습니다"
            return
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
