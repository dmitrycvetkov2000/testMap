//
//  BottomSheetVC.swift
//  testMaps
//
//  Created by Дмитрий Цветков on 22.08.2023.
//

import UIKit

class BottomSheetVC: UIViewController {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var nameLabelText: String!
    var dateLabelText: String!
    var timeLabelText: String!
    var imageText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
}

extension BottomSheetVC {
    func configureVC() {
        view.backgroundColor = .white
        button.layer.cornerRadius = 20
        image.image = UIImage(named: imageText)
        nameLabel.text = nameLabelText
        dateLabel.text = dateLabelText
        timeLabel.text = timeLabelText
    }
}
