//
//  WorldCititesApp.swift
//  WorldCitites
//
//  Created by Koulu on 21.4.2022.
//

import SwiftUI

@main
struct WorldCititesApp: App {
    @StateObject private var countryController = CountryController() 

    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, countryController.container.viewContext)
        }
    }
}
