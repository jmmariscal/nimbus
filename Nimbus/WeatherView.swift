import SwiftUI
import CoreLocation
import MapKit

struct WeatherView: View {
    @StateObject var viewModel: WeatherViewModel
    @StateObject var locationManager: LocationManager

    var body: some View {
        let theme = WeatherTheme(from: viewModel.weather?.weather.first?.main ?? "")

        ZStack {
            theme.gradient
                .ignoresSafeArea()
            
            ScrollView() {
                VStack(spacing: 15) {
                    Spacer().frame(height: 60)

                    TextField("Enter city", text: $viewModel.city)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.3)))
                        .foregroundColor(.white)
                        .font(.headline)
                        .shadow(radius: 4)
                    
                    HStack {
                        if !viewModel.city.trimmingCharacters(in: .whitespaces).isEmpty {
                            Button("Search") {
                                Task {
                                    await viewModel.getWeather()
                                }
                            }
                            .buttonStyle(WeatherButtonStyle(background: .indigo))
                            .transition(.opacity)
                            .frame(height: 50)
                        }

                        Button("Current Location") {
                            locationManager.requestLocation()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                if let location = locationManager.location {
                                    Task {
                                        await viewModel.getWeatherForCurrentLocation(
                                            lat: location.coordinate.latitude,
                                            lon: location.coordinate.longitude
                                        )
                                    }
                                } else {
                                    viewModel.errorMessage = "Unable to get current location."
                                }
                            }
                        }
                        .buttonStyle(WeatherButtonStyle(background: .mint))
                    }

                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                    } else if viewModel.didManuallyTriggerWeatherFetch, let weather = viewModel.weather {
                        WeatherCardView(weather: weather)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))

                        // Stretch goal: Map location preview
                        if let cord = viewModel.weather?.coord {
                            Map(initialPosition: .region(MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: cord.lat, longitude: cord.lon),
                                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                            )))
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    } else if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                    }

                    Spacer()
                }
                .animation(.easeInOut, value: viewModel.city)
                .padding()
            }
        }
        .overlay(topBar, alignment: .top)
    }

    private var topBar: some View {
        ZStack {
            HStack {
                Text("Nimbus")
                    .font(.title.bold())
                    .foregroundColor(.white)

                Spacer()

                Button {
                    Task {
                        await viewModel.refreshLastSource()
                    }
                } label: {
                    Image(systemName: viewModel.isLoading ? "arrow.triangle.2.circlepath.circle.fill" : "arrow.clockwise")
                        .rotationEffect(viewModel.isLoading ? .degrees(360) : .degrees(0))
                        .foregroundColor(.yellow)
                        .font(.title2)
                        .padding(8)
                        .background(Circle().fill(Color.white.opacity(0.30)))
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(viewModel.isLoading)
            }
            .padding(.horizontal)
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .shadow(radius: 4)
    }
}

struct WeatherCardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewPreviewWrapper()
    }

    struct ContentViewPreviewWrapper: View {
        @StateObject private var viewModel = MockWeatherViewModel()
        @StateObject private var locationManager = MockLocationManager()

        var body: some View {
            WeatherView(viewModel: viewModel, locationManager: locationManager)
        }
    }
}

@MainActor
final class MockWeatherViewModel: WeatherViewModel {
    override init() {
        super.init()
        self.city = "Preview City"
        self.weather = WeatherResponse(
            name: "Barcelona",
            main: Main(temp: 26.4, humidity: 60),
            weather: [
                Weather(main: "Clear", description: "sunny", icon: "01d")
            ],
            cordinate: Cordinate(lon: 41.3851, lat: 2.1734)
        )
        self.didManuallyTriggerWeatherFetch = true
    }
}

@MainActor
final class MockLocationManager: LocationManager {
    override init() {
        super.init()
        self.location = CLLocation(latitude: 41.3851, longitude: 2.1734)
    }
}
