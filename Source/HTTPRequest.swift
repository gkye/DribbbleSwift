//
//  HTTPRequest.swift
//  DribbbleSwift
//
//  Created by George on 2016-05-06.
//  Copyright © 2016 George. All rights reserved.
//

import Foundation

public struct ClientReturn{
    public var error: NSError?
    public var json: JSON?
    public var response: NSURLResponse?
    init(error: NSError?, json: JSON?, response: NSURLResponse?){
        self.error = error
        self.json = json
        self.response = response
    }
}

enum RequestType: String{
    case GET, POST, DELETE
}


class HTTPRequest{
    
    class func request(url: String, parameters: [String: AnyObject]?, requestType: RequestType = .GET, authRequest: Bool = false, completionHandler: (ClientReturn) -> ()) -> (){
        
        let baseURL = "https://api.dribbble.com/v1"+url
        var url: NSURL!
        var params: [String: AnyObject] = [:]
        var request: NSMutableURLRequest!
        
        switch requestType {
        case .GET:
            if(parameters != nil){
                params = parameters!
            }
            if(!authRequest){
                params["access_token"] = access_token
            }
            let parameterString = params.stringFromHttpParameters()
            url = NSURL(string: "\(baseURL)?\(parameterString)")!
            request = NSMutableURLRequest(URL: url)
        default:
            print("OAUTH request")
        }

        if(authRequest){
            if(requestType == .GET && parameters != nil){
                let parameterString = parameters!.stringFromHttpParameters()
                url = NSURL(string: "\(baseURL)?\(parameterString)")!
            }else{
                url = NSURL(string: baseURL)
            }
            request = NSMutableURLRequest(URL: url)
            if(OAuth2Token != nil){
                request.addValue("Bearer \(OAuth2Token)", forHTTPHeaderField: "Authorization")
            }else{
                fatalError("OAuth token not set!")
            }
        }
        
        print(url)
        request.HTTPMethod = requestType.rawValue
        request.addValue("application/vnd.dribbble.v1.text+json", forHTTPHeaderField: "Accept")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if error == nil{
                    let json = JSON(data: data!)
                    completionHandler(ClientReturn.init(error: error, json: json, response: response))
                    
                }else{
                    print("Error -> \(error)")
                    print(error)
                    completionHandler(ClientReturn.init(error: error, json: nil, response: response))
                }
            })
        }
        task.resume()
    }
}

extension String {
    
    /// Percent escapes values to be added to a URL query as specified in RFC 3986
    ///
    /// This percent-escapes all characters besides the alphanumeric character set and "-", ".", "_", and "~".
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: Returns percent-escaped string.
    
    func stringByAddingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        
        return self.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters)
    }
    
}

extension Dictionary {
    
    /// Build string representation of HTTP parameter dictionary of keys and objects
    ///
    /// This percent escapes in compliance with RFC 3986
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
    
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).stringByAddingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = (String(value)).stringByAddingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joinWithSeparator("&")
    }
}