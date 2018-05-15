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
    private var manager: KingfisherManager? = KingfisherManager.shared
    public var session: URLSession?

    public convenience init(urls: [URL]) {
        self.init()
        self.urls = urls
        let config = URLSessionConfiguration.ephemeral
        config.httpMaximumConnectionsPerHost = 5
        config.timeoutIntervalForResource = 120
        config.timeoutIntervalForRequest = 120
        self.session = URLSession(configuration: config)
        self.manager?.cache.maxDiskCacheSize = 1
    }

    @available(iOS 9.0, *)
    public func stop() {
        session?.getAllTasks(completionHandler: { (tasks) in
            for task in tasks {
                task.cancel()
            }
            self.manager = nil
        })
    }

    lazy var fetchQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()

    public func fetch() {
        fetchQueue.addOperation {
            for imageUrl in self.urls {
                if self.manager?.cache.imageCachedType(forKey: imageUrl.absoluteString) == .none {
                    let dataTask = self.session?.dataTask(with: imageUrl, completionHandler: { (data, _, _) in
                        if let data = data, let image = Image(data: data) {
                            if self.manager?.cache.imageCachedType(forKey: imageUrl.absoluteString) == .none {
                                self.manager?.cache.store(image, original: data, forKey: imageUrl.absoluteString)
                            }
                        }
                    })
                    dataTask?.resume()
                }
            }
        }
    }
}
