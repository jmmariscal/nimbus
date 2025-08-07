import SwiftUI

// MARK: - Weather Card
struct WeatherCardView: View {
    let weather: WeatherResponse
    @State private var animate = false

    var body: some View {
        let theme = WeatherTheme(from: weather.weather.first?.main ?? "")

        VStack(spacing: 12) {
            Text(weather.name)
                .font(.largeTitle)
                .bold()

            Text("\(weather.main.temp * 9/5 + 32, specifier: "%.1f")°F")
                .font(.system(size: 50, weight: .semibold))

            HStack(spacing: 8) {
                Image(systemName: theme.symbolName)
                    .font(.title)
                    .foregroundColor(theme.accentColor)

                Text(weather.weather.first?.main ?? "-")
                    .font(.title3)
            }

            Text(weather.weather.first?.description.capitalized ?? "")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 10)
        .padding(.horizontal)
        .opacity(animate ? 1 : 0)
        .offset(y: animate ? 0 : 40)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                animate = true
            }
        }
    }
}
