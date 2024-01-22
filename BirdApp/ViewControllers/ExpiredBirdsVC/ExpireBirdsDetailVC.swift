//
//  ExpireBirdsDetailVC.swift
//  BirdApp
//
//  Created by MacBook Pro on 29/12/2023.
//

import UIKit

class ExpireBirdsDetailVC: UIViewController {
    
    var imgViewUUID = ""
    var expireDetail: ExpiredBirdsDetails!
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var expireDate: UILabel!
    @IBOutlet weak var uploadDate: UILabel!
    @IBOutlet weak var certificateNo: UILabel!
    @IBOutlet weak var birdSpecie: UILabel!
    @IBOutlet weak var birdId: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var sampleType: UILabel!
    @IBOutlet weak var collectionLBl: UILabel!
    @IBOutlet weak var sexDetermination: UILabel!
    @IBOutlet weak var accuracyLbl: UILabel!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.layer.cornerRadius = 20
        
        ownerName.text = ("Owner Name :  \(self.expireDetail.ownerName ?? "No Data")")
        sampleType.text = ("Sample Type :  \(self.expireDetail.sampleType ?? "No Data")")
        certificateNo.text = ("Certificate :  \(self.expireDetail.certificateNo ?? "No Data")")
        birdId.text = ("Bird Id :  \( self.expireDetail.birdId ?? "No Data")")
        birdSpecie.text = ("Bird Specie :  \(self.expireDetail.birdSpecie ?? "No Data")")
        collectionLBl.text = ("Collection :  \(self.expireDetail.collection ?? "No Data")")
        sexDetermination.text = ("Sex :  \(self.expireDetail.sexDetermination ?? "No Data")")
        accuracyLbl.text = ("Accuracy :  \(self.expireDetail.accuracy ?? "No Data")")
        uploadDate.text = ("Upload Date : \(self.expireDetail.datePicker ?? "No Data")")
        expireDate.text = ("Expire Date : \(self.expireDetail.expiredDate ?? "No Data")")
        
        
        
        
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
