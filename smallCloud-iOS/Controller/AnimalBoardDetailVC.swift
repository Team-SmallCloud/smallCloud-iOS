//
//  AnimalBoardDetailVC.swift
//  smallCloud-iOS
//
//  Created by WS on 2023/06/07.
//

import UIKit

final class AnimalBoardDetailVC: UIViewController {


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
    @IBOutlet var detailLbl: UITextView!
    @IBOutlet var idLbl: UILabel!
    
    var animalInfo_WantedAnimal:WantedAnimal?
    var animalInfo_AniamlInfo:AnimalInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var neuterYn = false
        if animalInfo_AniamlInfo?.sexCd == "Y" { neuterYn = true }
        
        kindLbl.text = animalInfo_WantedAnimal?.kind ?? animalInfo_AniamlInfo?.kindCd
        genderLbl.text = animalInfo_WantedAnimal?.gender ?? animalInfo_AniamlInfo?.sexCd
        ageLbl.text = ((animalInfo_WantedAnimal?.age ?? animalInfo_AniamlInfo?.age) ?? "-")
        weightLbl.text = ((animalInfo_WantedAnimal?.weight ?? animalInfo_AniamlInfo?.weight) ?? "-")
        colorLbl.text = animalInfo_WantedAnimal?.color ?? animalInfo_AniamlInfo?.colorCd
        neuteredLbl.text = animalInfo_WantedAnimal?.neutered ?? neuterYn ? "O":"X"
        dateLbl.text = animalInfo_WantedAnimal?.hppdDate ?? animalInfo_AniamlInfo?.happenDt
        placeLbl.text = animalInfo_WantedAnimal?.place ?? animalInfo_AniamlInfo?.happenPlace
        phoneLbl.text = animalInfo_WantedAnimal?.phone ?? animalInfo_AniamlInfo?.officetel
        detailLbl.text = animalInfo_WantedAnimal?.detail ?? animalInfo_AniamlInfo?.specialMark
        idLbl.text = animalInfo_WantedAnimal?.NFC_id ?? "-"
        
        //guard let url = URL(string: animalInfo.shape) else { return }
        getImg(urlString: animalInfo_WantedAnimal?.shape ?? animalInfo_AniamlInfo?.popfile)
    }
    
    func getImg(urlString:String?){
        
        guard let urlString = urlString else { return }
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
