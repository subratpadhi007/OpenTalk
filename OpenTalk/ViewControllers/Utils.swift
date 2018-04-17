//
//  Utils.swift
//  OpenTalk
//
//  Created by SUBRAT on 4/16/18.
//  Copyright © 2018 Open Talk. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        guard let urlStr = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else { return }
        Alamofire.request(urlStr).responseData { response in
            if let dt = response.result.value {
                DispatchQueue.main.async(execute: { () -> Void in
                    let image = UIImage(data: dt)
                    self.image = image
                })
            }
        }
    }
}


struct ViewUtils {

    // Activity Indicator

    static let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

    static func removeActivityView(view : UIView) {
        let window = UIApplication.shared.keyWindow!
        window.viewWithTag(111)?.removeFromSuperview()
        view.isUserInteractionEnabled = true
    }

    static func addActivityView(view : UIView) {

        let window = UIApplication.shared.keyWindow!
        window.viewWithTag(111)?.removeFromSuperview()

        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: window.frame.size.width , height: window.frame.size.height + 80 )
        //        loadingView.backgroundColor = UIColor(colorLiteralRed: 0.0, green: 0.00, blue: 0.00, alpha: 0.5)
        loadingView.clipsToBounds = true
        loadingView.tag = 111
        //        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)

        activityView.frame = CGRect(x: loadingView.frame.size.width/2 , y: loadingView.frame.size.height / 2, width: 100, height: 100)
        activityView.layer.cornerRadius = 10
        activityView.center = view.center
        activityView.tintColor = UIColor.white
        activityView.backgroundColor = UIColor.lightText

        view.isUserInteractionEnabled = false
        activityView.startAnimating()
        loadingView.addSubview(activityView)
        window.addSubview(loadingView)

    }
}
