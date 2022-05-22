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
    
    @State private var fabSelection = ""
    @State private var infoAlert = false;
    @State private var showingSteps = false;
    @State private var region = MKCoordinateRegion(SharedData.getInstance().chosenRoute.polyline.boundingMapRect);
    let fabActions = ["Red", "Green", "Blue", "Black", "Tartan"]
    
    
    var body: some View {
            ZStack {
//                MapView(
//                    region: $region,
//                    inputPolyline: SharedData.getInstance().chosenRoute.polyline
//                    )
//                    .edgesIgnoringSafeArea(.all)
                
                ZStack {
                    Picker("FAB", selection: $fabSelection) {
                        ForEach(fabActions, id: \.self) {
                            Text($0)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .frame(width: 60, height: 60)
                    .pickerStyle(.menu)
                    
                    Image(systemName: "plus.app.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.orange)
                        .background(.white)
                        .cornerRadius(15)
                        .allowsHitTesting(false)
                }
                .offset(x: -150, y: UIScreen.main.bounds.height/2 - 115)
                
                VStack {
                    Button(role: .cancel, action: resetLocation) {
                        Image(systemName: "location.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.orange)
                            .background(.white)
                            .cornerRadius(30)
                    }
                    
                    Button(role: .cancel, action: viewDirections) {
                        Image(systemName: "list.bullet.rectangle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.orange)
                            .background(.white)
                            .cornerRadius(8)
                    }.sheet(isPresented: $showingSteps) {
                        List() {
                            ForEach(SharedData.getInstance().chosenRoute.steps, id: \.self) { step in
                                VStack {
                                    if (step.instructions != "") {
                                        Text(step.instructions)
                                            .font(.title3)
                                        Text(String(format: "%.2f miles", (step.distance.magnitude) * 0.000621371))
                                            .font(.caption)
                                    }
                                }.padding()
                            }
                        }
                    }
                    
                }.offset(x: UIScreen.main.bounds.width/2 - 50, y: UIScreen.main.bounds.height/2 - 150)
                
                Button(role: .cancel, action: { infoAlert = true }) {
                    Image(systemName: "info.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.orange)
                        .background(.white)
                        .cornerRadius(30)
                }.offset(x: 45 - UIScreen.main.bounds.width/2, y: 80 - UIScreen.main.bounds.height/2)
                    .alert(isPresented: $infoAlert) {
                        Alert(title: Text("Route Details:"), message: Text(getRouteDescription()), dismissButton: .default(Text("OK")))
                    }
                
            }
            .navigationBarHidden(true).navigationBarTitle("")
    }
    
    func resetLocation() {
        region.center = LocationManager.getInstance().getLocation().coordinate
    }
    
    func viewDirections() {
        showingSteps = true
    }
    
    func getRouteDescription() -> String {
        let dist = String(format: "%.2f miles", (SharedData.getInstance().chosenRoute.distance.magnitude) * 0.000621371);
        
        let time = String(format: "%.2f hours", (SharedData.getInstance().chosenRoute.expectedTravelTime.magnitude.truncatingRemainder(dividingBy: 86400)) / 3600);
        
        return "Total Distance: " + dist + "\nTotal Time: " + time;
    }
}


struct MapView: UIViewRepresentable {

    @Binding var region: MKCoordinateRegion
    let inputPolyline: MKPolyline

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.region = region
        mapView.showsUserLocation = true

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
