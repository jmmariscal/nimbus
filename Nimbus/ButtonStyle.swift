import SwiftUI

struct WeatherButtonStyle: ButtonStyle {
    var background: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical)
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity)
            .background(background.opacity(configuration.isPressed ? 0.7 : 1))
            .foregroundColor(.white)
            .font(.headline)
            .cornerRadius(12)
            .shadow(radius: 4)
            .scaleEffect(configuration.isPressed ? 0.90 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
