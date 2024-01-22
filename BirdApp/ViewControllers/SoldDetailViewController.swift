//
//  SoldDetailViewController.swift
//  BirdsApp
//
//  Created by MacBook Pro on 20/12/2023.
//

import UIKit

class SoldDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buyerName: UILabel!
    @IBOutlet weak var buyerPhoneNumber: UILabel!
    @IBOutlet weak var certificateNo: UILabel!
    @IBOutlet weak var birdSpecieLbl: UILabel!
    @IBOutlet weak var birdIdLBL: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var sampleType: UILabel!
    @IBOutlet weak var collectionLabel: UILabel!
    @IBOutlet weak var sexDetermination: UILabel!
    @IBOutlet weak var accuracyLbl: UILabel!
    @IBOutlet weak var buyDate: UILabel!
    @IBOutlet weak var uploadDate: UILabel!
    

    var imgViewUUID = ""
    var imgView = ""
    var soldData: SoldBirdsDetails!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        
        
        buyerName.text = ("Buyer Name : \(self.soldData.buyerName ?? "No Data Found")")
        buyerPhoneNumber.text = ("PH : \(self.soldData.buyerPhoneNumber ?? "No Data Found")")
        certificateNo.text = ("Certificate : \(self.soldData.certificateNo ?? "No Data Found")")
        birdSpecieLbl.text = ("Bird Specie : \(self.soldData.birdSpecie ?? "No Data Found")")
        birdIdLBL.text = ("Bird Id : \(self.soldData.birdID ?? "No Data Found" )")
        ownerName.text = ("Owner Name : \(self.soldData.ownerName ?? "No Data Found")")
        sampleType.text = ("Sample Type : \(self.soldData.sampleType ?? "No Data Found")")
        collectionLabel.text = ("Collection : \(self.soldData.collection ?? "No Data Found")")
        sexDetermination.text = ("Sex : \(self.soldData.sexDetermination ?? "No Data Found")")
        accuracyLbl.text = ("Accuracy : \(self.soldData.accuracy ?? "No Data Found")")
        buyDate.text = ("Sold Date : \(self.soldData.soldDate ?? "No Data Found")")
        uploadDate.text = ("Data Date : \(self.soldData.uploadDate ?? "No Data Found")")
        
        imgView = self.soldData.uploadCurrentImage ?? "No Data Found"
        
        
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

        

    }
    
    
    @IBAction func captureScreenshotTapped(_ sender: UIButton) {
        // Capture the screenshot
        if let screenshot = captureScreenshot() {
            // Save or use the screenshot as needed
            // For example, you can save it to the photo library
            UIImageWriteToSavedPhotosAlbum(screenshot, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }

    func captureScreenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshot
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // Handle the error if saving the image failed
            print("Error saving image: \(error.localizedDescription)")
            let alert = UIAlertController(title: "Error", message: "Failed to save screenshot", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            // Display an alert indicating that the screenshot has been saved successfully
            let alert = UIAlertController(title: "Success", message: "Screenshot saved to gallery", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
}
