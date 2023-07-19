//
//  LoginMainView.swift
//  smallCloud-iOS
//
//  Created by WS on 2023/07/19.
//

import UIKit
import Lottie

class LoginMainView:UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addView()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //고양이 애니메이션
    lazy var catAnimationView: LottieAnimationView = {
        let lottieAnimationView = LottieAnimationView(name: "catAndWire")
        lottieAnimationView.alpha = 1
        lottieAnimationView.loopMode = .loop
        lottieAnimationView.play()
        return lottieAnimationView
    }()
    
    // MARK: - 버튼객체 생성
    //앱 이름
    private let appTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    //앱 로고 이미지
    private let appLogo:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "TagMeLogo")
        return imageView
    }()
    //둘러보기 버튼
    let enterBtn:UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .white
        //레이블변경
        btn.setTitle("둘러보기", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.setTitleColor( .black, for: .normal)
        //둥근모서리, 파란그림자
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.clipsToBounds = false
        btn.layer.shadowColor = CGColor(red: 109/255, green: 157/255, blue: 229/255, alpha: 1.0)
        btn.layer.shadowOffset = CGSize(width: 0, height: 8)
        btn.layer.shadowOpacity = 0.4
        return btn
    }()
    //이메일로그인 버튼
    let emailLoginBtn:UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor(cgColor: CGColor(red: 109/255, green: 157/255, blue: 229/255, alpha: 1.0))
        //레이블변경
        btn.setTitle("이메일로 시작하기", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.setTitleColor(.white, for: .normal)
        //둥근모서리, 파란그림자
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.clipsToBounds = false
        btn.layer.shadowColor = CGColor(red: 109/255, green: 157/255, blue: 229/255, alpha: 1.0)
        btn.layer.shadowOffset = CGSize(width: 0, height: 8)
        btn.layer.shadowOpacity = 0.4
        return btn
    }()
    //둘러보기 버튼 그림자
    private let enterBtnShadow:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(cgColor: CGColor(red: 1, green: 1, blue: 1, alpha: 0.1))
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -5)
        view.layer.shadowOpacity = 0.08
        return view
    }()
    //이메일 로그인 버튼 그림자
    private let emailLoginBtnShadow:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(cgColor: CGColor(red: 1, green: 1, blue: 1, alpha: 0.1))
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -5)
        view.layer.shadowOpacity = 0.1
        return view
    }()
    //계정찾기 버튼
    private let forgotAccountBtn:UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("계정찾기", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(.darkGray, for: .normal)
        return btn
    }()

    
    // MARK: - 레이아웃관련 함수

    func addView(){
        //고양이 애니메이션 출력
        addSubview(catAnimationView)
        
        //앱이름 레이블 출력
        addSubview(appLogo)
        
        //계정찾기 버튼 출력
        addSubview(forgotAccountBtn)
        
        //둘러보기 버튼 출럭
        addSubview(enterBtn)
        
        //이메일 로그인 출력
        addSubview(emailLoginBtn)
    }
    
    //뷰의 제약사항 설정
    func setConstraint() {
        
        //앱이름 이미지
        appLogo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appLogo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            appLogo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10),
            appLogo.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -130) //catAnimationView.
        ])
        
        //계정찾기 버튼 출력
        forgotAccountBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            forgotAccountBtn.centerXAnchor.constraint(equalTo: centerXAnchor),
            forgotAccountBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60)
        ])
        
        //둘러보기 버튼
        enterBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            enterBtn.centerXAnchor.constraint(equalTo: centerXAnchor),
            enterBtn.bottomAnchor.constraint(equalTo: forgotAccountBtn.topAnchor, constant: -25),
            enterBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            enterBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        //이메일로그인 버튼
        emailLoginBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailLoginBtn.centerXAnchor.constraint(equalTo: centerXAnchor),
            emailLoginBtn.bottomAnchor.constraint(equalTo: enterBtn.topAnchor, constant: -25),
            emailLoginBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            emailLoginBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        //고양이 애니메이션
        catAnimationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            catAnimationView.topAnchor.constraint(equalTo: topAnchor),
            catAnimationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            catAnimationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            catAnimationView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}
