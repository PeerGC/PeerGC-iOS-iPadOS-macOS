//
//  EnterPasswordVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 8/3/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class EnterPasswordVC: GenericStructureViewController {
    static var email: String?
    
    override func viewDidLoad() {
        metaDataDelegate = self
        textFieldDelegate = self
        super.viewDidLoad()
        addForgotPasswordButton()
        textField?.autocapitalizationType = .none
        textField?.textContentType = .password
        textField?.isSecureTextEntry = true
    }
    
    func addForgotPasswordButton() {
        let forgotPasswordButton = DesignableButton()
        forgotPasswordButton.setTitle("Forgot Password?", for: .normal)
        forgotPasswordButton.setTitleColor(.link, for: .normal)
        forgotPasswordButton.titleLabel!.font = UIFont(name: fontName, size: 16)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
        
        addAndConstraint(customView: forgotPasswordButton, constraints:
            [view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: forgotPasswordButton.trailingAnchor, constant: 60),
             view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: forgotPasswordButton.leadingAnchor, constant: -60),
             NSLayoutConstraint(item: forgotPasswordButton, attribute: .top, relatedBy: .equal,
                                toItem: errorLabel, attribute: .bottom, multiplier: 1, constant: 6)])
    }
    
    func error(text: String) {
        errorLabel?.isHidden = false
        errorLabel?.text = text
    }
    
    func noError(nextViewController: UIViewController) {
        EmailVC.email = textField!.text
        nextViewControllerHandler(viewController: nextViewController)
        errorLabel!.isHidden = true
    }
    
    override func textFieldContinueButtonHandler() {
        guard let text = textField?.text else {
            error(text: "Invalid.")
            return
        }
        
        Auth.auth().signIn(withEmail: EmailVC.email!, password: text) { [weak self] _, error in
            
            if error != nil {
                let errorCode = AuthErrorCode(rawValue: error!._code)
                
                switch errorCode {
                    case .wrongPassword:
                        self?.errorLabel!.text = "Wrong Password."
                    case .networkError:
                        self?.errorLabel!.text = "Network Error."
                    default:
                        self?.errorLabel!.text = "Error Signing In."
                }
                self?.errorLabel!.isHidden = false
            } else {
                self?.errorLabel!.isHidden = true
                let uid = Auth.auth().currentUser!.uid
                let docRef = Firestore.firestore().collection(DatabaseKey.Users.name).document(uid)
                
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        Firestore.firestore().collection(DatabaseKey.Users.name).document(uid).collection(DatabaseKey.Allow_List.name).getDocuments(completion: { (_, _) in
                            
                            Utilities.loadHomeScreen()
                        })
                    } else {
                        self?.nextViewControllerHandler(viewController: NameVC())
                    }
                }
            }
        }
    }
    
    @objc func forgotPassword(_ sender: UIButton) {
        Auth.auth().sendPasswordReset(withEmail: EmailVC.email!) { [weak self] error in
            
            if error != nil {
                
                let errorCode = AuthErrorCode(rawValue: error!._code)
                
                switch errorCode {
                    case .wrongPassword:
                        self!.errorLabel!.text = "Wrong Password."
                    case .networkError:
                        self!.errorLabel!.text = "Network Error."
                    default:
                        self!.errorLabel!.text = "Error Signing In."
                }
                
                self!.errorLabel!.isHidden = false
            } else {
                self!.nextViewControllerHandler(viewController: ResetPasswordVC())
            }
        }
    }
    
}

extension EnterPasswordVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "What is your password?"
    }
    
    func subtitle() -> String? {
        return "You will be logged in."
    }
    
    func nextViewController() -> UIViewController? {
        return nil
    }
}

extension EnterPasswordVC: TextFieldDelegate {
    func continuePressed(textInput: String?) -> String? {
        return nil // does nothing
    }
}
