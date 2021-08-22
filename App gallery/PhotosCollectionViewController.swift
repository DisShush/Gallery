//
//  PhotosCollectionViewController.swift
//  App gallery
//
//  Created by Владислав Шушпанов on 20.08.2021.
//

import UIKit


class PhotosCollectionViewController: UICollectionViewController {
    
    var networkService = NetworkService()
    var networkDataFetcher = NetworkDataFetch()
    let itemsPerRow: CGFloat = 2
    let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    var photos = PhotoData()
    private var loadingMore: Bool = false


    override func viewDidLoad() {
        super.viewDidLoad()
        let photosData = UserDefaults.standard.data(forKey: "photos")
        let decode = networkDataFetcher.decodeJSON(type: PhotoData.self, data: photosData)
        if let photo = decode {
            photos = photo
        } else {
            self.networkDataFetcher.fetchImage { [weak self] photoData in
                guard let photoData = photoData else { return }
                self?.photos = photoData
                self?.collectionView.reloadData()
            }
        collectionView.backgroundColor = .gray
        }
   
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickPhoto" {
            let photoVC = segue.destination as! PhotoViewController
            let cell = sender as! PhotoCell
            photoVC.image = cell.photoImage.image
            photoVC.data = cell.ymdhm
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        let unspashPhoto = self.photos[indexPath.item]
        cell.photo = unspashPhoto
        cell.likes = unspashPhoto.likes
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        let additionalOffset = CGFloat(-20)
        
        if deltaOffset < additionalOffset && !loadingMore && photos.count > 0 {
            loadingMore = true
            
            networkDataFetcher.fetchImage { [unowned self] photoData in
                DispatchQueue.global(qos: .userInitiated).async {
                    
                    DispatchQueue.main.async {
                        self.photos.append(contentsOf: photoData!)
                        let defaults = UserDefaults.standard
                        defaults.removeObject(forKey: "photos")
                        let encoder = JSONEncoder()
                        do {
                            let encodedPhoto = try encoder.encode(self.photos)
                            defaults.set(encodedPhoto, forKey: "photos")
                        } catch {
                            print("Save Failed")
                        }
                        self.collectionView.reloadData()
                        self.loadingMore = false
                    }
                }
            }
        }
    }
}

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingWidth = sectionInserts.left * (itemsPerRow + 1)
        let avaiableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = avaiableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem + 20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         return sectionInserts
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}


