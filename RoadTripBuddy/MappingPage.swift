//
//  MappingPage.swift
//  RoadTripBuddy
//
//  Created by Sanjith Udupa on 5/21/22.
//

import SwiftUI
import MapKit

struct MappingPage: View {
    @EnvironmentObject var env : AppEnvironmentData
    
    var body: some View {
        ZStack {
            MapView(
                region: MKCoordinateRegion(SharedData.getInstance().chosenRoute.polyline.boundingMapRect),
                  inputPolyline: SharedData.getInstance().chosenRoute.polyline
                )
                .edgesIgnoringSafeArea(.all)
        }
        .navigationBarHidden(true).navigationBarTitle("")
    }
}


struct MapView: UIViewRepresentable {

  let region: MKCoordinateRegion
  let inputPolyline: MKPolyline

  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView()
    mapView.delegate = context.coordinator
    mapView.region = region

    let polyline = inputPolyline
    mapView.addOverlay(polyline)

    return mapView
  }

  func updateUIView(_ view: MKMapView, context: Context) {}

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

}

class Coordinator: NSObject, MKMapViewDelegate {
  var parent: MapView

  init(_ parent: MapView) {
    self.parent = parent
  }

  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    if let routePolyline = overlay as? MKPolyline {
      let renderer = MKPolylineRenderer(polyline: routePolyline)
      renderer.strokeColor = UIColor.systemBlue
      renderer.lineWidth = 10
      return renderer
    }
    return MKOverlayRenderer()
  }
}

struct MappingPage_Previews: PreviewProvider {
    static var previews: some View {
        MappingPage()
    }
}
