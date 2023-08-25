//
//  AlertManager.swift
//  testMaps
//
//  Created by Дмитрий Цветков on 25.08.2023.
//

import UIKit

class AlertManager {
    var alert: UIAlertController = UIAlertController()
    
    func configureAlertController(on vc: UIViewController, title: String, message: String?) {
        alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) {_ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        vc.present(self.alert, animated: true)
    }
}
