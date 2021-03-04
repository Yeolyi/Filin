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
        let bannerSize = GADBannerViewController.getAdBannerSize()
        let viewController = UIViewController()
        banner.adSize = bannerSize
        #if DEBUG
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        #else
        banner.adUnitID = "ca-app-pub-4395679975264140/9621516566"
        #endif
        banner.rootViewController = viewController
        viewController.view.addSubview(banner)
        viewController.view.frame = CGRect(origin: .zero, size: bannerSize.size)
        banner.load(GADRequest())
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context){
        let bannerSize = GADBannerViewController.getAdBannerSize()
        banner.frame = CGRect(origin: .zero, size: bannerSize.size)
        banner.load(GADRequest())
    }
    
    static func getAdBannerSize() -> GADAdSize {
        if let rootView = UIApplication.shared.windows.first?.rootViewController?.view {
            let frame = rootView.frame.inset(by: rootView.safeAreaInsets)
            return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(frame.width)
        }
        //No root VC, use 320x50 ad banner
        return kGADAdSizeBanner
    }
}
