//
//  ViewController.swift
//  HouseIdentifyDemo
//
//  Created by machao on 2021/9/14.
//

import UIKit
import Gallery

class ViewController: UIViewController  {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var galleryBtn: UIButton!
    @IBOutlet weak var photosBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        galleryBtn.layer.cornerRadius = 20.0
        
        photosBtn.layer.cornerRadius = 20.0
        
        Config.Font.Text.bold = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        Config.Camera.recordLocation = true
        Config.tabsToShow = [.imageTab, .cameraTab]
    }
    
    @IBAction func galleryBtnAction(_ sender: Any) {
        
        let gallery = GalleryController()
        gallery.delegate = self
        
        present(gallery, animated: true, completion: nil)
        
    }
    
    @IBAction func getPhotosBtnAction(_ sender: Any) {
        
    }
    
}

// MARK: - GalleryControllerDelegate
extension ViewController: GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        
    }
    
}

