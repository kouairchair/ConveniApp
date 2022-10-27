//
//  JobView.swift
//  ConveniApp
//
//  Created by tanakabp on 2022/10/27.
//

import SwiftUI

struct JobView: View {
    @Binding var jobList: [Job]
    
    var body: some View {
        ZStack {
            List {
                ForEach(jobList) { job in
                    VStack(spacing: 5) {
                        if let url = URL(string: job.href) {
                            Link(job.title, destination: url)
                                .foregroundStyle(.yellow, .white)
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            Text(job.title)
                                .foregroundStyle(.yellow, .white)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        // TODO: need to add more...
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

