//
//  NfcTagVC.swift
//  smallCloud-iOS
//
//  Created by WS on 2023/06/02.
//

import UIKit
import Lottie
import CoreNFC

final class NfcTagVC: UIViewController, NFCNDEFReaderSessionDelegate {

    //시그널 애니메이션
    private let signalAnimationView: LottieAnimationView = {
        let lottieAnimationView = LottieAnimationView(name: "nfc-signal")
        return lottieAnimationView
    }()
    
    var session:NFCNDEFReaderSession?
    
    //NFCCore호출 버튼
    let nfcBtn = UIButton(type: .system)
    //NFC버튼배경
    let circleView = CircleView()
    //label 추가
    let noticeLbl = UILabel()
    
    
    
    @objc func nfcBtnTapped(_ sender: Any) {
        //NFC지원여부 확인, iOS11부터 지원
        guard NFCNDEFReaderSession.readingAvailable else {
            let alertController = UIAlertController(
                title: "Scanning Not Supported",
                message: "This device doesn't support tag scanning.",
                preferredStyle: .alert
            )
            return
        }
        //NFCNDEFReaderSession객체 생성
        session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: true)
        session?.alertMessage = "NFC를 찾아 스캔해주세요"
        //NFC감지 시작
        session?.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        //NFC의 첫 레코드 메시지만 추출
        guard let nfcId = messages.first?.records.first else { return }
        
        if let nfcIdString = String(data:nfcId.payload, encoding: .ascii){
            
            if let navController = self.tabBarController?.viewControllers?[0] as? UINavigationController,
                let destinationVC = navController.topViewController as? AnimalBoardVC {
                
                //앞 en문자열 제거
                let startIndex = nfcIdString.index(nfcIdString.startIndex, offsetBy: 3)
                let substring = nfcIdString[startIndex...]
                destinationVC.findNfcID = String(substring)
            }
            //첫번째 탭바로 이동
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        nfcBtn.addTarget(self, action: #selector(nfcBtnTapped(_:)), for: .primaryActionTriggered)
        guard session == nil else { return }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //nfc창이 닫힐 때 마다 다시 띄울 수 있게 초기화
        session = nil
    }
    
    func setLayout(){
        
        //애니메이션 설정
        view.addSubview(signalAnimationView)
        signalAnimationView.frame = CGRect(x: 0, y: 0, width: view.bounds.width * 1.6, height: view.bounds.height * 1.6)
        signalAnimationView.center = CGPoint(x: view.center.x, y: view.center.y)
        signalAnimationView.alpha = 1
        signalAnimationView.loopMode = .loop
        signalAnimationView.play()
        
        
        view.addSubview(circleView)
        view.addSubview(nfcBtn)
        view.addSubview(noticeLbl)
        
        //NFC 버튼 배치
        nfcBtn.setImage(UIImage(named:"dog-foot"), for: .normal)
        //nfcBtn.tintColor = UIColor(cgColor: CGColor(red: 86/255, green: 192/255, blue: 244/255, alpha: 1.0))
        nfcBtn.tintColor = UIColor(cgColor: UIColor.priamry1.cgColor)
        
        //버튼 배경 원
        //circleView.layer.cornerRadius = circleView.frame.size.width / 2  //왜 안되는거야
        circleView.backgroundColor = UIColor.white
        
        //설명레이블
        noticeLbl.text = "버튼을 눌러 태그 해보세요"
        noticeLbl.font = UIFont.boldSystemFont(ofSize: 25)
        
        //오토레이아웃
        nfcBtn.translatesAutoresizingMaskIntoConstraints = false
        circleView.translatesAutoresizingMaskIntoConstraints = false
        noticeLbl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //nfc버튼
            nfcBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nfcBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            //nfc버튼 배경
            circleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            circleView.widthAnchor.constraint(equalTo: nfcBtn.widthAnchor),
            circleView.heightAnchor.constraint(equalTo: nfcBtn.heightAnchor),
            
            //설명레이블
            noticeLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 140),
            noticeLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])


    }
}

class CircleView: UIView {
    //자동으로 원을 그리도록 함
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
    }
}
