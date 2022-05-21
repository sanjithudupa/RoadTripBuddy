//
//  RoadTripBuddyApp.swift
//  RoadTripBuddy
//
//  Created by Sanjith Udupa on 5/21/22.
//

import SwiftUI

enum AppPage {
    case Planning
    case Map
}

final class AppEnvironmentData: ObservableObject {
    @Published var currentPage : AppPage? = .Planning
}

@main
struct RoadTripBuddyApp: App {
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(AppEnvironmentData())
        }
    }
}

struct MainView: View {
    @EnvironmentObject var env : AppEnvironmentData
   
    var body: some View {
        let plan_to_map = NavigationLink(destination: MappingPage().navigationBarHidden(true).navigationBarTitle(""), tag: .Map, selection: $env.currentPage, label: { EmptyView() })
        
        return
            NavigationView {
                VStack {
                    plan_to_map
                        .frame(width:0, height:0)
                    
                    RoutingPage()
                }
            }.navigationBarHidden(true).navigationBarTitle("")
    }
}
