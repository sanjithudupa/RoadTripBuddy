//
//  BusinessViewer.swift
//  RoadTripBuddy
//
//  Created by Sanjith Udupa on 5/22/22.
//

import SwiftUI
import CoreLocation

//struct BusinessViewer: View {
//    var body: some View {
//        Business(name: "Bus", imageURL: "https://s3-media1.fl.yelpcdn.com/bphoto/6jkLUJSr-SjClqg0lWMvCw/o.jpg", link: "https://www.yelp.com/biz/zip-thru-express-car-wash-santa-clara-7?adjust_creative=wcZaj4-V-tkCzktUpVGNgw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=wcZaj4-V-tkCzktUpVGNgw", price: "$$", phone: "+18449478478", rating: 3.5, location: .init())
//    }
//}

struct Business: View {
    @State var name: String;
    @State var imageURL: String;
    @State var link: String;
    @State var price: String;
    @State var phone: String;
    @State var rating: Double;
    @State var location: CLLocationCoordinate2D;
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                ZStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .onTapGesture {
                                    if let url = URL(string: link) {
                                        UIApplication.shared.open(url)
                                    }
                                }
                            Text(phone)
                                .onTapGesture {
                                    if let url = URL(string: "tel://\(phone)") {
                                        UIApplication.shared.open(url)
                                    }
                                }
                        }
                        .padding()
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(String(rating) + " ⭐")
                                .font(.title3)
                            Text(price)
                                .fontWeight(.bold)
                        }
                        .padding()
                    }
                }.padding(.top)
                Divider()
                    .frame(width: 320)
                AsyncImage(url: URL(string: imageURL))
                    .frame(width: 350, height: 150)
                    .scaledToFill()
                    .clipped()

            }
            HStack {
                Text("Powered by")
                    .foregroundColor(.white)
                Text("Yelp")
                    .underline()
                    .foregroundColor(.white)
                    .onTapGesture {
                        if let url = URL(string: "https://yelp.com") {
                            UIApplication.shared.open(url)
                        }
                    }
            }.offset(x: 100, y: 90)
        }
        .frame(width: 350, height: 220)
        .cornerRadius(25)
        .shadow(radius: 15)
        
    }
}

struct BusinessViewer_Previews: PreviewProvider {
    static var previews: some View {
        BusinessViewer()
    }
}
