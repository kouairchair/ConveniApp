//
//  JobView.swift
//  ConveniApp
//
//  Created by tanakabp on 2022/10/27.
//

import SwiftUI

struct JobView: View {
    @Binding var jobList: [Job]
    @State private var sliderVal : Double = 50
    
    var body: some View {
        ZStack {
            VStack {
                JobWebView()
                    .frame(height: sliderVal * 6)
                Slider(value: $sliderVal, in: 0...100)
                    .padding(.horizontal)
                    .accentColor(Color.gray)
                List {
                    ForEach(jobList) { job in
                        VStack(spacing: 5) {
                            HStack(spacing: 5) {
                                Image(job.jobType == .hiProTech ? "hipro_icon" : "codeal_icon")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 20, height: 20)
                                if let url = URL(string: job.href) {
                                    Link(job.title, destination: url)
                                        .foregroundStyle(.yellow, .white)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                } else {
                                    Text(job.title)
                                        .foregroundStyle(.yellow, .white)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                            }
                            
                            // TODO: need to add more...
                        }
                    }
                }
            }
        }
    }
}

struct JobView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

