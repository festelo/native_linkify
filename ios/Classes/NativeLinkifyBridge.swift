//
//  NativeLinkifyBridge.swift
//  NativeLinkifyBridge
//
//  Created by Ilya Beregovsky on 15.02.2022.
//

import Foundation

protocol NativeLinkifyBridge {
    func findLinks(text: String) -> [LinkifyDto]
}

class LinkifyDto {
    let startIndex: Int
    let endIndex: Int
    let url: String
    
    init(startIndex: Int, endIndex: Int, url: String) {
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.url = url
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "startIndex": startIndex,
            "endIndex": endIndex,
            "url": url,
        ]
    }
}

class AppleLinkifyBridge : NativeLinkifyBridge {
    func findLinks(text: String) -> [LinkifyDto] {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue | NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
        let matches = detector.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        
        var res = [LinkifyDto]()
        for match in matches {
            guard let range = Range(match.range, in: text) else { continue }
            var url: String
            if (match.url != nil) {
                url = match.url!.absoluteString
            } else if (match.phoneNumber != nil) {
                url = "tel:" + match.phoneNumber!
            } else {
                continue
            }
            res.append(LinkifyDto(
                startIndex: range.lowerBound.utf16Offset(in: text),
                endIndex: range.upperBound.utf16Offset(in: text),
                url: url
            ));
        }
        return res
    }
}
