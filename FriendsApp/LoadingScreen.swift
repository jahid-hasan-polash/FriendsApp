//
//  LoadingScreen.swift
//  FriendsApp
//
//  Created by JAHID HASAN POLASH on 21/5/21.
//

import UIKit

class LoadingScreen: UIView {
    private var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    private var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 24)
        label.text = "Please wait"
        label.textAlignment = .center
        return label
    }()
    private var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 17)
        label.numberOfLines = 0
        label.text = "Loading.."
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadComponents()
    }
    
    init(containerColor: UIColor, textColor: UIColor, activityStyle: UIActivityIndicatorView.Style) {
        super.init(frame: CGRect.zero)
        loadComponents()
        setProperties(containerColor: containerColor, textColor: textColor, activityStyle: activityStyle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadComponents() {
        backgroundColor = UIColor.black.withAlphaComponent(0.4)
        addSubview(container)
        container.addSubview(titleLabel)
        let secondContainer = UIView()
        secondContainer.backgroundColor = .clear
        secondContainer.translatesAutoresizingMaskIntoConstraints = false
        secondContainer.addSubview(activityIndicator)
        secondContainer.addSubview(messageLabel)
        let views = ["message": messageLabel, "activity": activityIndicator]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[activity]-[message]-0-|", options: [.alignAllCenterY], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[message]-|", options: [], metrics: nil, views: views))
        container.addSubview(secondContainer)
        setContraints(for: ["container": container, "title": titleLabel, "secondContainer": secondContainer])
        activityIndicator.startAnimating()
    }
    
    private func setProperties(containerColor: UIColor, textColor: UIColor, activityStyle: UIActivityIndicatorView.Style) {
        container.backgroundColor = containerColor
        titleLabel.textColor = textColor
        messageLabel.textColor = textColor
        activityIndicator.style = activityStyle
    }
    
    public func reloadView(_ message: String?) {
        messageLabel.text = message
    }
    
    private func  setContraints(for views: [String: Any]) {
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[title]-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-24-[title]-8-[secondContainer]-24-|", options: [.alignAllCenterX], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-24-[container]-24-|", options: [.alignAllLeading], metrics: nil, views: views))
        container.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}

class LoadingScreenPresenter {
    class func presentLoadingScreen(message: String?, containerColor: UIColor = .white, textColor: UIColor = .black, activityStyle: UIActivityIndicatorView.Style = UIActivityIndicatorView.Style.medium) {
        if let window = UIApplication.shared.windows.first {
            if let loader = window.viewWithTag(9631) as? LoadingScreen {
                loader.reloadView(message)
            } else {
                let loader = LoadingScreen(containerColor: containerColor, textColor: textColor, activityStyle: activityStyle)
                loader.reloadView(message)
                loader.tag = 9631
                loader.translatesAutoresizingMaskIntoConstraints = false
                window.addSubview(loader)
                NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[loader]-0-|", options: [], metrics: nil, views: ["loader": loader]))
                NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[loader]-|", options: [], metrics: nil, views: ["loader": loader]))
            }
        }
    }
    
    class func removeLoadingScreen() {
        if let window = UIApplication.shared.windows.first,
            let loader = window.viewWithTag(9631) {
            loader.removeFromSuperview()
        }
    }
}

extension UIViewController {
    func showLoadingScreen(message: String?) {
        if let window = UIApplication.shared.windows.first {
            if let loader = window.viewWithTag(9631) as? LoadingScreen {
                loader.reloadView(message)
            } else {
                let loader = LoadingScreen(containerColor: .white, textColor: .black, activityStyle: UIActivityIndicatorView.Style.medium)
                loader.reloadView(message)
                loader.tag = 9631
                loader.translatesAutoresizingMaskIntoConstraints = false
                window.addSubview(loader)
                NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[loader]-0-|", options: [], metrics: nil, views: ["loader": loader]))
                NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[loader]-0-|", options: [], metrics: nil, views: ["loader": loader]))
            }
        }
    }
    
    func removeLoadingScreen() {
        if let window = UIApplication.shared.windows.first,
            let loader = window.viewWithTag(9631) {
            loader.removeFromSuperview()
        }
    }
}
