//
//  UserCard.swift
//  FriendsApp
//
//  Created by JAHID HASAN POLASH on 21/5/21.
//

import UIKit

class UserCard: UICollectionViewCell {
    let image: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage.init(systemName: "person.fill")
        return iv
    }()
    let name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    let country: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.darkText
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        // load all views on content view
        setViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // load all views on content view
        setViews()
    }
    
    func setViews() {
        // Set round image avatar properties
        contentView.addSubview(image)
        NSLayoutConstraint.activate(
            [image.heightAnchor.constraint(equalToConstant: 100),
             image.widthAnchor.constraint(equalTo: image.heightAnchor)])
        image.layer.cornerRadius = 50
        image.layer.masksToBounds = true
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.borderWidth = 2
        
        // set labels
        contentView.addSubview(name)
        contentView.addSubview(country)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[name]-|", options: [], metrics: nil, views: ["name" : name]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[image]-20-[name]-[country]-20-|", options: [.alignAllCenterX], metrics: nil, views: ["image": image, "name" : name, "country": country]))
        
        // content view rounded corner
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
}
