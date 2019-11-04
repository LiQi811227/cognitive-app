//
//  RemoteCall.swift
//  cognitive app
//
//  Created by LiQi on 4/11/19.
//  Copyright © 2019 LiQi. All rights reserved.
//

import Foundation
import UIKit

public func getToken(_ key: String, completion block: @escaping (Data?, URLResponse?, Error?) -> Void) {

    var request = URLRequest(url: URL(string: "https://translate-fromto.cognitiveservices.azure.com/sts/v1.0/issuetoken")!)
    request.httpMethod = "POST"
    request.addValue("13d4e880fd4f4858b47e226d4fd5912b", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")

    let session = URLSession.shared
    let task = session.dataTask(with: request, completionHandler: block)

    task.resume()
}

public func msTranslate(_ token: String, translate text: String, toLang lang: String, completion block: @escaping (Data?, URLResponse?, Error?) -> Void) {

    var c = URLComponents(string: "https://api.cognitive.microsofttranslator.com/translate")

    c?.queryItems = [
        URLQueryItem(name: "api-version", value: "3.0"),
        URLQueryItem(name: "to", value: lang)
    ]

    guard let url = c?.url else {
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    request.httpBody = """
        [{"Text":"\(text)"}]
        """.data(using: .utf8)

    let session = URLSession.shared
    let task = session.dataTask(with: request, completionHandler: block)

    task.resume()
}

public func extract(_ json: Data) throws -> String? {
    let results = try JSONDecoder().decode([TranslateResult].self, from: json)
    return results.first?.translations.first?.text
}

enum AzureMicrosoftTranslatorError: Error {
    case tokenParseError
    case textParseError
    case apiKeyIsNotInitialized
}

@objcMembers
class AzureMicrosoftTranslator: NSObject {

    static let sharedTranslator = AzureMicrosoftTranslator()

    var key: String?

    
}
