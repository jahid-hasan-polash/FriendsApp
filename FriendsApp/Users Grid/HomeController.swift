//
//  HomeController.swift
//  FriendsApp
//
//  Created by JAHID HASAN POLASH on 21/5/21.
//

import UIKit

/// Home view shows users grid with relevent information
class HomeController: UICollectionViewController {
    private let reuseIdentifier = "CardCell"
    
    var users = [User]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Friends"
        collectionView.register(UserCard.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .systemGroupedBackground
        loadUsersData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func loadUsersData() {
        if isInternetAvailable() {
            guard let url = URL(string: "https://randomuser.me/api/?results=10") else { return }
            showLoadingScreen(message: "Loading Users data")
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    ModalStatusPresenter.presentStatus(with: "Error")
                    print(error.debugDescription)
                }
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    if let loadedData = try? jsonDecoder.decode(Users.self, from: data) {
                        DispatchQueue.main.async {
                            self.users = loadedData.results ?? []
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.removeLoadingScreen()
                }
            }.resume()
        } else {
            ModalStatusPresenter.presentStatus(with: "No Internet", type: .Error)
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return users.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserCard
        let user = users[indexPath.item]
        // if cache has users image set it directly
        // else download it in the global thread and set it in the cell later
        if let imgUrl = user.picture?.medium,
           let url = URL(string: imgUrl) {
            if let image = ImageCache.global.imagesDictionary[imgUrl] {
                cell.image.image = image
            } else {
                DispatchQueue.global().async {
                    if let imageData = try? Data(contentsOf: url) {
                        let img = UIImage(data: imageData)
                        // Update cache
                        ImageCache.global.imagesDictionary[imgUrl] = img
                        // set cell image
                        DispatchQueue.main.async {
                            cell.image.image = img
                        }
                    }
                }
            }
        }
        
        cell.name.text = user.name?.getFullName()
        cell.country.text = user.location?.country
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowRadius = 3
        cell.layer.shadowOffset = CGSize(width: 2, height: 2)
        return cell
    }
    
    // On card tap navigate to details view with the user info
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !users.isEmpty else { return }
        let user = users[indexPath.item]
        let detailsView = UserDetailsController()
        detailsView.user = user
        navigationController?.pushViewController(detailsView, animated: true)
    }
}

extension HomeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var itemPerRow: CGFloat = 4
        // if device is in landscape mode items per row will increase to look better UI
        // Orientation is not working as expected in the simulator
        // so for now i am using this logic
        if UIScreen.main.bounds.height < UIScreen.main.bounds.width {
            itemPerRow = 6
        }
        let cellWidth = (UIScreen.main.bounds.width - (8 * (itemPerRow + 1)) - 24) / itemPerRow
        return CGSize(width: cellWidth, height: cellWidth * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
}
