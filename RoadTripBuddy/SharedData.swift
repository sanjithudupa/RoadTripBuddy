//
//  SharedData.swift
//  RoadTripBuddy
//
//  Created by Sanjith Udupa on 5/21/22.
//

import Foundation
import MapKit

class SharedData {
    private static var instance = SharedData()
    
    public static func getInstance() -> SharedData {
        return instance;
    }
    
    public var chosenRoute: MKRoute = .init()
    public var startTime: Date = .init()
}
