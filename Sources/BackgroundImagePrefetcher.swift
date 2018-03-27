//
//  BackgroundImagePrefetcher.swift
//  Kingfisher-iOS
//
//  Created by Nadia Yudina on 3/27/18.
//  Copyright © 2018 Wei Wang. All rights reserved.
//

import UIKit

public class BackgroundImagePrefetcher {

    private var urls: [URL] = []

    public convenience init(urls: [URL]) {
        self.init()
        self.urls = urls
    }

    /**
     Download the resources and cache them without using the main thread.
     This is useful in applications, where UI performance is an important factor.
     */
    public func backgroundDownload(forUrls urls: [URL]) {
        let manager = KingfisherManager.shared
        for url in self.urls {
            if manager.cache.imageCachedType(forKey: url.absoluteString) == .none {
                URLSession.shared.dataTask(with: url, completionHandler: { (data, _, _) in
                    if let data = data, let image = UIImage(data: data) {
                        if manager.cache.imageCachedType(forKey: url.absoluteString) == .none {
                            manager.cache.store(image, forKey: url.absoluteString)
                        }
                    }
                }).resume()
            }
        }
    }

}
