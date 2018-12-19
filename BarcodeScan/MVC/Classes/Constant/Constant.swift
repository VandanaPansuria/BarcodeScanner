//
//  Constant.swift
//  Bibleness
//
//  Created by SOTSYS140 on 29/05/17.
//  Copyright © 2017 Chiragl.Spaceo. All rights reserved.
//

import UIKit
var arrbarcodedetail = [String]()
var dictQRdetail = [String : String]()
class Constant: NSObject {
    
    struct StaticNameOfVariable
    {
        //For Card
        static let VFirstname = "Firstname"
        static let VMiddlename = "Middlename"
        static let VLastname = "Lastname"
        static let VDateOB = "DOB"
        static let VISSDate = "Issuedate"
        static let VExpDate = "Expiry"
        static let VLicenseNo = "License"
        static let VCountry = "Country"
        static let VBarcodeAddress = "Address"
        static let VStreet = "Street"
        static let VBarcodeCity = "City"
        static let VStateCode = "StateCode"
        static let VPostalCode = "PostalCode"
        
        //API
        static let Vdata = "data"
        static let Vstatus = "status"
    }
}

//Scan View
func setdatefromstring(strdate : String) -> String
{
    var datestr:Date? = nil
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMddyyyy"
     datestr = dateFormatter.date(from: strdate)
    if dateFormatter.date(from: strdate) != nil{
        dateFormatter.dateFormat = "MM/dd/yyyy"
    }else{
        dateFormatter.dateFormat = "yyyyMMdd"
        datestr = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat = "MM/dd/yyyy"
    }
    return String(dateFormatter.string(from: datestr!))
}

