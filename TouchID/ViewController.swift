//
//  ViewController.swift
//  TouchID
//
//  Created by Renato Mateus on 10/02/21.
//
import LocalAuthentication
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        view.addSubview(button)
        button.center = view.center
        button.setTitle("Authorize", for: .normal)
        button.backgroundColor = .systemGreen
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc func didTapButton(){
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Please authorize with touch id!"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){
                [weak self] success, error in
                DispatchQueue.main.async {
                    guard success, error == nil else{
                        //failed authentication
                        let alert = UIAlertController(title: "Failed to Authenticate", message: "Please try again", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                        self?.present(alert, animated: true)
                        return
                    }
                    //authorized
                    let vc = UIViewController()
                    vc.title = "Welcome!"
                    vc.view.backgroundColor = .systemBlue
                    self?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
                }
            }
        }
        else{
            if error?.code == -6 {
                let alert = UIAlertController(title: "Unavailable", message: "Biometry is not available on this device.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                present(alert, animated: true)
                return
            }
            //Cannot use this feature
            let alert = UIAlertController(title: "Unavailable", message: "You can't use this feature", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }


}

