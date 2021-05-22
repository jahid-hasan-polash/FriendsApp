//
//  UserDetailsController.swift
//  FriendsApp
//
//  Created by JAHID HASAN POLASH on 22/5/21.
//

import UIKit

class UserDetailsController: UIViewController {
    let infoContainer = InfoContainer()
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
        view.backgroundColor = .systemGroupedBackground
        // set user info views
        setViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // refresh views to show user info
        infoContainer.setUserInfo(user: user)
    }
    
    func setViews() {
        view.addSubview(infoContainer)
        infoContainer.emailAddressTapped = emailAddressTapped
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[info]-|", options: [], metrics: nil, views: ["info": infoContainer]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[info]-(>=8)-|", options: [], metrics: nil, views: ["info": infoContainer]))
    }
    
    func emailAddressTapped() {
        guard let emailAddress = user.email else { return }
        // mailto: urls will be handled by the default email application
        if let url = URL(string: "mailto://\(emailAddress)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        } else {
            let alert = UIAlertController(title: "Error", message: "Openning Email App failed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in }))
            present(alert, animated: true)
        }
    }
}
