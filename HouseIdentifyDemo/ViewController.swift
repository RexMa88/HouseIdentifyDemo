//
//  ViewController.swift
//  HouseIdentifyDemo
//
//  Created by machao on 2021/9/14.
//

import UIKit
import Gallery
import Photos

struct AlbumItem {
    //相簿名称
    var title:String?
    //相簿内的资源
    var fetchResult: PHFetchResult<PHAsset>
     
    init(title: String?,fetchResult: PHFetchResult<PHAsset>){
        self.title = title
        self.fetchResult = fetchResult
    }
}

class ViewController: UIViewController  {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var galleryBtn: UIButton!
    @IBOutlet weak var photosBtn: UIButton!
    
    private var items:[AlbumItem] = []
    
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
        requestAllPhotos()
    }
    
}

// MARK: - Private Method
extension ViewController {
    
    private func requestAllPhotos() {
        
        PHPhotoLibrary.requestAuthorization { status in
            
            guard status == .authorized else { return }
            
            // 列出所有系统的智能相册
            let smartOptions = PHFetchOptions()
            let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                      subtype: .albumRegular,
                                                                      options: smartOptions)
            
            self.convertCollection(collection: smartAlbums)
            //列出所有用户创建的相册
            let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
            self.convertCollection(collection: userCollections as! PHFetchResult<PHAssetCollection>)
            //相册按包含的照片数量排序（降序）
            self.items.sort { (item1, item2) -> Bool in
                return item1.fetchResult.count > item2.fetchResult.count
            }
            
            print("the items is \(self.items)")
        }
        
    }
    
    private func convertCollection(collection: PHFetchResult<PHAssetCollection>){
             
            for i in 0..<collection.count{
                //获取出但前相簿内的图片
                let resultsOptions = PHFetchOptions()
                resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                                   ascending: false)]
                resultsOptions.predicate = NSPredicate(format: "mediaType = %d",
                                                       PHAssetMediaType.image.rawValue)
                let c = collection[i]
                let assetsFetchResult = PHAsset.fetchAssets(in: c , options: resultsOptions)
                //没有图片的空相簿不显示
                if assetsFetchResult.count > 0{
                    let title = titleOfAlbumForChinse(title: c.localizedTitle)
                    items.append(AlbumItem(title: title,
                                           fetchResult: assetsFetchResult))
                }
            }
             
        }
    
    private func titleOfAlbumForChinse(title:String?) -> String? {
            if title == "Slo-mo" {
                return "慢动作"
            } else if title == "Recently Added" {
                return "最近添加"
            } else if title == "Favorites" {
                return "个人收藏"
            } else if title == "Recently Deleted" {
                return "最近删除"
            } else if title == "Videos" {
                return "视频"
            } else if title == "All Photos" {
                return "所有照片"
            } else if title == "Selfies" {
                return "自拍"
            } else if title == "Screenshots" {
                return "屏幕快照"
            } else if title == "Camera Roll" {
                return "相机胶卷"
            }
            return title
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

