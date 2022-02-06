//
//  PlaceModel.swift
//  FourSquare-Clone-2022
//
//  Created by Murat Sağlam on 4.02.2022.
//

import Foundation
import UIKit

class PlaceModel
{
    
    
    static let sharedInstance = PlaceModel()
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    var placeLatitude = ""
    var placeLongitude = ""
    
    private init(){}   
    
    
    
    
}
