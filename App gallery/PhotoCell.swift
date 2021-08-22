//
//  PhotoCell.swift
//  App gallery
//
//  Created by Владислав Шушпанов on 21.08.2021.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    let imageService = ImageService()
    let myCalendar = Calendar(identifier: .gregorian)
    var ymdhm = DateComponents()
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var likesCount: UILabel!
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
            return layoutAttributes
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImage.image = nil
    }

    var likes: Int = 0 {
        didSet {
            likesCount.text = "like:\(likes)"
        }
    }
    
    var photo: Photo! {
        didSet {
            let photoURL = photo.urls["regular"]
            guard let url = photoURL else { return }
            self.imageService.get(urlString: url) { image in
                self.photoImage.image = image
                self.ymdhm = self.myCalendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
            }
        }
    }
}

