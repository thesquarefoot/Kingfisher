//
//  BackgroundImageFetch.swift
//  TourBook
//
//  Created by Nadia Yudina on 3/27/18.
//  Copyright © 2018 The Square Foot. All rights reserved.
//

import UIKit

public class BackgroundImageFetch {

    private var urls: [URL] = []
    private var manager: KingfisherManager = KingfisherManager.shared
    private var session: URLSession = URLSession.shared

    public convenience init(urls: [URL]) {
        self.init()
        self.urls = urls
    }

    public func fetch() {
        DispatchQueue.global(qos: .background).async {
            for imageUrl in self.urls {
                if self.manager.cache.imageCachedType(forKey: imageUrl.absoluteString) == .none {
                    self.session.dataTask(with: imageUrl, completionHandler: { (data, _, _) in
                        if let data = data, let image = UIImage(data: data) {
                            if self.manager.cache.imageCachedType(forKey: imageUrl.absoluteString) == .none {
                                self.manager.cache.store(image, forKey: imageUrl.absoluteString)
                            }
                        }
                    }).resume()
                }
            }
        }
    }
}
