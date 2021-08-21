//
//  Scene.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2021-08-21.
//  Copyright © 2021 Shihomi Kitajima. All rights reserved.
//
import Foundation

enum Scene {
    case login(Login)
    case profile(Profile)
}

enum Login {
    case main(LoginMainVM)
    case email(RegisterEmailVM)
    case resetPassword(ResetPasswordVM)
    case profile(RegisterUserProfileVM)
}

enum Profile {
    case myPage(MyPageVM)
    case followerFollowing(FollowerFollowingVM)
    case following(FollowingVM)
    case follower(FollowerVM)
    case savedRecipe(SavedRecipeVM)
}



