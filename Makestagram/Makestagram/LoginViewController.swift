//
//  LoginViewController.swift
//  Makestagram
//
//  Created by Lauren Weiss on 6/26/17.
//  Copyright © 2017 Lauren Weiss. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase

typealias FIRUser = FirebaseAuth.User

class LoginViewController: UIViewController {
    
    // MARK: -Properties
    
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: -VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: -IB Actions
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        
        authUI.delegate = self
        
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }
    
}

extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
        }
        guard let user = user
        
            else { return }
        
        let userRef = Database.database().reference().child("users").child(user.uid)
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let user = User(snapshot: snapshot) {
                print("Welcome back, \(user.username).")
            } else {
                print("New user!")
            }
        })
}
}
