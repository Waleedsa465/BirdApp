//
//  AddBirdsViewController.swift
//  BirdApp
//
//  Created by MacBook Pro on 27/12/2023.
//

import UIKit

//@available(iOS 16.0, *)
class AddBirdsViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var certificateNoTextField: UITextField!
    @IBOutlet weak var birdIDTextField: UITextField!
    @IBOutlet weak var ownerNameTextField: UITextField!
    @IBOutlet weak var birdSpecieTextField: UITextField!
    @IBOutlet weak var sampleTypeTextField: UITextField!
    @IBOutlet weak var collectionTextField: UITextField!
    @IBOutlet weak var sexDeterminedTextField: UITextField!
    @IBOutlet weak var accuracyTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    
    private let manager = DatabaseManager()
    
    var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 50

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        setupTextField()
        setupKeyboardHandling()

        // Add tap gesture recognizer to the imageView
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)

        let tapGestureRecognizers = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        scrollView.addGestureRecognizer(tapGestureRecognizers)

        // Create a spinner programmatically
        spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        spinner.center = view.center
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            scrollView.contentInset = contentInset
            scrollView.scrollIndicatorInsets = contentInset
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }

    func setupKeyboardHandling() {
        let textFields = [
            certificateNoTextField,
            birdIDTextField,
            ownerNameTextField,
            birdSpecieTextField,
            sampleTypeTextField,
            collectionTextField,
            sexDeterminedTextField,
            accuracyTextField,
            dateTextField
        ]

        for textField in textFields {
            textField?.delegate = self
        }
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case certificateNoTextField:
            birdIDTextField.becomeFirstResponder()
        case birdIDTextField:
            ownerNameTextField.becomeFirstResponder()
        case ownerNameTextField:
            birdSpecieTextField.becomeFirstResponder()
        case birdSpecieTextField:
            sampleTypeTextField.becomeFirstResponder()
        case sampleTypeTextField:
            collectionTextField.becomeFirstResponder()
        case collectionTextField:
            sexDeterminedTextField.becomeFirstResponder()
        case sexDeterminedTextField:
            accuracyTextField.becomeFirstResponder()
        case accuracyTextField:
            dateTextField.becomeFirstResponder()
        case dateTextField:
            dateTextField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }

    func setupTextField() {
        dateTextField.isUserInteractionEnabled = true
        dateTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(textFieldTapped)))
    }

    @objc func textFieldTapped() {
        fillCurrentDateAndTime()
    }

    func fillCurrentDateAndTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd   HH:mm:ss"
        let currentDateAndTime = dateFormatter.string(from: Date())
        dateTextField.text = currentDateAndTime
    }

    @objc func imageViewTapped() {
        showImagePicker()
    }

    func showImagePicker() {
        let alertController = UIAlertController(title: "Where you want to choose the image", message: nil, preferredStyle: .actionSheet)

        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            self?.openCamera()
        }

        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { [weak self] _ in
            self?.openGallery()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            // Handle the case where the camera is not available
        }
    }

    func openGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            imageView.image = selectedImage
        }

        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        guard let selectedImage = imageView.image else {
            Helpers.showAlert(message: "Please select an image.")
            return
        }
        
        guard let certificateNo = certificateNoTextField.text, !certificateNo.isEmpty else {
            Helpers.showAlert(message: "Certificate No textfield is empty")
            return
        }

        guard let birdID = birdIDTextField.text, !birdID.isEmpty else {
            Helpers.showAlert(message: "Bird ID textfield is empty")
            return
        }

        guard let ownerName = ownerNameTextField.text, !ownerName.isEmpty else {
            Helpers.showAlert(message: "Owner Name textfield is empty")
            return
        }

        guard let birdSpecie = birdSpecieTextField.text, !birdSpecie.isEmpty else {
            Helpers.showAlert(message: "Bird Specie textfield is empty")
            return
        }

        guard let sampleType = sampleTypeTextField.text, !sampleType.isEmpty else {
            Helpers.showAlert(message: "Sample Type textfield is empty")
            return
        }

        guard let collection = collectionTextField.text, !collection.isEmpty else {
            Helpers.showAlert(message: "Collection textfield is empty")
            return
        }

        guard let sexDetermined = sexDeterminedTextField.text, !sexDetermined.isEmpty else {
            Helpers.showAlert(message: "Sex Determined textfield is empty")
            return
        }

        guard let accuracy = accuracyTextField.text, !accuracy.isEmpty else {
            Helpers.showAlert(message: "Accuracy textfield is empty")
            return
        }

        guard let date = dateTextField.text, !date.isEmpty else {
            Helpers.showAlert(message: "Date textfield is empty")
            return
        }
        let imageUpload = UUID().uuidString

        let user = UserModel(certificateNo: certificateNo,
                                             accuracy: accuracy,
                                             datePicker: date,
                                             sexDetermination: sexDetermined,
                                             sampleType: sampleType,
                                             birdSpecie: birdSpecie,
                                             birdId: birdID,
                                             collection: collection,
                                             ownerName: ownerName,
                                             imageUpload: imageUpload)
        
        saveImageToDocumentDirectory(imageUpload: imageUpload)
        manager.addUser(user)
        
        Helpers.showAlert(message: "Data saved Successfully")
        clearAllFields()
        
    }
    
    func saveImageToDocumentDirectory(imageUpload: String){
        
        if #available(iOS 16.0, *) {
            let fileUrl = URL.documentsDirectory.appending(component: imageUpload).appendingPathExtension("png")
            if let data = imageView.image?.pngData(){
                do{
                    
                    try data.write(to: fileUrl)
                    print("Data Upload Successfully")
                    
                }catch{
                    print("Error While Uploading Image")
                }
            }else{
                print("Error ")
            }
        } else {
            // Fallback on earlier versions
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let fileURL = documentsDirectory?.appendingPathComponent(imageUpload).appendingPathExtension("png")
            if let data = imageView.image?.pngData(){
                do{
                    try data.write(to: fileURL!)
                    print("Data Upload Successfully")
                    
                }catch{
                    print("Error While Uploading Image")
                }
            }else{
                print("Error ")
            }
        }


        
    }
    

    

    
    func isEmptyTextField() -> Bool {
        let textFields = [
            certificateNoTextField,
            birdIDTextField,
            ownerNameTextField,
            birdSpecieTextField,
            sampleTypeTextField,
            collectionTextField,
            sexDeterminedTextField,
            accuracyTextField,
            dateTextField
        ]

        for textField in textFields {
            if let text = textField?.text, text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return true
            }
        }

        return false
    }

    func clearAllFields() {
        certificateNoTextField.text = ""
        birdIDTextField.text = ""
        ownerNameTextField.text = ""
        birdSpecieTextField.text = ""
        sampleTypeTextField.text = ""
        collectionTextField.text = ""
        sexDeterminedTextField.text = ""
        accuracyTextField.text = ""
        dateTextField.text = ""
        imageView.image = nil
    }


}
