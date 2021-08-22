//
//  PhotoViewController.swift
//  App gallery
//
//  Created by Владислав Шушпанов on 21.08.2021.
//

import UIKit

class PhotoViewController: UIViewController {
    
    var image: UIImage?
    var data: DateComponents?
    @IBOutlet weak var dataLable: UILabel!
    
    @IBOutlet weak var photoImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        photoImage.image = image
        dataLable.text = "\(data!.year!)-\(data!.month!)-\(data!.day!) \(data!.hour!):\(data!.minute!)"
        // Do any additional setup after loading the view.
    }
    

}
