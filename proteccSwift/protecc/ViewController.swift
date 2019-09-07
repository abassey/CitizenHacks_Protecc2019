//
//  ViewController.swift
//  protecc
//
//  Created by Anemme Bassey on 07/09/2019.
//  Copyright © 2019 Anemme Bassey. All rights reserved.
//

import UIKit
import Blockstack

class ViewController: UIViewController {

    @IBOutlet var signInButton: UIButton!
    
    private func updateUI() {
        DispatchQueue.main.async {
            if Blockstack.shared.isUserSignedIn() {
                // Read user profile data
                let retrievedUserData = Blockstack.shared.loadUserData()
                print(retrievedUserData?.profile?.name as Any)
               _ = retrievedUserData?.profile?.name ?? "Nameless Person"
                self.signInButton?.setTitle("Sign Out", for: .normal)
                print("UI update SIGNED_IN")
            } else {
                self.signInButton?.setTitle("Sign In", for: .normal)
                print("UI update SIGNED_OUT")
            }
        }
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        if Blockstack.shared.isUserSignedIn() {
            print("Currently signed in so signing out.")
            Blockstack.shared.signUserOut()
            self.updateUI()
        } else {
            print("Currently signed out so signing in.")
            // Address of deployed example web app
            Blockstack.shared.signIn(redirectURI: URL(string:"https://heuristic-brown-7a88f8.netlify.com/redirect.html")!,
                                     appDomain: URL(string: "https://heuristic-brown-7a88f8.netlify.com")!) { authResult in
                                        switch authResult {
                                        case .success(let userData):
                                            print("Sign in SUCCESS", userData.profile?.name as Any)
                                            self.updateUI()
                                        case .cancelled:
                                            print("Sign in CANCELLED")
                                        case .failed(let error):
                                            print("Sign in FAILED, error: ", error ?? "n/a")
                                        }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.updateUI()
    }

    

}

