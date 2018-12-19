//
//  BarcodeData.swift
//  BarcodeScan
//
//  Created by Administrator on 30/07/18.
//  Copyright © 2018 TMFC. All rights reserved.
//


import UIKit
import Foundation
import SwiftyJSON

class BarcodeData: NSObject
{
    var Firstname                : String = ""
    var Middlename                : String = ""
    var Lastname                : String = ""
    var DOB                : String = ""
    var Issuedate                : String = ""
    var Expiry                : String = ""
    var License                : String = ""
    var Country                : String = ""
    var Street                : String = ""
    var City                : String = ""
    var StateCode                : String = ""
    var PostalCode                : String = ""
    var Address                : String = ""
    
    override init( )
    {
        
    }
    
    init(json : [String:JSON])
    {
        
        Firstname                = (json[Constant.StaticNameOfVariable.VFirstname]?.stringValue)!
        Middlename                = (json[Constant.StaticNameOfVariable.VMiddlename]?.stringValue)!
        Lastname                = (json[Constant.StaticNameOfVariable.VLastname]?.stringValue)!
        DOB                = (json[Constant.StaticNameOfVariable.VDateOB]?.stringValue)!
        Issuedate                = (json[Constant.StaticNameOfVariable.VISSDate]?.stringValue)!
        Expiry                = (json[Constant.StaticNameOfVariable.VExpDate]?.stringValue)!
        License                = (json[Constant.StaticNameOfVariable.VLicenseNo]?.stringValue)!
        Country                = (json[Constant.StaticNameOfVariable.VCountry]?.stringValue)!
        Street                = (json[Constant.StaticNameOfVariable.VStreet]?.stringValue)!
        City                = (json[Constant.StaticNameOfVariable.VBarcodeCity]?.stringValue)!
        StateCode                = (json[Constant.StaticNameOfVariable.VStateCode]?.stringValue)!
        PostalCode                = (json[Constant.StaticNameOfVariable.VPostalCode]?.stringValue)!
      //  Address                = (json[Constant.StaticNameOfVariable.VBarcodeAddress]?.stringValue)!
        
    }
}
