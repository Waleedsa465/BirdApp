//
//  ExpiredBirds.swift
//  BirdApp
//
//  Created by MacBook Pro on 28/12/2023.
//



import Foundation
import UIKit
import CoreData

struct ExpiredBirds{
    
    let expiredDate: String
    let certificateNo: String
    let accuracy: String
    let datePicker: String
    let sexDetermination: String
    let sampleType: String
    let birdSpecie: String
    let birdId: String
    let collection: String
    let ownerName: String
    let imageUpload: String
}


class DatabaseManagerExpired{
    private var context: NSManagedObjectContext{
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    func addUser(_ user: ExpiredBirds){
        
        //        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let uploadDataTo = ExpiredBirdsDetails(context: context)
        
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
        uploadDataTo.expiredDate = user.expiredDate
        
        do{
            try context.save()
            print("Data saved Successfully")
        }catch{
            print("error while loading data to coredatabase\(error)")
        }
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
    
    
    
//    func addUsers(_ user: ExpiredBirds){
//
//        let contexts = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let expiredData = ExpiredBirds(context: contexts)
//
//        expiredData.accuracy = user.accuracy
//        expiredData.datePicker = user.datePicker
//        expiredData.sexDetermination = user.sexDetermination
//        expiredData.sampleType = user.sampleType
//        expiredData.birdSpecie = user.birdSpecie
//        expiredData.birdId = user.birdId
//        expiredData.certificateNo = user.certificateNo
//        expiredData.collection = user.collection
//        expiredData.ownerName = user.ownerName
//        expiredData.imageUpload = user.imageUpload
//        expiredData.expiredDate = user.expiredDate
//
//        do{
//            try contexts.save()
//            print("Data saved Successfully")
//        }catch{
//            print("error while loading data to coredatabase\(error)")
//        }
//    }


}

