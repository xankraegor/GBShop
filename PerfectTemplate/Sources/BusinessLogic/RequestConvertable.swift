//
//  RequestConvertible.swift
//  PerfectTemplate
//
//  Created by Xan Kraegor on 13.07.2018.
//

import Foundation

protocol RequestConvertable: Codable {
    init?(json: [String:AnyObject])
}
