//
//  InfoContainer.swift
//  FriendsApp
//
//  Created by JAHID HASAN POLASH on 22/5/21.
//

import UIKit

class InfoContainer: UIStackView {
    let userImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage.init(systemName: "person.fill")
        return iv
    }()
    let fullName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    let address: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.darkText
        label.textAlignment = .center
        return label
    }()
    let stateAddress: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.darkText
        label.textAlignment = .center
        return label
    }()
    let cellPhone: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.darkText
        label.textAlignment = .center
        return label
    }()
    let email: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 19)
        label.textColor = UIColor.darkText
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    
    var emailAddressTapped: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setViews()
    }
    
    func setViews() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        distribution = .fill
        alignment = .center
        spacing = 8
        // Just to make visually pleasing and add a small padding on the top
        // add an empty view to the stack
        addArrangedSubview(UIView())
        
        // set user avatar properties and add it to the stack
        NSLayoutConstraint.activate(
            [userImage.heightAnchor.constraint(equalToConstant: 200),
             userImage.widthAnchor.constraint(equalTo: userImage.heightAnchor)])
        userImage.layer.cornerRadius = 100
        userImage.layer.masksToBounds = true
        userImage.layer.borderColor = UIColor.lightGray.cgColor
        userImage.layer.borderWidth = 2
        addArrangedSubview(userImage)
        // add other components to the stack
        addArrangedSubview(fullName)
        addArrangedSubview(address)
        addArrangedSubview(stateAddress)
        addArrangedSubview(cellPhone)
        addArrangedSubview(email)
        // add a tap gesture recognizer to the email
        let tap = UITapGestureRecognizer(target: self, action: #selector(emailAddressTapped(_:)))
        email.addGestureRecognizer(tap)
    }
    
    // On parent controller view will appear method
    // refresh all the views with user data
    func setUserInfo(user: User) {
        // if cache has users image set it directly
        // else download it in the global thread and set it in the cell later
        if let imgUrl = user.picture?.medium,
           let url = URL(string: imgUrl) {
            if let image = ImageCache.global.imagesDictionary[imgUrl] {
                userImage.image = image
            } else {
                DispatchQueue.global().async {
                    if let imageData = try? Data(contentsOf: url) {
                        let img = UIImage(data: imageData)
                        // Update cache
                        ImageCache.global.imagesDictionary[imgUrl] = img
                        // set cell image
                        DispatchQueue.main.async {
                            self.userImage.image = img
                        }
                    }
                }
            }
        }
        fullName.text = user.name?.getFullName()
        address.text = user.location?.getStreetAddress()
        stateAddress.text = user.location?.getStateAddress()
        cellPhone.text = user.cell
        if let emailAddress = user.email {
            let attributedString = NSAttributedString(string: emailAddress, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
            email.attributedText = attributedString
        }
    }
    
    @objc func emailAddressTapped(_ sender: UITapGestureRecognizer) {
        // email address tap action will be handled in the parent controller
        // thus call the callback function
        emailAddressTapped?()
    }
}
