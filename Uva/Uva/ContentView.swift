import SwiftUI
import SwiftData
import UserNotifications
import Foundation


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {

        VStack{
            HStack{
                DayForecast(day: "Hoje", isRainy: false, high: 29, low: 20)
                DayForecast(day: "Amanhã", isRainy: true, high: 27, low: 17)
            }
            .padding()
            .padding()
            Button(action: notify){
                Label("APERTE:", systemImage: "cloud.rain.fill")
            }
            .buttonStyle(.bordered)
            Button(action: getWeatherData){
                Label("Obter Dados Meteorológicos", systemImage: "cloud.sun.fill")
            }
            .buttonStyle(.bordered)
        }
        
    }
}
func notify(){
    let content = UNMutableNotificationContent()
    content.title = "Vai Chover!"
    content.body = "Pegue um guarda chuva agora!"
    content.sound = UNNotificationSound.default
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
    let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request)
}
func getWeatherData(){
    guard let apiUrl = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=-26.3044&longitude=-48.8456&hourly=temperature_2m,precipitation_probability&timezone=America%2FSao_Paulo") else {
        print("error")
        return
    }
    let task = URLSession.shared.dataTask(with: apiUrl) { 
        data, response, error in
        guard let data = data, error == nil else {
            print("Error catching data", error?.localizedDescription ?? "Error")
            return
        }
        do {
            let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
            DispatchQueue.main.async {
            }
        } catch {
            print("Error on parsing data to JSON:", error.localizedDescription)
        }
    }
    task.resume()
}
struct WeatherData: Codable {
    let hourly: [HourlyData]
}

struct HourlyData: Codable {
    let time: String
    let temperature_2m: Double
    let precipitation_probability: Double
}

struct DayForecast: View{
    let day: String
    let isRainy: Bool
    let high: Int
    let low: Int
    var iconName: String {
        if isRainy{
            return "cloud.rain.fill"
        }
        return "sun.max.fill"
    }
    var iconColor: Color {
        if isRainy{
            return Color.blue
        }
        return Color.yellow
    }
    var body: some View{
        VStack{
            Text(day)
                .font(Font.headline)
            Image(systemName: iconName)
                .foregroundStyle(iconColor)
            Text("Máxima: \(high)")
            Text("Mínima: \(low)")
        }
    }
}

