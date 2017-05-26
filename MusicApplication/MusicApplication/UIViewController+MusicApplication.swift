//
//  UIViewController+MusicApplication.swift
//  MusicApplication
//
//  Created by Sidramappa Halake on 24/05/17.
//  Copyright © 2017 Sidramappa Halake. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func addActivateIndicator() {
        let activityIndicator = UIActivityIndicatorView.init(frame: CGRect.init(origin: view.center, size: CGSize.init(width: 30, height: 30)))
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.tag = 100
        activityIndicator.startAnimating()
//        view.backgroundColor = UIColor.white
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }
    
    func stopActivityIndicator() {
        if let activityIndicator = view.viewWithTag(100) as? UIActivityIndicatorView {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
//            view.backgroundColor = UIColor.clear
        }
    }
    
    func showAlert(for title: String?, message: String?) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
