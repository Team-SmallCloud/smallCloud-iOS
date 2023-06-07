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
    var wantedAnimalData:[WantedAnimal]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if segment.selectedSegmentIndex == 0 {
            getAnimalData()
        }
        else{
            getProtectAnimalData()
        }
    }
    
    
    @IBAction func segmentTapped(_ sender: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            getAnimalData()
        }
        else{
            getProtectAnimalData()
        }
    }
    
    func getAnimalData(){
        
        wantedAnimalData = [
            WantedAnimal(id: 1, name: "인절미", kind: "골든리트리버", NFC_id: "410100012534881", owner_id: 38, gender: "F", shape: "https://singlesumer.com/files/attach/images/141/247/126/9411e86e6c392caf52ffb06e64b63489.jpg", place: "월계동", gratuity: 70, hppdDate:"20230606", weight:15, phone: "010-1234-1234", age: 1, color: "갈색", detail: "성격이 매우 착하고 밝은 성격이며 사람을 잘 따릅니다. 꼭 찾아주세요..", neutered:false),
            WantedAnimal(id: 2, name: "앙꼬", kind: "한국 고양이", NFC_id: "410100012534882", owner_id: 1, gender: "F", shape: "http://www.animal.go.kr/files/shelter/2023/05/202305301705481.jpg", place: "공릉동", gratuity: 130, hppdDate:"20230605", weight:7, phone: "010-1234-1234", age: 1, color: "갈색/흰색", detail: "사람을 경계합니다.", neutered:true),
            WantedAnimal(id: 2, name: "츄츄", kind: "시츄", NFC_id: "410100012534883", owner_id: 2, gender: "F", shape: "http://www.animal.go.kr/files/shelter/2023/05/202305211305125.jpg", place: "중계동", gratuity: 150, hppdDate:"20230604", weight:6, phone: "010-1234-1234", age: 1, color: "흰색", detail: "꼭 찾아주세요", neutered:true),
            WantedAnimal(id: 2, name: "스노우", kind: "말티즈", NFC_id: "410100012534882", owner_id: 3, gender: "F", shape: "http://www.animal.go.kr/files/shelter/2023/05/202305211305769.jpg", place: "태릉입구", gratuity: 800, hppdDate:"20230601", weight:8, phone: "010-1234-1234", age: 1, color: "흰색", detail: "매우 밝고 사람을 잘 따릅니다. 꼭 찾아주세요..", neutered:true)
        ]
        self.tableView.reloadData()
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
        
        if segment.selectedSegmentIndex == 0 {
            return wantedAnimalData?.count ?? 0
        }
        else{
            return animalData?.response.body.items.item.count ?? 0
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "animalCell", for: indexPath) as! AnimalBoardTableViewCell
        
        //실종동물
        if segment.selectedSegmentIndex == 0 {
            cell.kindLbl.text = wantedAnimalData?[indexPath.row].kind
            cell.dataLbl.text = wantedAnimalData?[indexPath.row].hppdDate
            cell.areaLbl.text = wantedAnimalData?[indexPath.row].place
            cell.gratuityLbl.text = String(wantedAnimalData![indexPath.row].gratuity)+"만원"
            
//            //썸네일
//            guard let imgUrl = URL(string: wantedAnimalData?[indexPath.row].shape ?? "") else { return cell }
//            DispatchQueue.global().async{
//                guard let data = try? Data(contentsOf: imgUrl) else { return }
//                guard let image = UIImage(data:data) else { return }
//                DispatchQueue.main.async {
//                    cell.animalImgView.image = image
//                }
//            }
//
            let imgCacheKey = NSString(string:wantedAnimalData?[indexPath.row].shape ?? "")
            guard let imgUrl = URL(string:wantedAnimalData?[indexPath.row].shape ?? "") else { return cell}

            //저장된 이미지가 있는 경우 캐시된 이미지를 불러옴
            if let cacaheImage = ImageCacheManager.shared.object(forKey: imgCacheKey){
                cell.animalImgView.image = cacaheImage
            }else{
                //이미지 불러오기
                DispatchQueue.global().async{
                    guard let data = try? Data(contentsOf: imgUrl) else { return }
                    guard let image = UIImage(data:data) else { return }
                    DispatchQueue.main.async{
                        cell.animalImgView.image = image
                        //네트워크로 불러온 이미지 캐싱
                        ImageCacheManager.shared.setObject(image, forKey: imgCacheKey)
                    }
                }
            }

        }
        //보호동물
        else{
            cell.kindLbl.text = animalData?.response.body.items.item[indexPath.row].kindCd
            cell.dataLbl.text = animalData?.response.body.items.item[indexPath.row].happenDt
            let dong = animalData?.response.body.items.item[indexPath.row].happenPlace.prefix(4)
            cell.areaLbl.text = String(dong!)
            cell.gratuityLbl.text = "-"
            
            let imgCacheKey = NSString(string:animalData?.response.body.items.item[indexPath.row].popfile ?? "")
            guard let imgUrl = URL(string:animalData?.response.body.items.item[indexPath.row].popfile ?? "") else { return cell}

            //저장된 이미지가 있는 경우 캐시된 이미지를 불러옴
            if let cacaheImage = ImageCacheManager.shared.object(forKey: imgCacheKey){
                cell.animalImgView.image = cacaheImage
            }else{
                //이미지 불러오기
                DispatchQueue.global().async{
                    guard let data = try? Data(contentsOf: imgUrl) else { return }
                    guard let image = UIImage(data:data) else { return }
                    DispatchQueue.main.async{
                        cell.animalImgView.image = image
                        //네트워크로 불러온 이미지 캐싱
                        ImageCacheManager.shared.setObject(image, forKey: imgCacheKey)
                    }
                }
            }

        }
        return cell
    }
    
    //segue가 동작하기 전 호출
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let dest = segue.destination as? AnimalBoardDetailVC else {return}
        let myIndexPath = tableView.indexPathForSelectedRow!
        let row = myIndexPath.row
        dest.animalInfo = wantedAnimalData?[row]
    }

}
