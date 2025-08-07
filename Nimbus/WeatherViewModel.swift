import Foundation
import CoreLocation
import Combine


@MainActor
class WeatherViewModel: ObservableObject {
    @Published var city = ""
    @Published var weather: WeatherResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var didManuallyTriggerWeatherFetch = false
    private(set) var lastWeatherSource: WeatherSource = .none

    private let service = WeatherService()

    func getWeather() async {
        isLoading = true
        errorMessage = nil
        didManuallyTriggerWeatherFetch = false
        defer { isLoading = false }

        do {
            let result = try await service.fetchWeather(for: city)
            self.weather = result
            self.didManuallyTriggerWeatherFetch = true
            self.lastWeatherSource = .city(city)
        } catch {
            self.errorMessage = "Could not fetch weather for \(city)"
        }
    }

    func getWeatherForCurrentLocation(lat: Double, lon: Double) async {
        isLoading = true
        errorMessage = nil
        didManuallyTriggerWeatherFetch = false
        defer { isLoading = false }

        do {
            let result = try await service.fetchWeather(lat: lat, lon: lon)
            self.weather = result
            self.didManuallyTriggerWeatherFetch = true
            self.lastWeatherSource = .location(CLLocation(latitude: lat, longitude: lon))
        } catch {
            self.errorMessage = "Could not fetch weather for current location"
        }
    }
    
    func refreshLastSource() async {
            switch lastWeatherSource {
            case .city(let cityName):
                self.city = cityName
                await getWeather()
            case .location(let location):
                await getWeatherForCurrentLocation(
                    lat: location.coordinate.latitude,
                    lon: location.coordinate.longitude
                )
            case .none:
                self.errorMessage = "No weather source to refresh."
            }
        }
}

enum WeatherSource {
    case city(String)
    case location(CLLocation)
    case none
}
