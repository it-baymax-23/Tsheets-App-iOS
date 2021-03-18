//
//  AdminLoginViewController.swift
//  wowsheet
//
//  Created by AAA on 7/7/19.
//  Copyright © 2019 AAA. All rights reserved.
//

import UIKit

class AdminLoginViewController: UIViewController {

    @IBOutlet weak var user_email: UITextField!
    @IBOutlet weak var user_password: UITextField!
    
    
    let myPreferences = UserDefaults.standard
    let loginStatusKey = "loginStatus"
    let loginUserIdKey = "loginUserId"
    let loginUserNameKey = "loginUserName"
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginBtnClick(_ sender: Any) {
        
        let user = user_email.text!
        let password = user_password.text!
        let role = "admin"
        
        let params = "user=\(user)&password=\(password)&role=\(role)"
        
        guard let url = URL(string: "http://192.168.124.18/api/auth/signin") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = params.data(using: String.Encoding.utf8)

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            guard let data = data else { return }

            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                let success = jsonResult!["success"] as? Int
                if success == 1 {
                    print("OK")
                    
                    let userId = jsonResult!["user_id"]
                    
                    // to save login info with preference
                    self.myPreferences.set("login", forKey: self.loginStatusKey)
                    self.myPreferences.set(userId, forKey: self.loginUserIdKey)
                    self.myPreferences.set(user, forKey: self.loginUserNameKey)
                    
//                    let didSave = self.myPreferences.synchronize()
//                    if !didSave { }
                    
                    DispatchQueue.main.async() {
                        //self.showToast(message: "Login Successfully")
                        self.gotoAdminMainVC()
                    }
                    
                } else {
                    DispatchQueue.main.async() {
                        let alert = UIAlertController(title: "Wrong Login Info", message: "The login info you entered is wrong. Please try again or create one.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func gotoAdminMainVC() {
//        let adminMainVC = self.storyboard?.instantiateViewController(withIdentifier: "adminMainVC") as! AdminMainViewController
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController = adminMainVC
//
//
//        let   rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "adminMainVC") as! AdminMainViewController
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController = rootVC
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "adminMainVC") as! AdminMainViewController
        self.present(vc, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//extension UIViewController {
//
//    func showToast(message : String) {
//
//        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height-100, width: 200, height: 30))
//        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        toastLabel.textColor = UIColor.white
//        toastLabel.textAlignment = .center;
//        toastLabel.text = message
//        toastLabel.alpha = 1.0
//        toastLabel.layer.cornerRadius = 2;
//        toastLabel.clipsToBounds  =  true
//        self.view.addSubview(toastLabel)
//        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
//            toastLabel.alpha = 0.0
//        }, completion: {(isCompleted) in
//            toastLabel.removeFromSuperview()
//        })
//    }
//}

