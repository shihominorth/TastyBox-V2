//
//  Scene+ViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2021-08-21.
//  Copyright © 2021 Shihomi Kitajima. All rights reserved.
//

import UIKit

extension Scene {
    func viewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        
        switch self {
        
        case  .login(.main(let viewModel)):
            let nc = storyboard.instantiateViewController(withIdentifier: "LoginMain") as! UINavigationController
            let vc = nc.viewControllers.first as! LoginMainPageViewController
            vc.bindViewModel(to: viewModel)
            return nc
            
        case .login(.email(let viewModel)):
            let nc = storyboard.instantiateViewController(withIdentifier: "EditTask") as! UINavigationController
            let vc = nc.viewControllers.first as! EmailRegisterViewController
            vc.bindViewModel(to: viewModel)
            return nc
            
        case .login(.resetPassword(let viewModel)):
            let nc = storyboard.instantiateViewController(withIdentifier: "EditTask") as! UINavigationController
            let vc = nc.viewControllers.first as! ResetPasswordViewController
            vc.bindViewModel(to: viewModel)
            return nc
            
        case .login(.profile(let viewModel)):
            let nc = storyboard.instantiateViewController(withIdentifier: "EditTask") as! UINavigationController
            let vc = nc.viewControllers.first as! FirstTimeUserProfileTableViewController
            vc.bindViewModel(to: viewModel)
            return nc
            
        default:
            break
        }
        
    }
}
