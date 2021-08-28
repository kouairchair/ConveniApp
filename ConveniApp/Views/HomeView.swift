//
//  Home.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/07/15.
//

import SwiftUI

struct HomeView: View {
    
    @State var currentTab: TabItem = .Weather
    var topEdge: CGFloat
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
                    
//                    VStack {
//                        Text("Browser  Data")
//                    }
//                        .tag(TabItem.Browser)
//
//                    VStack {
//                        Text("Message  Data")
//                    }
//                    .tag(TabItem.Message)
//
//                    VStack {
//                        Text("Mail  Data")
//                    }
//                    .tag(TabItem.Mail)
//
//                    VStack {
//                        Text("Calendar  Data")
//                    }
//                    .tag(TabItem.Calendar)
//
//                    VStack {
//                        Text("Photo  Data")
//                    }
//                    .tag(TabItem.Photo)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
               
                Spacer(minLength: 0)
                
                // Tab View...
//                ScrollView(.horizontal, showsIndicators: false) {
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
                            
//                            Spacer(minLength: 0)
//
//                            Image(systemName: "desktopcomputer")
//                                .frame(width: tabItemWidth, height: tabItemHeight)
//                                .background(Color("BackgroundColor").opacity(self.currentTab == .Browser ? 1 : 0))
//                                .onTapGesture {
//                                    withAnimation(.default) {
//                                        self.currentTab = .Browser
//                                    }
//                                }
//
//                            Spacer(minLength: 0)
//
//                            Image(systemName: "person.2")
//                                .frame(width: tabItemWidth, height: tabItemHeight)
//                                .background(Color("BackgroundColor").opacity(self.currentTab == .Message ? 1 : 0))
//                                .onTapGesture {
//                                    withAnimation(.default) {
//                                        self.currentTab = .Message
//                                    }
//                                }
//
//                            Spacer(minLength: 0)
                        }
                        
                        // Mail, Calendar, Photo...
//                        Group {
//                            Image(systemName: "envelope.fill")
//                                .frame(width: tabItemWidth, height: tabItemHeight)
//                                .background(Color("BackgroundColor").opacity(self.currentTab == .Mail ? 1 : 0))
//                                .onTapGesture {
//                                    withAnimation(.default) {
//                                        self.currentTab = .Mail
//                                    }
//                                }
//
//                            Spacer(minLength: 0)
//
//                            Image(systemName: "calendar.circle.fill")
//                                .frame(width: tabItemWidth, height: tabItemHeight)
//                                .background(Color("BackgroundColor").opacity(self.currentTab == .Calendar ? 1 : 0))
//                                .onTapGesture {
//                                    withAnimation(.default) {
//                                        self.currentTab = .Calendar
//                                    }
//                                }
//
//                            Spacer(minLength: 0)
//
//                            Image(systemName: "photo.fill")
//                                .frame(width: tabItemWidth, height: tabItemHeight)
//                                .background(Color("BackgroundColor").opacity(self.currentTab == .Photo ? 1 : 0))
//                                .onTapGesture {
//                                    withAnimation(.default) {
//                                        self.currentTab = .Photo
//                                    }
//                                }
//                        }
//                    }
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
