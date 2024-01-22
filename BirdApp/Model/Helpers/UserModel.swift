//
//  UserModel.swift
//  BirdApp
//
//  Created by MacBook Pro on 28/12/2023.
//

import Foundation

struct UserModel{
    
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

struct ExpiredBirds{
    
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
    let expiredDate: String
}

struct SoldBird{
    
    let accuracy: String
    let birdID: String
    let birdSpecie: String
    let certificateNo: String
    let collection: String
    let ownerName: String
    let sampleType: String
    let sexDetermination: String
    let uploadCurrentImage: String
    let uploadDate: String
    let buyerName: String
    let buyerPhoneNumber: String
    let soldDate : String
    
}
