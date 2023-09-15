//
//  SecondViewController.swift
//  31-AdMob
//
//  Created by Kerem Caan on 16.08.2023.
//

import UIKit
import SnapKit
import GoogleMobileAds

final class SecondViewController: UIViewController, GADFullScreenContentDelegate {
    
    private let banner: GADBannerView = {
        let banner = GADBannerView()
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        banner.load(GADRequest())
        banner.backgroundColor = .secondarySystemBackground
        return banner
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.setTitle("Reklam", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchDown)
        return button
    }()
    
    private var rewardedAd: GADRewardedAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        loadRewardedAd()
    }
    
    private func setupUI() {
        view.addSubview(banner)
        view.addSubview(button)
        
        banner.rootViewController = self
        
        banner.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-20)
            make.width.equalTo(view.frame.size.width)
            make.height.equalTo(50)
        }
        
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.2)
        }
    }
    
    func loadRewardedAd() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID:"ca-app-pub-3940256099942544/1712485313",
                           request: request,
                           completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                return
            }
            rewardedAd = ad
            rewardedAd?.fullScreenContentDelegate = self
            print("Rewarded ad loaded.")
        })
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        let vc = ThirdViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func buttonTapped() {
        if let ad = rewardedAd {
            ad.present(fromRootViewController: self) {
                let reward = ad.adReward
                print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
                
            }
        } else {
            print("Ad wasn't ready")
        }
    }
}
