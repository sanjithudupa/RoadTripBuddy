//
//  TargetChooser.swift
//  RoadTripBuddy
//
//  Created by Sanjith Udupa on 5/21/22.
//

import Foundation
import SwiftUI
import MapKit

struct TargetChooser: View {
    
    @Binding var region: MKCoordinateRegion;
    @Binding var showing: Bool;
    @Binding var chosenLocation: CLLocationCoordinate2D;
//    @State var suggestion: String = "";
//    @State var commitable: Bool = false;
    
    @State var timer: Timer? = nil;
    @State var lastMoveTimestamp = DispatchTime.now()
    
    var body: some View {
        VStack {
            Text("Choose a target:")
                .fontWeight(.semibold)
            
            ZStack {
                Map(coordinateRegion: $region)
                    .frame(width: 250, height: 300)// height: commitable ? 300 : 330)
                   .cornerRadius(10)
//                   .onChange(of: region.span) {_ in
//                       commitable = true;
//                   }
                Image(systemName: "mappin.circle")
                    .resizable()
                    .offset(y: -25)
                    .frame(width: 60, height: 60)
                    .foregroundColor(.orange)
                    .shadow(radius: 5)
                    
            }
            
            Button(role:.cancel, action: {
                chosenLocation = region.center;
                showing = false;
            }) {
                Text("Select")
                    .foregroundColor(.orange)
            }
            .buttonStyle(.bordered)
//            .opacity(commitable ? 1 :0)
//            Text(suggestion)
        }
        .frame(width: 280, height: 400)
        .background()
        .cornerRadius(30)
        .shadow(color: .orange.opacity(0.5), radius: 50, x: 5, y: 10)
//        .animation(.spring(), value: commitable)
//        .onAppear {
//            timer?.invalidate()
////            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
////                if (DispatchTime.now().distance(to: lastMoveTimestamp).milliseconds > 250) {
////                    determineSuggestion()
////                }
////            }
//        }
//        .onDisappear {
//            timer?.invalidate();
//        }
        
    }
    
//    func determineSuggestion() {
//        LocationManager.getInstance().geocoder.reverseGeocodeLocation(CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)) { placemarks, error in
//            if error != nil {
//                suggestion = ""
//            } else {
//                if let placemarks = placemarks, let placemark = placemarks.first {
//                    if let locale = placemark.locality {
//                        suggestion = "In " + locale
//                    } else {
//                        suggestion = ""
//                    }
//                } else {
//                    suggestion = ""
//                }
//            }
//        }
//    }
}

//struct Pvw : View {
//    @State var bbb = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5));
//    var body: some View {
//        TargetChooser(region: $bbb)
//    }
//}
//
//struct TargetPreview: PreviewProvider {
//    static var previews: some View {
//        Pvw()
//    }
//}

extension MKCoordinateSpan: Equatable {
    public static func == (lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
        lhs.latitudeDelta == rhs.latitudeDelta && lhs.longitudeDelta == rhs.longitudeDelta
    }
}

extension DispatchTimeInterval {
    var milliseconds: Int {
        switch self {
        case .seconds(let s): return s * 1_000
        case .milliseconds(let ms): return ms
        case .microseconds(let us): return us / 1_000 // rounds toward zero
        case .nanoseconds(let ns): return ns / 1_000_000 // rounds toward zero
        case .never: return .max
        }
    }
}
