//
//  ViewController.swift
//  GoogleDriveIntegration
//
//  Created by Kunal Gupta on 15/01/20.
//  Copyright © 2020 Kunal Gupta. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if GIDSignIn.sharedInstance()?.currentUser != nil {
            GIDSignIn.sharedInstance()?.signInSilently()
        }
    }
    
    func fetchFiles(_ user: GIDGoogleUser) {
        guard let vc = self.storyboard?.instantiateViewController(identifier: "CloudFilesVC") as? CloudFilesVC else {
            return
        }
        vc.service.authorizer = user.authentication.fetcherAuthorizer()
        self.present(vc, animated: true)
    }
    
    @IBAction func actionBtnLogin(_ sender: Any) {
        if let user = GIDSignIn.sharedInstance()?.currentUser {
            fetchFiles(user)
        } else {
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().scopes = [kGTLRAuthScopeDrive]
            GIDSignIn.sharedInstance()?.signIn()
        }
    }
}

extension ViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error {
            // showAlert
        } else {
            fetchFiles(user)
        }
    }
}
