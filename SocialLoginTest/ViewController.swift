//
//  ViewController.swift
//  SocialLoginTest
//
//  Created by Sherif  Wagih on 9/21/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import TwitterKit
class ViewController: UIViewController,FBSDKLoginButtonDelegate,GIDSignInUIDelegate {
    
    fileprivate func setupTwitterButton()
    {
        let twitterButton = TWTRLogInButton { (session, error) in
            if let err = error{
                print("failed to login via Twitter:",err)
            }
            print("successfully Logged In")
        }
        view.addSubview(twitterButton)
        twitterButton.frame =  CGRect(x: 16, y: 116 + 66 + 66 + 66, width: view.frame.width - 32, height: 50)

    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil
        {
            print(error)
            return
        }
        else
        {
            print("logged in")
          self.showEmailAddress()
        }
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logged out of facebook!")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTwitterButton()
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self
        let customFBLoginButton = UIButton(type: .system)
        customFBLoginButton.backgroundColor = .blue
        view.addSubview(customFBLoginButton)
        customFBLoginButton.frame = CGRect(x: 16, y: 116, width: view.frame.width - 32, height: 50)
        customFBLoginButton.setTitle("Login With FB SDK", for: .normal)
        customFBLoginButton.setTitleColor(.white, for: .normal)
        customFBLoginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        customFBLoginButton.addTarget(self, action: #selector(handleCustomLogin), for: .touchUpInside)
       // loginButton.readPermissions = ["email","public_profile"]
        let googleLoginButton = GIDSignInButton()
        googleLoginButton.frame = CGRect(x: 16, y: 116 + 66, width: view.frame.width - 32, height: 50)
        view.addSubview(googleLoginButton)
        GIDSignIn.sharedInstance().uiDelegate = self
        let customGoogleLogin = UIButton()
        customGoogleLogin.setTitle("Custom Google Sign In", for: .normal)
        customGoogleLogin.backgroundColor = .orange
        customGoogleLogin.setTitleColor(.white, for: .normal)
        customGoogleLogin.frame =  CGRect(x: 16, y: 116 + 66 + 66, width: view.frame.width - 32, height: 50)
        customGoogleLogin.addTarget(self, action: #selector(handleGoogleLogin), for: .touchUpInside)
        view.addSubview(customGoogleLogin)
        
        
    }
    @objc func handleGoogleLogin()
    {
        GIDSignIn.sharedInstance().signIn()
    }
    @objc func handleCustomLogin()
    {
      
        FBSDKLoginManager().logIn(withReadPermissions: ["email","public_profile"], from: self) { (result, error) in
            if error != nil
            {
                print(error!)
                return
            }
            self.showEmailAddress()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func showEmailAddress()
    {
        if let tokenString = FBSDKAccessToken.current().tokenString
        {
            let credentials = FacebookAuthProvider.credential(withAccessToken: tokenString)
            Auth.auth().signInAndRetrieveData(with: credentials) { (user, error) in
                if error != nil
                {
                    print(error!)
                    return
                }
            }
        }
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id , name, email"]).start { (connection, result, err) in
            if err != nil
            {
                print("failed to start graph request",err!)
                return
            }
            print(result!)
        }
    }
}

