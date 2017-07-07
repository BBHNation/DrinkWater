//
//  BBNetworkManager.swift
//  身体的水
//
//  Created by 白彬涵 on 2017/7/7.
//  Copyright © 2017年 Binhan Bai. All rights reserved.
//

import UIKit

class BBNetworkManager: NSObject {
    static let manager = BBNetworkManager()
    
    enum RequestWay {
        case Get
        case Post
        case Put
        case Delete
    }
    
    public func requestWith(way: RequestWay, url: URL, parameters: [String : Any]?, completeBlock: @escaping (_ data: Data?, _ urlResponse: URLResponse? ,_ err: Error?)->()) {
        let session = URLSession.shared
        var request = URLRequest.init(url: url)
        if parameters != nil { request.httpBody = NSKeyedArchiver.archivedData(withRootObject: parameters!) }
        request.timeoutInterval = 10.0
        let methodString: String
        switch way {
        case .Get:
            methodString = "GET"
        case .Put:
            methodString = "PUT"
        case .Post:
            methodString = "POST"
        case .Delete:
            methodString = "DELETE"
        }
        request.httpMethod = methodString
        
        (session.dataTask(with: request) { (data, urlResponse, err) in
            completeBlock(data, urlResponse, err)
        }).resume()
    }
}
