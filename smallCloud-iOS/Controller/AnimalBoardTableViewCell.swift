//
//  BoardTableViewCell.swift
//  smallCloud-iOS
//
//  Created by WS on 2023/06/06.
//

import UIKit

final class AnimalBoardTableViewCell: UITableViewCell {

   
    @IBOutlet var animalImgView: UIImageView!
    @IBOutlet var kindLbl: UILabel!
    @IBOutlet var dataLbl: UILabel!
    @IBOutlet var areaLbl: UILabel!
    @IBOutlet var gratuityLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
