//
//  Banner.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/03/04.
//

import SwiftUI
import GoogleMobileAds

struct GADBannerViewController: UIViewControllerRepresentable {
    
    @State private var banner: GADBannerView = GADBannerView(adSize: kGADAdSizeBanner)
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        banner.adSize = kGADAdSizeBanner
        #if DEBUG
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        #else
        banner.adUnitID = "ca-app-pub-4395679975264140/9621516566"
        #endif
        banner.rootViewController = viewController
        viewController.view.addSubview(banner)
        viewController.view.frame = CGRect(origin: .zero, size: kGADAdSizeBanner.size)
        banner.load(GADRequest())
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }

}
