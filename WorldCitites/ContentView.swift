//
//  ContentView.swift
//  WorldCitites
//
//  Created by Koulu on 21.4.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject var WorldVM = ViewModel.shared
    @State var countryName = "finland"
    var city = "Vaasa"
    @Environment(\.managedObjectContext) var moc
    //@FetchRequest(sortDescriptors: []) var cities: FetchedResults<City>
    //@FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "name == %@", "Espoo")) var cities: FetchedResults<City>
    //@FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "name IN %@", ["Lahti", "Vaasa", "Helsinki", "Kauniainen"])) var cities: FetchedResults<City>
    //@FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "name BEGINSWITH %@", "K")) var cities: FetchedResults<City>
    //@FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "name BEGINSWITH[c] %@", "s")) var cities: FetchedResults<City> // case not sensitive
    //@FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "name CONTAINS[c] %@", "kylä")) var cities: FetchedResults<City> // case not sensitive
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "NOT name BEGINSWITH[c] %@", "s")) var cities: FetchedResults<City> // inverse predicate, case not sensitive
    
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("delete all from device") { cities.map { c in  moc.delete(c) } ; try? moc.save() }
                Spacer()
                Button("save in device") {
                    if moc.hasChanges {
                        do {
                            try moc.save()
                            print("Saved cities")
                        } catch {
                            print("Error while saving into device \(error.localizedDescription)")
                        }
                    } else { print("Cities not saved in device beause of no changes") }
                }
                Spacer()
            }
            VStack {
                VStack {
                    Text("cities in \(countryName): \(cities.count)")
                    List(cities, id: \.id) { city in
                        HStack {
                            Text(city.name ?? "no city name")
                            Spacer()
                            Button("delete") { moc.delete(city) ; try? moc.save() }
                        }
                    }
                }
                Button("insert cities into the device memory") {
                    for city in WorldVM.cities {
                        let c = City(context: moc)
                        c.id = UUID()
                        c.name = city
                        c.country = countryName
                    }
                }
            }
//            VStack {
//                Text("Cities of \(countryName): \(cities.count)")
//                List(WorldVM.cities, id: \.self) { city in
//                    Text(city)
//                }
//            }
            .task {
                WorldVM.fetchCities(of: countryName)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
