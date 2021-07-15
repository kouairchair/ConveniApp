//
//  ContentView.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/06/26.
//

import SwiftUI
import OSLog

struct AlertMessage: Identifiable {
    var id: String { message }
    let message: String
}

struct ContentView: View {
    @State var image: UIImage?
    @State private var alertMessage: AlertMessage?
    
    var body: some View {
        VStack {
//            ConveniHeaderView()
//            if let _image = image {
//                Image(uiImage: _image)
//            }
            Home()
        }.onAppear {
            async {
                do {
                    if let weatherImage = try await WeatherManager.shared.fetchWeatherIcon() {
                        image = weatherImage
                    }
                } catch {
                    logger.error("fetchWeather failed:\(error)")
                    if Constants.isDebug {
                        self.alertMessage = AlertMessage(message: String(format: LcliConstants.fetchWeatherFailed.translate(), [error]))
                    }
                }
            }
        }.alert(item: $alertMessage) { alert in
            Alert(title: Text(LcliConstants.errorMessage.translate()), message: Text(alert.message), dismissButton: .cancel())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11 Pro Max")
            .preferredColorScheme(.dark)
    }
}

// TODO: this struct should be in a separated file?
struct Home: View {
    
    @State var currentTab: TabItem = .Weather
    var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    
    var body: some View {
        VStack {
            HStack {
                Text("Conveni App")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("TextColor"))
                
                Spacer(minLength: 0)
            }
            .padding(.horizontal)
            
            // Tab View...
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    // Weather, Browser, Message...
                    Group {
                        Text(TabItem.Weather.rawValue)
                            .foregroundColor(self.currentTab == .Weather ? .white : Color("TextColor").opacity(0.7))
                            .fontWeight(.bold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 10)
                            .background(Color("BackgroundColor").opacity(self.currentTab == .Weather ? 1 : 0))
                            .clipShape(Capsule())
                            .onTapGesture {
                                self.currentTab = .Weather
                        }
                        
                        Spacer(minLength: 0)
                        
                        Text(TabItem.Browser.rawValue)
                            .foregroundColor(self.currentTab == .Browser ? .white : Color("TextColor").opacity(0.7))
                            .fontWeight(.bold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 10)
                            .background(Color("BackgroundColor").opacity(self.currentTab == .Browser ? 1 : 0))
                            .clipShape(Capsule())
                            .onTapGesture {
                                self.currentTab = .Browser
                            }
                        
                        Spacer(minLength: 0)
                        
                        Text(TabItem.Message.rawValue)
                            .foregroundColor(self.currentTab == .Message ? .white : Color("TextColor").opacity(0.7))
                            .fontWeight(.bold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 10)
                            .background(Color("BackgroundColor").opacity(self.currentTab == .Message ? 1 : 0))
                            .clipShape(Capsule())
                            .onTapGesture {
                                self.currentTab = .Message
                            }
                        
                        Spacer(minLength: 0)
                    }
                    
                    // Mail, Calendar, Photo...
                    Group {
                        Text(TabItem.Mail.rawValue)
                            .foregroundColor(self.currentTab == .Mail ? .white : Color("TextColor").opacity(0.7))
                            .fontWeight(.bold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color("BackgroundColor").opacity(self.currentTab == .Mail ? 1 : 0))
                            .clipShape(Capsule())
                            .onTapGesture {
                                self.currentTab = .Mail
                        }
                        
                        Spacer(minLength: 0)
                        
                        Text(TabItem.Calendar.rawValue)
                            .foregroundColor(self.currentTab == .Calendar ? .white : Color("TextColor").opacity(0.7))
                            .fontWeight(.bold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 10)
                            .background(Color("BackgroundColor").opacity(self.currentTab == .Calendar ? 1 : 0))
                            .clipShape(Capsule())
                            .onTapGesture {
                                self.currentTab = .Calendar
                            }
                        
                        Spacer(minLength: 0)
                        
                        Text(TabItem.Photo.rawValue)
                            .foregroundColor(self.currentTab == .Photo ? .white : Color("TextColor").opacity(0.7))
                            .fontWeight(.bold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 30)
                            .background(Color("BackgroundColor").opacity(self.currentTab == .Photo ? 1 : 0))
                            .clipShape(Capsule())
                            .onTapGesture {
                                self.currentTab = .Photo
                            }
                    }
                }
            }
            .background(Color.black.opacity(0.06))
            .clipShape(Capsule())
            .padding(.horizontal, UIDevice.current.hasNotch ? 10 : 7)
            .padding(.top, UIDevice.current.hasNotch ? 25 : 15)
            
            // DashBoard Grid...
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, spacing: 30) {
                    ForEach(fitData) { fitness in
                        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
                            VStack(alignment: .leading, spacing: 20) {
                                Text(fitness.title)
                                
                                Text(fitness.data)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.top, 10)
                                
                                HStack {
                                    Spacer(minLength: 0)
                                    
                                    Text(fitness.suggest)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding()
                            .background(Color(fitness.image))
                            .cornerRadius(20)
                            // shadow...
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x:0, y:5)
                            
                            // top image...
                            Image(fitness.image)
                                .resizable()
                                .frame(width: 20, height: 20)
                                //.renderingMode(.template)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.white.opacity(0.12))
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 25)
            }
           
            Spacer(minLength: 0)
        }
        .padding(.top)
    }
}

// Grid View...


// Mock Data TODO: need to be deleted
struct Fitness: Identifiable {
    var id: Int
    var title: String
    var image: String
    var data: String
    var suggest: String
}

var fitData = [
    Fitness(id: 0, title: "Heart Rate", image: "heart", data: "124 bpm", suggest: "80-120 Healthy"),
    Fitness(id: 1, title: "Sleep", image: "sleep", data: "4h", suggest: "Deep Sleep"),
    Fitness(id: 2, title: "Sleep", image: "sleep", data: "6h 43m", suggest: "Deep Sleep"),
    Fitness(id: 3, title: "Heart Rate", image: "heart", data: "45 bpm", suggest: "80-120 Healthy"),
    Fitness(id: 4, title: "Sleep", image: "sleep", data: "10h 01m", suggest: "Deep Sleep"),
    Fitness(id: 5, title: "Heart Rate", image: "heart", data: "100 bpm", suggest: "80-120 Healthy"),
]
