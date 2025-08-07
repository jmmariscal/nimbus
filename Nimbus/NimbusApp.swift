//
//  NimbusApp.swift
//  Nimbus
//
//  Created by Juan M Mariscal on 7/1/25.
//

import SwiftUI

@main
struct NimbusApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherView(
                viewModel: WeatherViewModel(),
                locationManager: LocationManager()
            )
        }
    }
}
