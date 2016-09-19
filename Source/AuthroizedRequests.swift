//
//  AuthroizedRequests.swift
//  DribbbleSwift
//
//  Created by George on 2016-05-09.
//  Copyright © 2016 George. All rights reserved.
//

import Foundation

extension ConfigDS{
    public class func setOAuth2Token(_ token: String){
        OAuth2Token = token
    }
}
extension UserDS{
    
    /**
     Get the authenticated user. Must set the OAuth2Token via ConfigDS.setOAuth2Token.
     
     - parameter completionHandler: return NSError, JSON, NSURLResponse and a user object.
     */
    
    public class func getAuthUser(_ completionHandler: @escaping (ClientReturn, _ user: UserDS?) -> ()) -> (){
        let url = "/user"
        var user: UserDS?
        HTTPRequest.request(url, parameters: nil, requestType: .GET, authRequest: true){
            api in
            if let json = api.json{
                user = UserDS.init(json: json)
            }
            completionHandler(api, user)
        }
    }
    
    /**
     List who the authenticated user is following:
     
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of buckets.
     */
    
    public class func getAuthUserBuckets(perPage: Int = 30, page: Int = 1, completionHandler: @escaping (ClientReturn, _ buckets: [BucketDS]?) -> ()) -> (){
        let url = "/user/buckets"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage as AnyObject?
        params["page"] = page as AnyObject?
        HTTPRequest.request(url, parameters: params, requestType: .GET, authRequest: true){
            api in
            var buckets: [BucketDS]?
            if let json = api.json{
                buckets = BucketDS.initArray(json: json)
            }
            completionHandler(api, buckets)
        }
    }
    
    /**
     List the authenticated user’s followers.
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse  and an array followers.
     */
    
    public class func getAuthUserFollowers(perPage: Int = 30, page: Int = 1, completionHandler: @escaping (ClientReturn, _ followers: [FollowersDS]?) -> ()) -> (){
        let url = "/user/followers"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage as AnyObject?
        params["page"] = page as AnyObject?
        HTTPRequest.request(url, parameters: params, requestType: .GET, authRequest: true){
            api in
            var users: [FollowersDS]?
            if let json = api.json{
                users = FollowersDS.initArray(json: json)
            }
            completionHandler(api, users)
        }
    }
    
    
    /**
     List who the authenticated user is following.
     
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of followees.
     */
    
    public class func getAuthUserFollowing(perPage: Int = 30, page: Int = 1, completionHandler: @escaping (ClientReturn, _ followees: [FolloweeDS]?) -> ()) -> (){
        let url = "/user/following"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage as AnyObject?
        params["page"] = page as AnyObject?
        HTTPRequest.request(url, parameters: params, requestType: .GET, authRequest: true){
            api in
            var users: [FolloweeDS]?
            if let json = api.json{
                users = FolloweeDS.initArray(json: json)
            }
            completionHandler(api, users)
        }
    }
    
    /**
     List shots for users followed by a user. Listing shots from followed users requires the user to be authenticated with the public scope. Also note that you can not retrieve more than 600 results, regardless of the number requested per page.
     
     - parameter perPage: Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of shots.
     */
    
    public class func userFollowingShots(perPage: Int = 30, page: Int = 1, completionHandler: @escaping (ClientReturn, _ shots: [ShotsDS]?) -> ()) -> (){
        let url = "/user/following/shots"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage as AnyObject?
        params["page"] = page as AnyObject?
        HTTPRequest.request(url, parameters: params, requestType: .GET, authRequest: true){
            api in
            var shots: [ShotsDS]?
            if let json = api.json{
                shots = ShotsDS.initArray(json: json)
            }
            completionHandler(api, shots)
        }
    }
    
    /**
     Check if user is following another
     
     - parameter username:          username of user to be checked
     - parameter completionHandler: return NSError, JSON, NSURLResponse and returns true if status code = 204, else returns false if status code = 404
     */
    public class func checkIfAuthUserFollowingUser(_ username: String, completionHandler: @escaping (ClientReturn, _ isFollowing: Bool) -> ()) -> (){
        let url = "/user/following/\(username)"
        HTTPRequest.request(url, parameters: nil, authRequest: true){
            api in
            var following: Bool!
            if let httpResponse = api.response as? HTTPURLResponse{
                switch httpResponse.statusCode{
                case 204:
                    following = true
                default:
                    following = false
                }
            }
            completionHandler(api, following)
        }
    }
    
    /**
     Follow a user. Following a user requires the user to be authenticated with the write scope.
     
     - parameter username:          username of user to be followed
     - parameter completionHandler: return NSError, JSON, NSURLResponse and returns true if status code = 204, else returns false if status code = 404
     */
    
    public class func followUser(_ username: String, completionHandler: @escaping (ClientReturn, _ followed: Bool) -> ()) -> (){
        let url = "/users/\(username)/follow"
        HTTPRequest.request(url, parameters: nil, requestType: .PUT, authRequest: true){
            api in
            var following: Bool!
            if let httpResponse = api.response as? HTTPURLResponse{
                switch httpResponse.statusCode{
                case 204:
                    following = true
                default:
                    following = false
                }
            }
            completionHandler(api, following)
        }
    }
    
    
    /**
     Follow a user. Unfollowing a user requires the user to be authenticated with the write scope.
     
     - parameter username:          username of user to be unfollowed
     - parameter completionHandler: return NSError, JSON, NSURLResponse and returns true if status code = 204, else returns false if status code = 404
     */
    
    public class func unfollowUser(_ username: String, completionHandler: @escaping (ClientReturn, _ unfollowed: Bool) -> ()) -> (){
        let url = "/users/\(username)/follow"
        HTTPRequest.request(url, parameters: nil, requestType: .DELETE, authRequest: true){
            api in
            var following: Bool!
            if let httpResponse = api.response as? HTTPURLResponse{
                switch httpResponse.statusCode{
                case 204:
                    following = true
                default:
                    following = false
                }
            }
            completionHandler(api, following)
        }
    }
    
    /**
     List a user’s buckets
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of buckets.
     
     */
    public class func getAuthBuckets(_ perPage: Int = 30, page: Int = 1, completionHandler: @escaping (ClientReturn, _ buckets: [BucketDS]?) -> ()) -> (){
        let url = "/user/buckets"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage as AnyObject?
        params["page"] = page as AnyObject?
        HTTPRequest.request(url, parameters: params){
            api in
            var buckets: [BucketDS]?
            if let json = api.json{
                buckets = BucketDS.initArray(json: json)
            }
            completionHandler(api, buckets)
        }
    }
    
    /**
     List shot likes for a user
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of shots.
     */
    
    public class func getAuthLikes(perPage: Int = 30, page: Int = 1, completionHandler: @escaping (ClientReturn, _ likes: [UserLikesDS]?) -> ()) -> (){
        let url = "/user/likes"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage as AnyObject?
        params["page"] = page as AnyObject?
        HTTPRequest.request(url, parameters: params,authRequest: true){
            api in
            var shots: [UserLikesDS]?
            if let json = api.json{
                shots = UserLikesDS.initArray(json: json)
            }
            completionHandler(api, shots)
        }
    }
    
    /**
     List the authenticated user’s projects.
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of projects.
     */
    
    public class func getAuthProjects(perPage: Int = 30, page: Int = 1, completionHandler: @escaping (ClientReturn, _ projects: [ProjectDS]?) -> ()) -> (){
        let url = "/user/projects"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage as AnyObject?
        params["page"] = page as AnyObject?
        HTTPRequest.request(url, parameters: params, authRequest: true){
            api in
            var projects: [ProjectDS]?
            if let json = api.json{
                projects = ProjectDS.initArray(json: json)
            }
            completionHandler(api, projects)
        }
    }
    
    /**
     List the authenticated user’s shots.
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of shots.
     */
    
    public class func getAuthShots(perPage: Int = 30, page: Int = 1, completionHandler: @escaping (ClientReturn, _ shots: [ShotsDS]?) -> ()) -> (){
        let url = "/user/shots"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage as AnyObject?
        params["page"] = page as AnyObject?
        HTTPRequest.request(url, parameters: params, authRequest: true){
            api in
            var projects: [ShotsDS]?
            if let json = api.json{
                projects = ShotsDS.initArray(json: json)
            }
            completionHandler(api, projects)
        }
    }
    
    /**
     List a user’s teams
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of teams.
     */
    public class func getTeams(_ completionHandler: @escaping (ClientReturn, _ teams: [TeamDS]?) -> ()) -> (){
        let url = "/users/teams"
        HTTPRequest.request(url, parameters: nil){
            api in
            var projects: [TeamDS]?
            if let json = api.json{
                projects = TeamDS.initArray(json: json)
            }
            completionHandler(api, projects)
        }
    }
    
}
extension ShotsDS{
    
    /**
     Like a shot.
     Liking a shot requires the user to be authenticated with the write scope.
     Must set the OAuth2Token via ConfigDS.setOAuth2Token. If statuscode = 201 or success = true, request was completed, else request failed
     
     - parameter shotId:            id of shot to be liked
     - parameter completionHandler: return NSError, JSON, NSURLResponse, statusCode of request and boolean indicating weather request was succesful or not.
     */
    public class func likeShot(shotId: String, completionHandler: @escaping (ClientReturn, _ statusCode: Int?, _ success: Bool) -> ()) -> (){
        let url = "/shots/\(shotId)/like"
        
        HTTPRequest.request(url, parameters: nil, requestType: .POST, authRequest: true){
            request in
            var liked: Bool!
            var statusCode: Int?
            if let httpResponse = request.response as? HTTPURLResponse{
                statusCode = httpResponse.statusCode
                switch httpResponse.statusCode{
                case 201:
                    liked = true
                default:
                    liked = false
                }
            }
            completionHandler(request, statusCode, liked)
        }
    }
    
    
    /**
     Unlike a shot
     Unliking a shot requires the user to be authenticated with the write scope.
     Must set the OAuth2Token via ConfigDS.setOAuth2Token. If statuscode = 204 or unliked = true, request was completed, else request failed
     
     - parameter shotId:            id of shot to be unliked
     - parameter completionHandler: return NSError, JSON, NSURLResponse, statusCode of request and boolean indicating weather request was succesful or not.
     */
    public class func unlikeShot(shotId: String, completionHandler: @escaping (ClientReturn, _ statusCode: Int?, _ unliked: Bool) -> ()) -> (){
        let url = "/shots/\(shotId)/like"
        
        HTTPRequest.request(url, parameters: nil, requestType: .DELETE, authRequest: true){
            request in
            var unliked: Bool!
            var statusCode: Int?
            if let httpResponse = request.response as? HTTPURLResponse{
                statusCode = httpResponse.statusCode
                switch httpResponse.statusCode{
                case 204:
                    unliked = true
                default:
                    unliked = false
                }
            }
            completionHandler(request, statusCode, unliked)
        }
    }
    
    
    /**
     Check if user liked a shot.
     Checking for a shot like requires the user to be authenticated.
     Must set the OAuth2Token via ConfigDS.setOAuth2Token.
     If statuscode = 200 or liked = true user likes shot, else if status code == 404 user didnt like shot.
     
     - parameter shotId:            id of shot to be checked
     - parameter completionHandler: return NSError, JSON, NSURLResponse, statusCode of request and boolean indicating weather shot is liked or not.
     */
    public class func checkIfShotLiked(shotId: String, completionHandler: @escaping (ClientReturn, _ statusCode: Int?, _ liked: Bool) -> ()) -> (){
        let url = "/shots/\(shotId)/like"
        
        HTTPRequest.request(url, parameters: nil, requestType: .GET, authRequest: true){
            request in
            var liked: Bool!
            var statusCode: Int?
            if let httpResponse = request.response as? HTTPURLResponse{
                statusCode = httpResponse.statusCode
                switch httpResponse.statusCode{
                case 200:
                    liked = true
                default:
                    liked = false
                }
            }
            completionHandler(request, statusCode, liked)
        }
    }
    
}
