

// kingFisher library method mean online image loading
//
//        if #available(iOS 16.0, *) {
//            let fileUrl = URL.documentsDirectory.appendingPathComponent(imgViewUUID).appendingPathExtension("png")
//
//            let placeholderImage = UIImage(named: "placeholderImage")
//            imageView.kf.setImage(with: fileUrl, placeholder: placeholderImage)
//        } else {
//            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//            let fileURL = documentsDirectory?.appendingPathComponent(imgViewUUID).appendingPathExtension("png")
//
//            let placeholderImage = UIImage(named: "placeholderImage")
//            imageView.kf.setImage(with: fileURL, placeholder: placeholderImage)
//        }



import UIKit
//import Kingfisher

class SearchBirdsDetailController: UIViewController, UITextFieldDelegate {
    
    private var birds: [UploadData]  = []
    private var bird: [ExpiredBirdsDetails] = []
    private var soldBird:[SoldBirdsDetails] = []
    
    private let managers = DatabaseManagers()
    private let managerss = DatabaseManagerss()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var sampleType: UILabel!
    @IBOutlet weak var certificateLbl: UILabel!
    @IBOutlet weak var birdId: UILabel!
    @IBOutlet weak var birdSpecie: UILabel!
    @IBOutlet weak var collectionLbl: UILabel!
    @IBOutlet weak var sexDetermination: UILabel!
    @IBOutlet weak var accuracyLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var buyerNameText: UITextField!
    @IBOutlet weak var dateTextFields: UITextField!
    
    @IBOutlet weak var buyerPhoneNumber: UITextField!
    
    @IBOutlet weak var soldorExpireDateTxt: UITextField!
    
    
    
    var imgViewUUID = ""
    
    var dataForNextViewController: UploadData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        
        //        self.ref = Database.database().reference()
        buyerNameText.delegate = self
        buyerPhoneNumber.delegate = self
        
        setupKeyboardHandling()
        setupTextField()
        
        
        ownerName.text = ("Owner Name :  \(self.dataForNextViewController.ownerName ?? "No Data")")
        sampleType.text = ("Sample Type :  \(self.dataForNextViewController.sampleType ?? "No Data")")
        certificateLbl.text = ("Certificate :  \(self.dataForNextViewController.certificateNo ?? "No Data")")
        birdId.text = ("Bird Id :  \( self.dataForNextViewController.birdId ?? "No Data")")
        birdSpecie.text = ("Bird Specie :  \(self.dataForNextViewController.birdSpecie ?? "No Data")")
        collectionLbl.text = ("Collection :  \(self.dataForNextViewController.collection ?? "No Data")")
        sexDetermination.text = ("Sex :  \(self.dataForNextViewController.sexDetermination ?? "No Data")")
        accuracyLbl.text = ("Accuracy :  \(self.dataForNextViewController.accuracy ?? "No Data")")
        dateLbl.text = ("Upload Date :  \(self.dataForNextViewController.datePicker ?? "No Data")")
        
        
        // offline image loading
        
        if #available(iOS 16.0, *) {
            let fileUrl = URL.documentsDirectory.appendingPathComponent(imgViewUUID).appendingPathExtension("png")
            
            // Load the image from the file URL
            if let image = UIImage(contentsOfFile: fileUrl.path) {
                imageView.image = image
            }
        } else {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let fileURL = documentsDirectory?.appendingPathComponent(imgViewUUID).appendingPathExtension("png")
            
            // Load the image from the file URL
            if let image = UIImage(contentsOfFile: fileURL?.path ?? "") {
                imageView.image = image
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        let tapGestureRecognizers = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        scrollView.addGestureRecognizer(tapGestureRecognizers)
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
    
    @IBAction func soldBtn(_ sender: Any) {
        
        
        guard !isEmptyTextField() else {
            Helpers.showAlert(message: "Please fill in all the fields.")
            return
        }
        let imageUpload = UUID().uuidString
        
        let user = SoldBird(accuracy: dataForNextViewController.accuracy!,
                            birdID: dataForNextViewController.birdId!,
                            birdSpecie: dataForNextViewController.birdSpecie!,
                            certificateNo: dataForNextViewController.certificateNo!,
                            collection: dataForNextViewController.collection!,
                            ownerName: dataForNextViewController.ownerName!,
                            sampleType: dataForNextViewController.sampleType!,
                            sexDetermination: dataForNextViewController.sexDetermination!,
                            uploadCurrentImage: imageUpload,
                            uploadDate: dataForNextViewController.datePicker!,
                            buyerName: buyerNameText.text!,
                            buyerPhoneNumber: buyerPhoneNumber.text!,
                            soldDate: soldorExpireDateTxt.text!)
        
        managerss.addUsers(user)
        saveImageToDocumentDirectory(imageUpload: imageUpload)
        Helpers.showAlert(message: "Data saved Successfully")
        clearAllFields()
        
    }
    
    func setupKeyboardHandling() {
        let textFields = [
            buyerNameText,
            buyerPhoneNumber,
            dateTextFields
        ]
        
        for textField in textFields {
            textField?.delegate = self
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case buyerNameText:
            buyerPhoneNumber.becomeFirstResponder()
        case buyerPhoneNumber:
            dateTextFields.becomeFirstResponder()
        case dateTextFields:
            dateTextFields.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    func setupTextField() {
        dateTextFields.isUserInteractionEnabled = true
        dateTextFields.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(textFieldTapped)))
    }
    
    @objc func textFieldTapped() {
        fillCurrentDateAndTime()
    }
    
    func fillCurrentDateAndTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd  HH:mm"
        let currentDateAndTime = dateFormatter.string(from: Date())
        dateTextFields.text = currentDateAndTime
    }
    
    func clearAllFields() {
        buyerNameText.text = ""
        buyerPhoneNumber.text = ""
        soldorExpireDateTxt.text = ""
    }
    
    
    func isEmptyTextField() -> Bool {
        let textFields = [
            buyerNameText,
            buyerPhoneNumber,
            soldorExpireDateTxt
        ]
        
        for textField in textFields {
            if let text = textField?.text, text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return true
            }
        }
        
        return false
    }
    
    @IBAction func expireBtn(_ sender: Any) {
        
        
        guard !isDateTextField() else {
            Helpers.showAlert(message: "Please enter the date.")
            return
        }
        let imageUpload = UUID().uuidString
        
        let user = ExpiredBirds(certificateNo: dataForNextViewController.certificateNo!,
                                accuracy: dataForNextViewController.accuracy!,
                                datePicker: dataForNextViewController.datePicker!,
                                sexDetermination: dataForNextViewController.sexDetermination!,
                                sampleType: dataForNextViewController.sampleType!,
                                birdSpecie: dataForNextViewController.birdSpecie!,
                                birdId: dataForNextViewController.birdId!,
                                collection: dataForNextViewController.collection!,
                                ownerName: dataForNextViewController.ownerName!,
                                imageUpload: imageUpload,
                                expiredDate: soldorExpireDateTxt.text!)
        
        saveImageToDocumentDirectory(imageUpload: imageUpload)
        managers.addUsers(user)
        
        
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
    
    func isDateTextField() -> Bool {
        let textFields = [
            soldorExpireDateTxt
        ]
        
        for textField in textFields {
            if let text = textField?.text, text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return true
            }
        }
        
        return false
    }
    
}
