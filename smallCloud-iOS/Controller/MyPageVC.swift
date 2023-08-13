//
//  myPageVC.swift
//  smallCloud-iOS
//
//  Created by WS on 2023/06/05.
//

import UIKit
import CoreData

final class MyPageVC: UIViewController {

    var context: NSManagedObjectContext{
            
        guard let app = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        return app.persistentContainer.viewContext
    }
    @IBOutlet var headerView: UIView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var phoneLbl: UILabel!
    @IBOutlet var gpsLbl: UILabel!
    @IBOutlet var safeMoneyLbl: UILabel!
    @IBOutlet var soonMoneyLbl: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var moneyView: UIView!
    @IBOutlet var chargeBtn: UIButton!
    @IBOutlet var moneyLogBtn: UIButton!
    
    
    struct Item {
        let text: String
    }

    // 텍스트 데이터를 담을 배열 생성
    var items: [Item] = [
        Item(text: "공지사항"),
        Item(text: "고객센터"),
        Item(text: "설정")
    ]
    
    var itemsImage: [Item] = [
        Item(text: "noticeLogo"),
        Item(text: "headsetLogo"),
        Item(text: "settingsLogo")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        //tableView.tableHeaderView = headerView
        
        style()
        
        let fetchRequest: NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
        do{
            let userInfo = try context.fetch(fetchRequest)
            //로그인 상태
            if userInfo.first != nil {
                nameLbl.text = userInfo.first?.name
                phoneLbl.text = formatPhoneNumber(userInfo.first?.phone)
                gpsLbl.text = userInfo.first?.juso ?? "서울 노원"
                safeMoneyLbl.text = String (userInfo.first?.safeMoney ?? 0) + "원"
            }//비로그인 상태
            else {
                nameLbl.text = "로그인이 필요합니다"
                phoneLbl.isHidden = true
                gpsLbl.isHidden = true
            }
        }
        catch{
            print("Can't Find userInfo")
        }
    }
    
    func style(){
        
        //예치금 박스 뷰
        moneyView.layer.masksToBounds = true
        moneyView.layer.cornerRadius = 16
        moneyView.layer.borderColor = UIColor.priamry1.cgColor
        moneyView.layer.borderWidth = 2
        
        //충전 버튼
        let resizedImg1 = UIImage(named:"coinLogo")?.resize(to: CGSize(width: 22, height: 22))
        chargeBtn.setImage(resizedImg1 ,for:.normal)
        
        //내역확인 버튼
        let resizedImg2 = UIImage(named:"logLogo")?.resize(to: CGSize(width: 22, height: 22))
        moneyLogBtn.setImage(resizedImg2, for: .normal)
    }
    
    //10자리 String을 핸드폰번호 형식으로 변환하여 반환
    func formatPhoneNumber(_ number: String?) -> String {
        
        guard let number = number else { return "" }
        var formattedNumber = ""
        
        // 숫자 이외의 문자 제거
        let digits = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        // 핸드폰 번호 형식으로 변환
        if digits.count == 10 {
            let areaCode = digits.prefix(3)
            let firstPart = digits.dropFirst(3).prefix(4)
            let secondPart = digits.dropFirst(6)
            formattedNumber = "\(areaCode)-\(firstPart)-\(secondPart)"
        } else if digits.count == 11 {
            let areaCode = digits.dropFirst(0).prefix(3)
            let firstPart = digits.dropFirst(3).prefix(4)
            let secondPart = digits.dropFirst(7)
            formattedNumber = "\(areaCode)-\(firstPart)-\(secondPart)"
        }
        
        return formattedNumber
    }

}


extension MyPageVC:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        print(item.text)
    }
}

extension MyPageVC:UITableViewDataSource{

    //셀의 총 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    //셀 반환
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let item = items[indexPath.row]
        cell.textLabel?.text = item.text
        
        
        cell.imageView?.contentMode = .scaleAspectFit
        let cellImg = UIImage(named: itemsImage[indexPath.row].text)
        let resizedImage = cellImg?.resize(to: CGSize(width: 22, height: 22))
        cell.imageView?.image = resizedImage

        
        return cell
    }
}

extension UIImage {
    //이미지 리사이징
    func resize(to newSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let image = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
        return image
    }
}
