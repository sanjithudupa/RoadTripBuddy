//
//  Util.swift
//  RoadTripBuddy
//
//  Created by Sanjith Udupa on 5/22/22.
//

import Foundation
import CoreLocation

class Util {
    public static func determineSearchPoint(inTheNext: Double) -> CLLocationCoordinate2D {
        let route = SharedData.getInstance().chosenRoute;
        let curLoc = LocationManager.getInstance().getLocation();

        var closest = route.polyline.coordinates.first!;
        var closestDist = distance(coordinate: closest)
        var c_idx = 0;
        
        var endpoint = closest;
        var e_idx = 0;
        
        var i = 0;
        for coordinate in route.polyline.coordinates {
            // getting closest
            let curDist = distance(coordinate: coordinate)
            if (curDist <= closestDist) {
                closestDist = curDist;
                closest = coordinate;
                c_idx = i;
            }
            
            let offset = abs(inTheNext - (curDist / 1609)) // how far is the point from perfect offset
            
            if (offset < 3) {
                endpoint = coordinate;
                e_idx = i;
            }
            
            i += 1;
        }
        
        if (e_idx <= c_idx) {
            print("falling back on forward point")
            return determineForwardPoint(radius: inTheNext/4, closestInput: closest, cIDX: c_idx)
        }

        func distance(coordinate: CLLocationCoordinate2D) -> Double {
            return (curLoc.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)))
        }
        
        return CLLocationCoordinate2D(latitude: (curLoc.coordinate.latitude + endpoint.latitude)/2, longitude: (curLoc.coordinate.longitude + endpoint.longitude)/2)
    }
    public static func determineForwardPoint(radius: Double, closestInput: CLLocationCoordinate2D?, cIDX: Int?) -> CLLocationCoordinate2D {
        let route = SharedData.getInstance().chosenRoute;
        let curLoc = LocationManager.getInstance().getLocation();
        
        var closest = closestInput != nil ? closestInput! : route.polyline.coordinates.first!;
        var closestDist = distance(coordinate: closest)
        var c_idx = cIDX ?? 0;
        
        var i = 0;
        if (closestInput != nil) {
            for coordinate in route.polyline.coordinates {
                let curDist = distance(coordinate: coordinate)
                if (curDist <= closestDist) {
                    closestDist = curDist;
                    closest = coordinate;
                    c_idx = i;
                }
                i += 1;
            }
        }
        
        let comparisonPoint = c_idx < route.polyline.coordinates.count - 2 ? route.polyline.coordinates[c_idx + 1] : curLoc.coordinate;
        
        let dX = comparisonPoint.longitude - closest.longitude // delta lon
        let dY = comparisonPoint.latitude - closest.latitude // deta lat
        let theta = atan2(dX, dY);
        
        let offsetY = ((radius / 2) / 69) * cos(theta)
        let offsetX = ((radius / 2) / 69) * sin(theta)
        
        let newCoord = CLLocationCoordinate2D(latitude: closest.latitude + offsetY, longitude: closest.longitude + offsetX)
        
        func distance(coordinate: CLLocationCoordinate2D) -> Double {
            return (curLoc.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)))
        }
        
        func distanceFrom(coordinate: CLLocationCoordinate2D, coordinate2: CLLocationCoordinate2D) -> Double {
            return (CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude).distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)))
        }
        
        return newCoord;
    }
}
