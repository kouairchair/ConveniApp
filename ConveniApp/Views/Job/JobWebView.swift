//
//  JobWebView.swift
//  ConveniApp
//
//  Created by tanakabp on 2022/11/02.
//

import SwiftUI
import WebKit

struct JobWebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    
    let webView: WKWebView
    
    init() {
        webView = WKWebView(frame: .zero)
        if let jobUrl = URL(string: Constants.atEngineerJobListUrl) {
            webView.load(URLRequest(url: jobUrl))
        }
    }
    
    func makeUIView(context: Context) -> WKWebView {
        webView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}
