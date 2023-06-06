//
//  ViewController.swift
//  smallCloud-iOS
//
//  Created by WS on 2023/04/19.
//

import UIKit

class AnimalBoardVC: UIViewController {

    
    @IBOutlet var gpsBtn: UIButton!
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var segment: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    
    var animalData:AnimalResponse?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        getProtectAnimalData()
    }


    func getProtectAnimalData(){
        
        let baseURL = "http://apis.data.go.kr/1543061/abandonmentPublicSrvc/abandonmentPublic"
        
        // URL 생성
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: "serviceKey", value: Bundle.main.animalApiKey),
            URLQueryItem(name: "upr_cd", value: "6110000"),
            URLQueryItem(name: "org_cd", value: "3100000"),
            URLQueryItem(name: "numOfRows", value: "5"),
            URLQueryItem(name: "_type", value: "json")
        ]
        guard let url = urlComponents?.url else { return }
        
        //GET요청
        let request = URLRequest(url: url)
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
                let decodedData = try decoder.decode(AnimalResponse.self, from: JSONdata)
                self.animalData = decodedData
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }catch{
                print(error)
                return
            }
        }
        task.resume()
        
    }
}

extension AnimalBoardVC: UITableViewDelegate{
    
}

extension AnimalBoardVC: UITableViewDataSource{
    
    //테이블뷰 셀의 총 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animalData?.response.body.items.item.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "animalCell", for: indexPath) as! AnimalBoardTableViewCell
        
        
        cell.kindLbl.text = animalData?.response.body.items.item[indexPath.row].kindCd
        cell.dataLbl.text = animalData?.response.body.items.item[indexPath.row].happenDt
        let dong = animalData?.response.body.items.item[indexPath.row].happenPlace.prefix(4)
        cell.areaLbl.text = String(dong!)
        cell.gratuityLbl.text = "-"
        
        //썸네일
        guard let imgUrl = URL(string: animalData?.response.body.items.item[indexPath.row].popfile ?? "") else { return cell }
        DispatchQueue.global().async{
            guard let data = try? Data(contentsOf: imgUrl) else { return }
            guard let image = UIImage(data:data) else { return }
            DispatchQueue.main.async {
                cell.animalImgView.image = image
            }
        }
        
        return cell
    }


}
