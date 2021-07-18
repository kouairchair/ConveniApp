//
//  Home.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/07/15.
//

import SwiftUI

struct HomeView: View {
    
    var topEdge: CGFloat
    @State var currentTab: TabItem = .Weather
    let tabItemWidth: CGFloat = 60
    let tabItemHeight: CGFloat = 40

    var body: some View {
        ZStack {
            BackgroundView(currentTab: self.$currentTab)
                
            VStack {
                // Tab View With Swipe Gestures...
                
                // connecting index with tabview for tab change...
                
                TabView(selection: self.$currentTab) {
                    WeatherView(topEdge: topEdge)
                        .tag(TabItem.Weather)
                    
                    GridView(fitnesData: fitData)
                        .tag(TabItem.Browser)
                    
                    VStack {
                        Text("Message  Data")
                    }
                    .tag(TabItem.Message)
                    
                    VStack {
                        Text("Mail  Data")
                    }
                    .tag(TabItem.Mail)
                    
                    VStack {
                        Text("Calendar  Data")
                    }
                    .tag(TabItem.Calendar)
                    
                    VStack {
                        Text("Photo  Data")
                    }
                    .tag(TabItem.Photo)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
               
                Spacer(minLength: 0)
                
                // Tab View...
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        // Weather, Browser, Message...
                        Group {
                            WeatherTabView()
                                .frame(width: tabItemWidth, height: tabItemHeight)
                                .background(Color("BackgroundColor").opacity(self.currentTab == .Weather ? 1 : 0))
                                .onTapGesture {
                                    withAnimation(.default) {
                                        self.currentTab = .Weather
                                    }
                                }
                            
                            Spacer(minLength: 0)
                            
                            Image(systemName: "desktopcomputer")
                                .frame(width: tabItemWidth, height: tabItemHeight)
                                .background(Color("BackgroundColor").opacity(self.currentTab == .Browser ? 1 : 0))
                                .onTapGesture {
                                    withAnimation(.default) {
                                        self.currentTab = .Browser
                                    }
                                }
                            
                            Spacer(minLength: 0)
                            
                            Image(systemName: "person.2")
                                .frame(width: tabItemWidth, height: tabItemHeight)
                                .background(Color("BackgroundColor").opacity(self.currentTab == .Message ? 1 : 0))
                                .onTapGesture {
                                    withAnimation(.default) {
                                        self.currentTab = .Message
                                    }
                                }
                            
                            Spacer(minLength: 0)
                        }
                        
                        // Mail, Calendar, Photo...
                        Group {
                            Image(systemName: "envelope.fill")
                                .frame(width: tabItemWidth, height: tabItemHeight)
                                .background(Color("BackgroundColor").opacity(self.currentTab == .Mail ? 1 : 0))
                                .onTapGesture {
                                    withAnimation(.default) {
                                        self.currentTab = .Mail
                                    }
                                }
                            
                            Spacer(minLength: 0)
                            
                            Image(systemName: "calendar.circle.fill")
                                .frame(width: tabItemWidth, height: tabItemHeight)
                                .background(Color("BackgroundColor").opacity(self.currentTab == .Calendar ? 1 : 0))
                                .onTapGesture {
                                    withAnimation(.default) {
                                        self.currentTab = .Calendar
                                    }
                                }
                            
                            Spacer(minLength: 0)
                            
                            Image(systemName: "photo.fill")
                                .frame(width: tabItemWidth, height: tabItemHeight)
                                .background(Color("BackgroundColor").opacity(self.currentTab == .Photo ? 1 : 0))
                                .onTapGesture {
                                    withAnimation(.default) {
                                        self.currentTab = .Photo
                                    }
                                }
                        }
                    }
                }
                .background(Color.black.opacity(0.06))
                .clipShape(Capsule())
                .padding(.horizontal, UIDevice.current.hasNotch ? 10 : 7)
                
                Spacer()
                    .frame(height: UIDevice.current.hasNotch ? 10 : 7)
            }
            .padding(.top)
        }
        
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// TODO: This is just a sample view(need to be deleted later...)
struct GridView: View {
    var fitnesData: [Fitness]
    var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, spacing: 30) {
                ForEach(fitnesData) { fitness in
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
    }
}


// TODO: need to be deleted
struct Fitness: Identifiable {
    var id: Int
    var title: String
    var image: String
    var data: String
    var suggest: String
}

// TODO: need to be deleted
var fitData = [
    Fitness(id: 0, title: "Heart Rate", image: "heart", data: "124 bpm", suggest: "80-120 Healthy"),
    Fitness(id: 1, title: "Sleep", image: "sleep", data: "4h", suggest: "Deep Sleep"),
    Fitness(id: 2, title: "Sleep", image: "sleep", data: "6h 43m", suggest: "Deep Sleep"),
    Fitness(id: 3, title: "Heart Rate", image: "heart", data: "45 bpm", suggest: "80-120 Healthy"),
    Fitness(id: 4, title: "Sleep", image: "sleep", data: "10h 01m", suggest: "Deep Sleep"),
    Fitness(id: 5, title: "Heart Rate", image: "heart", data: "100 bpm", suggest: "80-120 Healthy"),
    Fitness(id: 6, title: "Heart Rate", image: "heart", data: "100 bpm", suggest: "80-120 Healthy"),
    Fitness(id: 7, title: "Heart Rate", image: "heart", data: "100 bpm", suggest: "80-120 Healthy"),
    Fitness(id: 8, title: "Heart Rate", image: "heart", data: "100 bpm", suggest: "80-120 Healthy"),
]
