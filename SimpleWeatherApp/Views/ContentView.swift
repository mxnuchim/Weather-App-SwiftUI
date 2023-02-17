//
//  ContentView.swift
//  SimpleWeatherApp
//
//  Created by Manuchim Oliver on 15/02/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?
    
    var body: some View {
        VStack {
            
            if let location = locationManager.location {
                if let weather = weather {
                    
                    WeatherView(weather: weather)
                    
                } else {
                    LoadingView()
                        .task{
                            do {
                                weather = try await weatherManager.getCurrentWeather(lat: location.latitude, long: location.longitude)
                                print(weather as Any)
                            } catch{
                                print("Error fetching weather: \(error)")
                            }
                        }
                }
            } else {
                if locationManager.isLoading {
                    LoadingView()
                } else {
                    WelcomeView()
                        .environmentObject(locationManager)
                }
            }
        }
        .background(
            Image("background")
                        .resizable())
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
