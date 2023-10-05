//
//  SettingsViewController.swift
//  FottoMotto
//
//  Created by Berk Yeteroğlu on 27.09.2023.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toViewControllerVC", sender: nil)
        }
        catch{
            print("HATA ")
        }
        
    }
    

}
