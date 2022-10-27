//
//  Home.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/07/15.
//

import SwiftUI

struct HomeView: View {
    
    @State var currentTab: TabItem = .Weather
    @State var locality: String = ""
    @State var weather: Weather = Weather()
    @State var newsList: [News] = []
    @State var jobList: [Job] = []
    @State private var alertMessage: AlertMessage?
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
                    WeatherView(topEdge: topEdge, locality: $locality, weather: $weather)
                        .tag(TabItem.Weather)
                    
                    NewsView(newsList: $newsList)
                        .tag(TabItem.Browser)

                    JobView(jobList: $jobList)
                        .tag(TabItem.Job)
                    
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
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
               
                Spacer(minLength: 0)
                
                // Tab View...
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        // Weather, Browser, Message...
                        Group {
                            Image(systemName: "cloud.sun.fill")
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

                            Image(systemName: "latch.2.case")
                                .frame(width: tabItemWidth, height: tabItemHeight)
                                .background(Color("BackgroundColor").opacity(self.currentTab == .Job ? 1 : 0))
                                .onTapGesture {
                                    withAnimation(.default) {
                                        self.currentTab = .Job
                                    }
                                }

                            Spacer(minLength: 0)
                        }
                        
                        // Mail, Calendar, Photo...
                        Group {
                            Image(systemName: "person.2")
                                .frame(width: tabItemWidth, height: tabItemHeight)
                                .background(Color("BackgroundColor").opacity(self.currentTab == .Message ? 1 : 0))
                                .onTapGesture {
                                    withAnimation(.default) {
                                        self.currentTab = .Message
                                    }
                                }
                            
                            Spacer(minLength: 0)

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
        .onAppear() {
            Task.init(priority: .medium) {
                do {
                    if let _locality = try await WeatherFetcher.shared.fetchLocality() {
                        locality = _locality
                        do {
                            weather = try await WeatherFetcher.shared.fetchWeather()
                        } catch {
                            logger.error("fetchWeather failed:\(error)")
                            if Constants.isDebug {
                                self.alertMessage = AlertMessage(message: String(format: LcliConstants.fetchWeatherFailed.translate(), [error]))
                            }
                        }
                    }
                } catch {
                    logger.error("fetchLocality failed:\(error)")
                    if Constants.isDebug {
                        self.alertMessage = AlertMessage(message: String(format: LcliConstants.fetchLocationFailed.translate(), [error]))
                    }
                }
                
                do {
                    newsList = try await NewsFetcher.shared.fetchNews()
                } catch {
                    logger.error("fetchNews failed:\(error)")
                    if Constants.isDebug {
                        self.alertMessage = AlertMessage(message: String(format: LcliConstants.fetchNewsFailed.translate(), [error]))
                    }
                }
                
                do {
                    jobList = try await JobFetcher.shared.fetchJobs()
                } catch {
                    logger.error("fetchJobs failed:\(error)")
                    if Constants.isDebug {
                        self.alertMessage = AlertMessage(message: String(format: LcliConstants.fetchJobsFailed.translate(), [error]))
                    }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            // REMARK: priorityは優先度高い順にhigh,userInitiated,medium,low,utility,background
            Task.init(priority: .low) {
                do {
                    if let _locality = try await WeatherFetcher.shared.fetchLocality() {
                        locality = _locality
                        do {
                            weather = try await WeatherFetcher.shared.fetchWeather()
                        } catch {
                            logger.error("fetchWeather failed:\(error)")
                            if Constants.isDebug {
                                self.alertMessage = AlertMessage(message: String(format: LcliConstants.fetchWeatherFailed.translate(), [error]))
                            }
                        }
                    }
                } catch {
                    logger.error("fetchLocality failed:\(error)")
                    if Constants.isDebug {
                        self.alertMessage = AlertMessage(message: String(format: LcliConstants.fetchLocationFailed.translate(), [error]))
                    }
                }

                do {
                    newsList = try await NewsFetcher.shared.fetchNews()
                } catch {
                    logger.error("fetchNews failed:\(error)")
                    if Constants.isDebug {
                        self.alertMessage = AlertMessage(message: String(format: LcliConstants.fetchNewsFailed.translate(), [error]))
                    }
                }
            }
        }
//        .onReceive(NotificationCenter.default.publisher(for: Constants.locationRequestApprovedNotification) { notification in
//
//        }
        .alert(item: $alertMessage) { alert in
            Alert(title: Text(LcliConstants.errorMessage.translate()), message: Text(alert.message), dismissButton: .cancel())
        }
    }
    
    func fetchDatas() {
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
