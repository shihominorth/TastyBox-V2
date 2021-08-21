//
//  SceneTransitionType.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2021-08-21.
//  Copyright © 2021 Shihomi Kitajima. All rights reserved.
//

import Foundation

enum SceneTransitionType {
  // you can extend this to add animated transition types,
  // interactive transitions and even child view controllers!

  case root       // make view controller the root view controller
  case push       // push view controller to navigation stack
  case modal      // present view controller modally
}

