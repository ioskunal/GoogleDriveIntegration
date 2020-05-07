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
import GTMSessionFetcher

class ViewController: UIViewController {
    
    //MARK:- OUTLETS

    @IBOutlet weak var fetchFilesButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK:- LIFE CYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialise()
    }
        
    //MARK:- HELPER METHODS
    
    private func initialise() {
        if GIDSignIn.sharedInstance()?.currentUser != nil {
            loginButton.setTitle("Logout", for: .normal)
            fetchFilesButton.isHidden = false
        } else {
            loginButton.setTitle("Login", for: .normal)
            fetchFilesButton.isHidden = true
        }
    }
    
    private func fetchFiles(_ user: GIDGoogleUser) {
        guard let vc = self.storyboard?.instantiateViewController(identifier: "CloudFilesVC") as? CloudFilesVC else {
            return
        }
        vc.service.authorizer = user.authentication.fetcherAuthorizer()
        self.present(vc, animated: true)
    }
    
    //MARK:- ACTION BUTTONS
    
    @IBAction func actionBtnLogin(_ sender: Any) {
        if GIDSignIn.sharedInstance()?.currentUser != nil {
            GIDSignIn.sharedInstance()?.signOut()
            initialise()
        } else {
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance()?.presentingViewController = self
            GIDSignIn.sharedInstance().scopes = [kGTLRAuthScopeDriveReadonly]
            GIDSignIn.sharedInstance()?.signIn()
        }
    }
    
    @IBAction func actionBtnFetchFiles(_ sender: Any) {
        if let user = GIDSignIn.sharedInstance()?.currentUser {
            fetchFiles(user)
        }
    }
}

extension ViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error {
            Alert.show(message: error.localizedDescription)
        } else {
            fetchFiles(user)
            initialise()
        }
    }
}
