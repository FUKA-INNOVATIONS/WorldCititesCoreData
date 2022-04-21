//
//  viewModel.swift
//  WorldCitites
//
//  Created by Koulu on 21.4.2022.
//

import Foundation

class ViewModel: ObservableObject { // ** Works
    //init() { DispatchQueue.main.asyncAfter(deadline: .now() + 1) { self.isFetching = true } }
    //@Published var isFetching = false
    
    static let shared = ViewModel() ; private init() {}
    
    @Published var cities = [String]()
    
    func fetchCities(of countryName: String) {
        let urlString = "https://countriesnow.space/api/v0.1/countries/cities"
        guard let url = URL(string: urlString) else { return }
        
        let body = ["country": countryName]
        let finalBody = try? JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = finalBody
        
        self.cities.removeAll()
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                if let data = data {
                    
                    let result = try JSONDecoder().decode(CityTransformer.self, from: data)
                    DispatchQueue.main.async { self.cities = result.data }
                } else { print("No data") }
            } catch {
                print("Failed to reach endpoint \(error)")
            }
        }.resume()
    }
}


struct CityTransformer: Codable {
    var error: Bool
    var msg: String
    var data: [String]
    
    /*enum CodingKeys: String, CodingKey {
        case name = ""
    }*/
}
