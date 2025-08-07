struct WeatherResponse: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
    let coord: Cordinate?
    
    init(name: String, main: Main, weather: [Weather], cordinate: Cordinate) {
        self.name = name
        self.main = main
        self.weather = weather
        self.coord = cordinate
    }
}

struct Main: Decodable {
    let temp: Double
    let humidity: Int
    
    init(temp: Double, humidity: Int) {
        self.temp = temp
        self.humidity = humidity
    }
}

struct Weather: Decodable {
    let main: String
    let description: String
    let icon: String
    
    init(main: String, description: String, icon: String) {
        self.main = main
        self.description = description
        self.icon = icon
    }
}

struct Cordinate: Decodable {
    let lon: Double
    let lat: Double
}
