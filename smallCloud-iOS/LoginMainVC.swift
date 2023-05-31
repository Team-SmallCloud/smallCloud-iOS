//
//  LoginMainVC.swift
//  smallCloud-iOS
//
//  Created by WS on 2023/05/25.
//

import UIKit
import Lottie

class LoginMainVC: UIViewController {

    //고양이 애니메이션
    private let catAnimationView: LottieAnimationView = {
        let lottieAnimationView = LottieAnimationView(name: "catAndWire")
        return lottieAnimationView
    }()
    
    //앱 이름
    let appTitleLabel = UILabel()
    
    //둘러보기 버튼
    let enterBtn = UIButton(type: .system)
    //이메일로그인 버튼
    let emailLoginBtn = UIButton(type: .system)
    //계정찾기 버튼
    let forgotAccountBtn = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //고양이 애니메이션 출력
        view.addSubview(catAnimationView)
        catAnimationView.frame = view.bounds
        catAnimationView.center = CGPoint(x: view.center.x, y: view.center.y - 70)
        catAnimationView.alpha = 1
        catAnimationView.loopMode = .loop
        catAnimationView.play()

        //앱이름 레이블 출력
        view.addSubview(appTitleLabel)
        self.appTitleLabel.text = "(서비스 이름)"
        appTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appTitleLabel.bottomAnchor.constraint(equalTo: catAnimationView.centerYAnchor, constant: -130)
        ])
        appTitleLabel.font = UIFont.boldSystemFont(ofSize: 30)

        
        //계정찾기 버튼 출력
        view.addSubview(forgotAccountBtn)
        //forgotAccountBtn.backgroundColor = .red
        forgotAccountBtn.setTitle("계정찾기", for: .normal)
        forgotAccountBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        forgotAccountBtn.setTitleColor(.darkGray, for: .normal)
        //오토레이아웃
        forgotAccountBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            forgotAccountBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forgotAccountBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ])
        
        //둘러보기 버튼 출력
        view.addSubview(enterBtn)
        enterBtn.backgroundColor = .white
        //레이블변경
        enterBtn.setTitle("둘러보기", for: .normal)
        enterBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        enterBtn.setTitleColor( .black, for: .normal)
        //외형변경
        enterBtn.layer.cornerRadius = 10
        enterBtn.layer.masksToBounds = true
        enterBtn.clipsToBounds = false
        enterBtn.layer.shadowColor = CGColor(red: 109/255, green: 157/255, blue: 229/255, alpha: 1.0)
        enterBtn.layer.shadowOffset = CGSize(width: 0, height: 8)
        enterBtn.layer.shadowOpacity = 0.4
        //오토레이아웃
        enterBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            enterBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterBtn.bottomAnchor.constraint(equalTo: forgotAccountBtn.topAnchor, constant: -20),
            enterBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            enterBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        enterBtn.addTarget(self, action: #selector(changingToMainTabBar), for: .touchUpInside)
        
        //이메일로그인 버튼 출력
        view.addSubview(emailLoginBtn)
        emailLoginBtn.backgroundColor = UIColor(cgColor: CGColor(red: 109/255, green: 157/255, blue: 229/255, alpha: 1.0))
        //레이블변경
        emailLoginBtn.setTitle("이메일로 시작하기", for: .normal)
        emailLoginBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        emailLoginBtn.setTitleColor(.white, for: .normal)
        //외형변경
        emailLoginBtn.layer.cornerRadius = 10
        emailLoginBtn.layer.masksToBounds = true
        emailLoginBtn.clipsToBounds = false
        emailLoginBtn.layer.shadowColor = CGColor(red: 109/255, green: 157/255, blue: 229/255, alpha: 1.0)
        emailLoginBtn.layer.shadowOffset = CGSize(width: 0, height: 8)
        emailLoginBtn.layer.shadowOpacity = 0.4
        //오토레이아웃
        emailLoginBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailLoginBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailLoginBtn.bottomAnchor.constraint(equalTo: enterBtn.topAnchor, constant: -20),
            emailLoginBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailLoginBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        emailLoginBtn.addTarget(self, action: #selector(goResgisterVC), for: .touchUpInside)
        
    }
    
    @objc func changingToMainTabBar(){
        
        //로딩 애니메이션
        let loadingAnimationView = LottieAnimationView(name: "loading-burst")
        view.addSubview(loadingAnimationView)
        loadingAnimationView.frame = view.bounds
        loadingAnimationView.backgroundColor = .white
        loadingAnimationView.center = CGPoint(x: view.center.x, y: view.center.y)
        loadingAnimationView.alpha = 1
        loadingAnimationView.contentMode = .scaleAspectFill
        loadingAnimationView.loopMode = .playOnce
        loadingAnimationView.play{ _ in
            //애니메이션이 끝나면
            //root스토리보드를 로그인SBd에서 메인SB로 변경
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let mainTC = storyboard.instantiateViewController(withIdentifier: "MainTabBar") as? UITabBarController else { return }
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTC, animated: true)
        }
    }
    
    @objc func goResgisterVC(){

        let navController = UINavigationController()
        guard let registerVC = self.storyboard?.instantiateViewController(withIdentifier:"RegisterView") else { return }

        navController.viewControllers = [registerVC]
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true){
            self.changingToMainTabBar()
        }
    }
}
