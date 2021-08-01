//
//  UserDefaults+UIImage.swift
//  UserDefaults+UIImage
//
//  Created by headspinnerd on 2021/08/01.
//

import SwiftUI

extension UserDefaults {
    /// 指定したURLについて、UserDefaultsに既に画像を保存していればその画像をreturnし、
    /// 未保存であればWEBから画像を取得してUserDefaultsに保存し、画像をreturnする
    /// - Parameter gifUrl:指定したURL(TODO: 現在はGIF画像限定)
    func gifImageWithURL(gifUrl: String) -> UIImage? {
        let doesExistData = self.bool(forKey: gifUrl)
        if doesExistData {
            if let imageData = self.data(forKey: gifUrl + Constants.saveImageSuffix) {
                let image = UIImage(data: imageData)
                return image
            }
        }
        
        guard let bundleURL = NSURL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = NSData(contentsOf: bundleURL as URL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }

        guard let source = CGImageSourceCreateWithData(imageData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        let options = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: 30] as CFDictionary
        guard let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options) else {
            print("failed to create thumnail")
            return nil
        }
        
        let image = UIImage(cgImage: imageReference)
        // ImageをUserDefaultsに保存
        let nsdata = image.pngData()
        self.set(nsdata, forKey: gifUrl + Constants.saveImageSuffix)
        self.set(true, forKey: gifUrl)
        
        return image
    }
}
