//
//  SceneCoordinatorType.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2021-08-21.
//  Copyright © 2021 Argus Chen. All rights reserved.

import UIKit
import RxSwift

protocol SceneCoordinatorType {
  /// transition to another scene
  @discardableResult
  func transition(to scene: Scene, type: SceneTransitionType) -> Completable

  /// pop scene from navigation stack or dismiss current modal
  @discardableResult
  func pop(animated: Bool) -> Completable
}

extension SceneCoordinatorType {
  @discardableResult
  func pop() -> Completable {
    return pop(animated: true)
  }
}

