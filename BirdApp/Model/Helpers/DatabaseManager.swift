
import Foundation
import UIKit
import CoreData

private var context: NSManagedObjectContext{
    return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}

class DatabaseManager{


    func addUser(_ user: UserModel){
        
        let uploadDataTo = UploadData(context: context)
        
        uploadDataTo.accuracy = user.accuracy
        uploadDataTo.datePicker = user.datePicker
        uploadDataTo.sexDetermination = user.sexDetermination
        uploadDataTo.sampleType = user.sampleType
        uploadDataTo.birdSpecie = user.birdSpecie
        uploadDataTo.birdId = user.birdId
        uploadDataTo.certificateNo = user.certificateNo
        uploadDataTo.collection = user.collection
        uploadDataTo.ownerName = user.ownerName
        uploadDataTo.imageUpload = user.imageUpload
        saveContext()
    }
    
    func fetchUser()-> [UploadData]{
        var user : [UploadData] = []
        
        do{
            user = try context.fetch(UploadData.fetchRequest())
        }catch{
            print("Error",error)
        }
        return user
    }
    
func deleteUser(uploadData: UploadData){
    if #available(iOS 16.0, *) {
            let fileUrl = URL.documentsDirectory.appending(component: uploadData.imageUpload ?? "").appendingPathExtension("png")
            do {
                try FileManager.default.removeItem(at: fileUrl)
            }catch {
                print("remove image from DD", error)
            }    
    } else {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = documentsDirectory?.appendingPathComponent(uploadData.imageUpload ?? "").appendingPathExtension("png")
        do {
            try FileManager.default.removeItem(at: fileURL!)
        }catch {
            print("remove image from DD", error)
        }
        
        
        }
        
        context.delete(uploadData)
        saveContext()

        
    }


}


class DatabaseManagers{
    
    private var contexts: NSManagedObjectContext{
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    
    func fetchUsers()-> [ExpiredBirdsDetails]{
        var user : [ExpiredBirdsDetails] = []
        
        do{
            user = try contexts.fetch(ExpiredBirdsDetails.fetchRequest())
        }catch{
            print("Error",error)
        }
        return user
    }
    
    
    
    func addUsers(_ user: ExpiredBirds){
        
        let expiredData = ExpiredBirdsDetails(context: contexts)
        
        expiredData.accuracy = user.accuracy
        expiredData.datePicker = user.datePicker
        expiredData.sexDetermination = user.sexDetermination
        expiredData.sampleType = user.sampleType
        expiredData.birdSpecie = user.birdSpecie
        expiredData.birdId = user.birdId
        expiredData.certificateNo = user.certificateNo
        expiredData.collection = user.collection
        expiredData.ownerName = user.ownerName
        expiredData.imageUpload = user.imageUpload
        expiredData.expiredDate = user.expiredDate
        
        saveContext()
    }
    
    func deleteUser(expiredBirds: ExpiredBirdsDetails){
        if #available(iOS 16.0, *) {
                let fileUrl = URL.documentsDirectory.appending(component: expiredBirds.imageUpload ?? "").appendingPathExtension("png")
                do {
                    try FileManager.default.removeItem(at: fileUrl)
                }catch {
                    print("remove image from DD", error)
                }
        } else {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let fileURL = documentsDirectory?.appendingPathComponent(expiredBirds.imageUpload ?? "").appendingPathExtension("png")
            do {
                try FileManager.default.removeItem(at: fileURL!)
            }catch {
                print("remove image from DD", error)
            }
            
            
            }
            
            context.delete(expiredBirds)
            saveContext()

            
        }


}

class DatabaseManagerss{
    
    private var contexts: NSManagedObjectContext{
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    
    func fetchUsers()-> [SoldBirdsDetails]{
        var user : [SoldBirdsDetails] = []
        
        do{
            user = try contexts.fetch(SoldBirdsDetails.fetchRequest())
        }catch{
            print("Error",error)
        }
        return user
    }
    
    
    
    func addUsers(_ user: SoldBird){
        
        let soldData = SoldBirdsDetails(context: contexts)
        
        soldData.accuracy = user.accuracy
        soldData.soldDate = user.soldDate
        soldData.sexDetermination = user.sexDetermination
        soldData.sampleType = user.sampleType
        soldData.birdSpecie = user.birdSpecie
        soldData.birdID = user.birdID
        soldData.certificateNo = user.certificateNo
        soldData.collection = user.collection
        soldData.ownerName = user.ownerName
        soldData.uploadCurrentImage = user.uploadCurrentImage
        soldData.uploadDate = user.uploadDate
        soldData.buyerName = user.buyerName
        soldData.buyerPhoneNumber = user.buyerPhoneNumber
        
        saveContext()
    }
    
    func deleteUser(soldBirds: SoldBirdsDetails){
        if #available(iOS 16.0, *) {
            let fileUrl = URL.documentsDirectory.appending(component: soldBirds.uploadCurrentImage ?? "").appendingPathExtension("png")
            do {
                try FileManager.default.removeItem(at: fileUrl)
            }catch {
                print("remove image from DD", error)
            }
        } else {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let fileURL = documentsDirectory?.appendingPathComponent(soldBirds.uploadCurrentImage  ?? "").appendingPathExtension("png")
            do {
                try FileManager.default.removeItem(at: fileURL!)
            }catch {
                print("remove image from DD", error)
            }
            
            
        }
        
        context.delete(soldBirds)
        saveContext()
    }
    
}

func saveContext(){
    do{
        try context.save()
        print("Data saved Successfully")
    }catch{
        print("error while loading data to coredatabase\(error)")
    }

}
