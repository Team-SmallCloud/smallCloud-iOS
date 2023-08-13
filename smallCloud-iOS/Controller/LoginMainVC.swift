//
//  LoginMainVC.swift
//  smallCloud-iOS
//
//  Created by WS on 2023/05/25.
//

import UIKit
import Lottie

final class LoginMainVC: UIViewController {
    
    private let loginMainView = LoginMainView()
    
    override func loadView() {
        view = loginMainView
        print("loadView Called")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loginMainView.emailLoginBtn.addTarget(self, action: #selector(goResgisterVC), for: .touchUpInside)
        loginMainView.enterBtn.addTarget(self, action: #selector(changingToMainTabBar), for: .touchUpInside)
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
