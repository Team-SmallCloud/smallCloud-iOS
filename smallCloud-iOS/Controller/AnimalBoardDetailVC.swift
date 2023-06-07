//
//  AnimalBoardDetailVC.swift
//  smallCloud-iOS
//
//  Created by WS on 2023/06/07.
//

import UIKit

class AnimalBoardDetailVC: UIViewController {


    @IBOutlet var mainImg: UIImageView!
    @IBOutlet var kindLbl: UILabel!
    @IBOutlet var genderLbl: UILabel!
    @IBOutlet var ageLbl: UILabel!
    @IBOutlet var weightLbl: UILabel!
    @IBOutlet var colorLbl: UILabel!
    @IBOutlet var neuteredLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var placeLbl: UILabel!
    @IBOutlet var phoneLbl: UILabel!
    @IBOutlet var detailLbl: UILabel!
    @IBOutlet var idLbl: UILabel!
    
    var animalInfo:WantedAnimal!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        kindLbl.text = animalInfo.kind
        genderLbl.text = animalInfo.gender
        ageLbl.text = String(animalInfo.age)+"살"
        weightLbl.text = String(animalInfo.weight)+"kg"
        colorLbl.text = animalInfo.color
        neuteredLbl.text = animalInfo.neutered ? "O":"X"
        dateLbl.text = animalInfo.hppdDate
        placeLbl.text = animalInfo.place
        phoneLbl.text = animalInfo.phone
        detailLbl.text = animalInfo.detail
        idLbl.text = animalInfo.NFC_id
        
        //guard let url = URL(string: animalInfo.shape) else { return }
        getImg(urlString: animalInfo.shape)
    }
    
    func getImg(urlString:String){

        let imgCacheKey = NSString(string:urlString)
        guard let imgUrl = URL(string:urlString) else { return  }

        //저장된 이미지가 있는 경우 캐시된 이미지를 불러옴
        if let cacaheImage = ImageCacheManager.shared.object(forKey: imgCacheKey){
            self.mainImg.image = cacaheImage
        }else{
            //이미지 불러오기
            DispatchQueue.global().async{
                guard let data = try? Data(contentsOf: imgUrl) else { return }
                guard let image = UIImage(data:data) else { return }
                DispatchQueue.main.async{
                    self.mainImg.image = image
                    //네트워크로 불러온 이미지 캐싱
                    ImageCacheManager.shared.setObject(image, forKey: imgCacheKey)
                }
            }
        }
    }
}


class ImageCacheManager {
    
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}
