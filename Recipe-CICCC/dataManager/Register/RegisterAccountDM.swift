//
//  RegisterEmailDM.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2021-08-21.
//  Copyright © 2021 Shihomi Kitajima. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

enum Errors: Error {
    case registerFailed, requestRefused, invailedUser, failedTosendEmailVerification, unavailable
}


protocol RegisterAccountProtocol {
    
    static func registerEmail(email: String, password: String) -> Observable<Bool>
}


class RegisterAccountDM: RegisterAccountProtocol {
    
    enum registerStatus {
        case failed(Errors), success
    }
    
    
    static func registerEmail<T: Any>(email: String, password: String) ->  Observable<T> {
        
        return Observable.create { observer in
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                
                if let error = error {
                    //                let alertController = UIAlertController(title: "Registration Error", message: error.localizedDescription, preferredStyle: .alert)
                    //                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    //                alertController.addAction(okayAction)
                    //                self.present(alertController, animated: true, completion: nil)
                    
                    print("Failed to register the display name: \(error.localizedDescription)")
                    observer.onError(Errors.registerFailed)
                    return
                }
                
                if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest(){
                    changeRequest.commitChanges(completion: { error in
                        if let error = error {
                            print("Failed to change the display name: \(error.localizedDescription)")
                            observer.onError(Errors.requestRefused)
                        }
                    })
                }
                
                Auth.auth().currentUser?.sendEmailVerification { err in
                    observer.onError(Errors.failedTosendEmailVerification)
                    return
                }
                
                //                let alertController = UIAlertController(title: "Email Verification", message: "We've just sent a confirmation email to your email address. Please check yourinbox and click the verification link in that email to complete the sign up.", preferredStyle: .alert)
                //                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                //                    self.view.endEditing(true)
                //
                //                })
                //                alertController.addAction(okayAction)
                //                self.present(alertController, animated: true, completion: nil)
                //
                if let isEmailVerified = result?.user.isEmailVerified as? T {
                    observer.onNext(isEmailVerified)
                } else {
                    observer.onError(Errors.invailedUser)
                }
                
            }
            
            return Disposables.create {}
            
        }
    }
    
    
    
}
