//
//  ModalStatus.swift
//  FriendsApp
//
//  Created by JAHID HASAN POLASH on 21/5/21.
//

import UIKit

enum StatusType {
    case Success, Error
}

class ModalStatus: UIVisualEffectView {
    var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var signView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var type: StatusType = .Success
    var signColor: CGColor = UIColor.black.cgColor
    var textColor: UIColor = UIColor.black
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setPrimary()
    }
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        setPrimary()
    }
    
    convenience init(frame: CGRect, text: String, type: StatusType, signColor: CGColor, textColor: UIColor, font: UIFont) {
        self.init(effect: UIBlurEffect(style: UIBlurEffect.Style.light))
        self.frame = frame
        title.text = text
        title.textColor = textColor
        title.font = font
        self.signColor = signColor
        self.textColor = textColor
        self.type = type
        setPrimary()
        setLayer(for: type)
    }
    
    func setPrimary() {
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        self.contentView.addSubview(signView)
        setImageViewConstraints()
        self.contentView.addSubview(title)
        setTitleConstraints()
    }
    
    func setImageViewConstraints() {
        signView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        signView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10).isActive = true
        signView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        signView.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func setTitleConstraints() {
        title.topAnchor.constraint(equalTo: signView.bottomAnchor, constant: 16).isActive = true
        title.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
    override func didMoveToSuperview() {
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.15, animations: {
            self.transform = CGAffineTransform.identity
        })
    }
    
    func setLayer(for type: StatusType) {
        if type == .Success {
            let firstLayer = CAShapeLayer()
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: 55))
            path.addLine(to: CGPoint(x: 33, y: 87))
            firstLayer.path = path.cgPath
            firstLayer.strokeColor = signColor
            firstLayer.lineCap = CAShapeLayerLineCap.round
            firstLayer.lineWidth = 15.0
            signView.layer.addSublayer(firstLayer)
            let secondLayer = CAShapeLayer()
            let anotherPath = UIBezierPath()
            anotherPath.move(to: CGPoint(x: 33, y: 87))
            anotherPath.addLine(to: CGPoint(x: 100, y: 13))
            secondLayer.path = anotherPath.cgPath
            secondLayer.strokeColor = signColor
            secondLayer.lineCap = CAShapeLayerLineCap.round
            secondLayer.lineWidth = 15.0
            signView.layer.addSublayer(secondLayer)
        } else {
            let firstLayer = CAShapeLayer()
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 20, y: 20))
            path.addLine(to: CGPoint(x: 80, y: 80))
            firstLayer.path = path.cgPath
            firstLayer.strokeColor = signColor
            firstLayer.lineCap = CAShapeLayerLineCap.round
            firstLayer.lineWidth = 15.0
            signView.layer.addSublayer(firstLayer)
            let secondLayer = CAShapeLayer()
            let anotherPath = UIBezierPath()
            anotherPath.move(to: CGPoint(x: 80, y: 20))
            anotherPath.addLine(to: CGPoint(x: 20, y: 80))
            secondLayer.path = anotherPath.cgPath
            secondLayer.strokeColor = signColor
            secondLayer.lineCap = CAShapeLayerLineCap.round
            secondLayer.lineWidth = 15.0
            signView.layer.addSublayer(secondLayer)
        }
    }
}

class ModalStatusPresenter {
    class func presentStatus(frame: CGRect = CGRect(x: 0, y: 0, width: 200, height: 200),
                             title: String = "Success", type: StatusType = .Success, signColor: CGColor, textColor: UIColor, font: UIFont) {
        let modalView = ModalStatus(frame: frame, text: title, type: type, signColor: signColor, textColor: textColor, font: font)
        if let window = UIApplication.shared.windows.first {
            window.addSubview(modalView)
            modalView.center = window.center
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
            UIView.animate(withDuration: 0.15, animations: {
                modalView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }) { _ in
                modalView.removeFromSuperview()
            }
        }
    }
    
    class func presentStatus(with title: String, type: StatusType = .Success, signColor: CGColor = UIColor.black.cgColor, textColor: UIColor = UIColor.black, font: UIFont = UIFont.boldSystemFont(ofSize: 28)) {
        presentStatus(frame: CGRect(x: 0, y: 0, width: 200, height: 200), title: title, type: type, signColor: signColor, textColor: textColor, font: font)
    }
}
