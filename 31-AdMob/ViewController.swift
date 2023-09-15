//
//  ViewController.swift
//  31-AdMob
//
//  Created by Kerem Caan on 16.08.2023.
//

import UIKit
import SnapKit
import GoogleMobileAds

final class ViewController: UIViewController, GADFullScreenContentDelegate {
    
    private var interstitial: GADInterstitialAd?
    private var count = 0
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        startTimer()
    }
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        count += 1
        
        if count < 10 {
            if let interstitial = self.interstitial {
                interstitial.present(fromRootViewController: self)
            } else {
                print("Ad wasn't ready")
            }
        } else {
            timer?.invalidate()
            timer = nil
        }
    }
    
    private func setupUI() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3940256099942544/4411468910", request: request, completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
        })
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        let vc = SecondViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
    
    @objc private func buttonTapped() {
        if let interstitial = self.interstitial {
            print("deneme")
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
}
