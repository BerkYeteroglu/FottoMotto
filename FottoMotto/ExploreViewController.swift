//
//  ExploreViewController.swift
//  FottoMotto
//
//  Created by Berk Yeteroğlu on 27.09.2023.
//

import UIKit
import Firebase
import SDWebImage

class ExploreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var ExplorerTableView: UITableView!
    var emailArray = [String]()
    var imageArray = [String]()
    var titleArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ExplorerTableView.dataSource = self
        ExplorerTableView.delegate = self
        getFirebaseData()
    }
    
    func getFirebaseData(){
        let db = Firestore.firestore()
        
        db.collection("Post").order(by: "tarih", descending: true )
            .addSnapshotListener { snapshot, error in
            if error != nil{
                self.errorCatch(errorTitle: "HATA", errorMessage: error?.localizedDescription ?? "Beklenmedik bir hata oldu ")
            }else{
                if snapshot?.isEmpty != true && snapshot != nil{
                    self.imageArray.removeAll(keepingCapacity: false)
                    self.emailArray.removeAll(keepingCapacity: false)
                    self.titleArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents{
                        if let imageUrl = document.get("imageUrl") as? String{
                            self.imageArray.append(imageUrl)
                        }
                        
                        if let title = document.get("baslik") as? String{
                            self.titleArray.append(title)
                        }
                        
                        if let email = document.get("email") as? String{
                            self.emailArray.append(email)
                        }
                    }
                    self.ExplorerTableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ExplorerTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ExploreCell
        cell.postImageView.sd_setImage(with: URL(string: self.imageArray[indexPath.row ]) )
        cell.postMailText.text = emailArray[indexPath.row]
        cell.titleTextField.text = titleArray[indexPath.row]
        return cell
    }
    
    func errorCatch(errorTitle: String, errorMessage: String){
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertOk)
        self.present(alert, animated: true)
    }

}
