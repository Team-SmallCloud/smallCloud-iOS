//
//  AnimalRegisterVC.swift
//  smallCloud-iOS
//
//  Created by WS on 2023/06/07.
//

import UIKit
import CoreNFC

class AnimalRegisterVC: UIViewController,UITextFieldDelegate {

    @IBOutlet var welcomeLbl: UILabel!
    @IBOutlet var nfctxt: UITextField!
    @IBOutlet var nametxt: UITextField!
    @IBOutlet var kindtxt: UITextField!
    
    var session:NFCNDEFReaderSession?
    
    @IBAction func registerTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func NfcBtnTapped(_ sender: UIButton) {
        guard NFCNDEFReaderSession.readingAvailable else {
            let alertController = UIAlertController(
                title: "Scanning Not Supported",
                message: "This device doesn't support tag scanning.",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: true)
        session?.alertMessage = "NFC를 찾아 스캔해주세요"
        session?.begin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nfctxt.delegate = self
        nametxt.delegate = self
        kindtxt.delegate = self
        style()
    }
    
    
    func style() {
        nfctxt.borderStyle = .none
        nametxt.borderStyle = .none
        kindtxt.borderStyle = .none
    }
    
    //키보드 이외의 영역을 눌렀을 때 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //return을 눌렀을 때 키보드 내림
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AnimalRegisterVC: NFCNDEFReaderSessionDelegate {
    
    @objc func nfcBtnTapped(_ sender: Any) {
        guard NFCNDEFReaderSession.readingAvailable else {
            let alertController = UIAlertController(
                title: "Scanning Not Supported",
                message: "This device doesn't support tag scanning.",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: true)
        session?.alertMessage = "NFC를 찾아 스캔해주세요"
        session?.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("NFC발견")
        //첫 메세지만 추출
        guard let a = messages.first?.records.first else { return }
        
        if let nfcString = String(data:a.payload, encoding: .ascii){
            let startIndex = nfcString.index(nfcString.startIndex, offsetBy: 3)
            let substring = nfcString[startIndex...]
            nfctxt.text = String(substring)
        }
    }
}

