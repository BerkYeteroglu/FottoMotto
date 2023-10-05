//
//  ViewController.swift
//  FottoMotto
//
//  Created by Berk Yeteroğlu on 26.09.2023.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func logInButton(_ sender: Any) {
        if emailTextField.text != nil && passwordTextField.text != nil {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { authResult, error in
                if error != nil{
                    self.ErrorCatch(errorTitle: "Hata", errorMessage: error?.localizedDescription ?? "Beklenmedik bir hata oluştu. Tekrar deneyiniz.")
                }
                else{
                    self.performSegue(withIdentifier: "toExploreVC", sender: nil)
                }
            }
        }
        else{
            ErrorCatch(errorTitle: "HATA", errorMessage: "Alanlar boş bırakılamaz")
        }
    }
    
    @IBAction func singUpButton(_ sender: Any) {
        if emailTextField.text != nil && passwordTextField.text != nil {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authResult, error in
                if error != nil {
                    self.ErrorCatch(errorTitle: "HATA", errorMessage: error?.localizedDescription ?? "Beklenmedik bir hata oluştu. Tekrar deneyiniz.")
                }
                else{
                    self.performSegue(withIdentifier: "toExploreVC", sender: nil)
                }
            }
            
        }else{
            ErrorCatch(errorTitle: "HATA", errorMessage: "Alanlar boş bırakılamaz")
        }
    }
    
    func ErrorCatch(errorTitle: String, errorMessage: String){
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertOk)
        self.present(alert, animated: true)
    }
}

