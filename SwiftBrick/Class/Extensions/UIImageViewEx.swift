//
//  UIImageEx.swift
//  SwiftBrick
//
//  Created by iOS on 2020/7/9.
//  Copyright © 2020 狄烨 . All rights reserved.
//

import UIKit
import CommonCrypto

extension UIImageView {
    func setPlaceHolder(image : UIImage?, size : CGSize){
        guard let im = image else {
            return
        }
        self.image = UIImage.createImage(image: im, size: size)
    }
}

extension UIImage {
    static func createImage(image : UIImage, size : CGSize) -> UIImage?{
        let name = image.md5
        let imageName = "placeHolder_\(size.width)_\(size.height)_\(name).png"
        let fileManager = FileManager.default
        let path : String = NSHomeDirectory() + "/Documents/PlaceHolder/"
        let filePath = path + imageName
        if fileManager.fileExists(atPath: filePath) {
            guard let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: filePath))
                else { return nil }
            let image = UIImage.init(data: data)
            return image
        }
        
        UIGraphicsBeginImageContext(size)
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.setFillColor(UIColor.clear.cgColor)
            ctx.fill(CGRect(origin: CGPoint.zero, size: size))
            
            let placeholderRect = CGRect(x: (size.width - image.size.width) / 2.0,
                                         y: (size.height - image.size.height) / 2.0,
                                         width: image.size.width,
                                         height: image.size.height)
            
            ctx.draw(image.cgImage!, in: placeholderRect, byTiling: false)
        }
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            // 镜像翻转
            let aResult = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .downMirrored)
            try? fileManager.createDirectory(at: URL.init(fileURLWithPath: path), withIntermediateDirectories: true, attributes: nil)
            fileManager.createFile(atPath: filePath, contents: aResult.pngData(), attributes: nil)
            return aResult
        }
        UIGraphicsEndImageContext()
        return nil
    }
    
    var md5: String {
        let data = Data(self.pngData()!)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
