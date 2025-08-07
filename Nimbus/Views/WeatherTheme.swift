import SwiftUI

enum WeatherTheme {
    case clear, clouds, rain, snow, thunder, unknown

    init(from condition: String) {
        switch condition.lowercased() {
        case "clear": self = .clear
        case "clouds": self = .clouds
        case "rain", "drizzle": self = .rain
        case "snow": self = .snow
        case "thunderstorm": self = .thunder
        default: self = .unknown
        }
    }

    var gradient: LinearGradient {
        switch self {
        case .clear:
            return LinearGradient(colors: [.blue, .cyan], startPoint: .top, endPoint: .bottom)
        case .clouds:
            return LinearGradient(colors: [.gray, .blue], startPoint: .top, endPoint: .bottom)
        case .rain:
            return LinearGradient(colors: [.blue.opacity(0.6), .gray], startPoint: .top, endPoint: .bottom)
        case .snow:
            return LinearGradient(colors: [.white, .gray.opacity(0.5)], startPoint: .top, endPoint: .bottom)
        case .thunder:
            return LinearGradient(colors: [.purple, .black], startPoint: .top, endPoint: .bottom)
        case .unknown:
            return LinearGradient(colors: [.gray, .blue], startPoint: .top, endPoint: .bottom)
        }
    }
    
    var accentColor: Color {
        switch self {
        case .clear: return .yellow
        case .clouds: return .gray
        case .rain: return .blue
        case .snow: return .teal
        case .thunder: return .purple
        case .unknown: return .white
        }
    }
    
    var symbolName: String {
            switch self {
            case .clear: return "sun.max.fill"
            case .clouds: return "cloud.fill"
            case .rain: return "cloud.rain.fill"
            case .snow: return "snow"
            case .thunder: return "cloud.bolt.rain.fill"
            case .unknown: return "questionmark"
            }
        }
}

