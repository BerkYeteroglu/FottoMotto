//
//  UploadViewController.swift
//  FottoMotto
//
//  Created by Berk Yeteroğlu on 27.09.2023.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class UploadViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        image.addGestureRecognizer(tapGesture)
        image.isUserInteractionEnabled = true
    }
    
    @objc func openImagePicker() {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                image.image = selectedImage
            }
            picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ShareAPostButton(_ sender: Any) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let mediaFile = storageRef.child("images")
        
        if let data = image.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageRef = mediaFile.child("\(uuid).jpeg")
            
            imageRef.putData(data) { StorageMetadata, Error in
                if Error != nil {
                    self.ErrorCatch(errorTitle: "HATA", errorMessage: Error?.localizedDescription ?? "Beklenmedik bir hata oluştu")
                }
                else{
                    imageRef.downloadURL { url, error in
                        if error != nil {
                            self.ErrorCatch(errorTitle: "HATA", errorMessage: Error?.localizedDescription ?? "Beklenmedik bir hata oluştu.")
                        } else {
                            let urlString = url?.absoluteString
                            if let imageUrl = urlString {
                                let db = Firestore.firestore()
                                let firetorePost: [String: Any] = ["imageUrl": imageUrl, 
                                                                   "baslik": self.titleTextField.text!,
                                                                   "email": Auth.auth().currentUser!.email,
                                                                   "tarih": FieldValue.serverTimestamp()]
                                print(imageUrl)
                                db.collection("Post").addDocument(data: firetorePost) { Error in
                                    if Error != nil {
                                        self.ErrorCatch(errorTitle: "HATA", errorMessage: Error?.localizedDescription ?? "Beklenmedik bir hata oluştu")
                                    } else{
                                        self.image.image = UIImage(named: "UploadImage")
                                        self.titleTextField.text = ""
                                        self.tabBarController?.selectedIndex = 0
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func removeImageButtonTapped(_ sender: Any) {
        image.image = UIImage(named: "UploadImage")
    }
    
    func ErrorCatch(errorTitle: String, errorMessage: String){
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertOk)
        self.present(alert, animated: true)
    }
}
