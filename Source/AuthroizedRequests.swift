//
//  AuthroizedRequests.swift
//  DribbbleSwift
//
//  Created by George on 2016-05-09.
//  Copyright © 2016 George. All rights reserved.
//

import Foundation

extension ConfigDS{
    public class func setOAuth2Token(token: String){
        OAuth2Token = token
    }
}
extension UserDS{
    
    /**
     Get the authenticated user. Must set the OAuth2Token via ConfigDS.setOAuth2Token.
     
     - parameter completionHandler: return NSError, JSON, NSURLResponse and a user object.
     */
    
    public class func getAuthUser(completionHandler: (ClientReturn, user: UserDS?) -> ()) -> (){
        let url = "/user"
        var user: UserDS?
        HTTPRequest.request(url, parameters: nil, requestType: .GET, authRequest: true){
            api in
            if let json = api.json{
                user = UserDS.init(json: json)
            }
            completionHandler(api, user: user)
        }
    }
    
    /**
     List who the authenticated user is following:
     
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of buckets.
     */
    
    public class func getAuthUserBuckets(perPage perPage: Int = 30, page: Int = 1, completionHandler: (ClientReturn, buckets: [BucketDS]?) -> ()) -> (){
        let url = "/user/buckets"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage
        params["page"] = page
        HTTPRequest.request(url, parameters: params, requestType: .GET, authRequest: true){
            api in
            var buckets: [BucketDS]?
            if let json = api.json{
                buckets = BucketDS.initializeArray(json)
            }
            completionHandler(api, buckets: buckets)
        }
    }
    
    /**
     List the authenticated user’s followers.
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse  and an array followers.
     */
    
    public class func getAuthUserFollowers(perPage perPage: Int = 30, page: Int = 1, completionHandler: (ClientReturn, followers: [FollowersDS]?) -> ()) -> (){
        let url = "/user/followers"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage
        params["page"] = page
        HTTPRequest.request(url, parameters: params, requestType: .GET, authRequest: true){
            api in
            var users: [FollowersDS]?
            if let json = api.json{
                users = FollowersDS.initializeArray(json)
            }
            completionHandler(api, followers: users)
        }
    }
    
    
    /**
     List who the authenticated user is following.
     
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of followees.
     */
    
    public class func getAuthUserFollowing(perPage perPage: Int = 30, page: Int = 1, completionHandler: (ClientReturn, followees: [FolloweeDS]?) -> ()) -> (){
        let url = "/user/following"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage
        params["page"] = page
        HTTPRequest.request(url, parameters: params, requestType: .GET, authRequest: true){
            api in
            var users: [FolloweeDS]?
            if let json = api.json{
                users = FolloweeDS.initializeArray(json)
            }
            completionHandler(api, followees: users)
        }
    }
    
    /**
     List shots for users followed by a user. Listing shots from followed users requires the user to be authenticated with the public scope. Also note that you can not retrieve more than 600 results, regardless of the number requested per page.
     
     - parameter perPage: Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of shots.
     */
    
    public class func userFollowingShots(perPage perPage: Int = 30, page: Int = 1, completionHandler: (ClientReturn, shots: [ShotsDS]?) -> ()) -> (){
        let url = "/user/following/shots"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage
        params["page"] = page
        HTTPRequest.request(url, parameters: params, requestType: .GET, authRequest: true){
            api in
            var shots: [ShotsDS]?
            if let json = api.json{
                shots = ShotsDS.initializeArray(json)
            }
            completionHandler(api, shots: shots)
        }
    }
    
    /**
     Check if user is following another
     
     - parameter username:          username of user to be checked
     - parameter completionHandler: return NSError, JSON, NSURLResponse and returns true if status code = 204, else returns false if status code = 404
     */
    public class func checkIfAuthUserFollowingUser(username: String, completionHandler: (ClientReturn, isFollowing: Bool) -> ()) -> (){
        let url = "/user/following/\(username)"
        HTTPRequest.request(url, parameters: nil, authRequest: true){
            api in
            var following: Bool!
            if let httpResponse = api.response as? NSHTTPURLResponse{
                switch httpResponse.statusCode{
                case 204:
                    following = true
                default:
                    following = false
                }
            }
            completionHandler(api, isFollowing: following)
        }
    }
    
    /**
     Follow a user. Following a user requires the user to be authenticated with the write scope.
     
     - parameter username:          username of user to be followed
     - parameter completionHandler: return NSError, JSON, NSURLResponse and returns true if status code = 204, else returns false if status code = 404
     */
    
    public class func followUser(username: String, completionHandler: (ClientReturn, followed: Bool) -> ()) -> (){
        let url = "/user/\(username)/follow"
        HTTPRequest.request(url, parameters: nil, requestType: .PUT, authRequest: true){
            api in
            var following: Bool!
            if let httpResponse = api.response as? NSHTTPURLResponse{
                switch httpResponse.statusCode{
                case 204:
                    following = true
                default:
                    following = false
                }
            }
            completionHandler(api, followed: following)
        }
    }
    
    
    /**
     Follow a user. Unfollowing a user requires the user to be authenticated with the write scope.
     
     - parameter username:          username of user to be unfollowed
     - parameter completionHandler: return NSError, JSON, NSURLResponse and returns true if status code = 204, else returns false if status code = 404
     */
    
    public class func unfollowUser(username: String, completionHandler: (ClientReturn, unfollowed: Bool) -> ()) -> (){
        let url = "/user/\(username)/follow"
        HTTPRequest.request(url, parameters: nil, requestType: .DELETE, authRequest: true){
            api in
            var following: Bool!
            if let httpResponse = api.response as? NSHTTPURLResponse{
                switch httpResponse.statusCode{
                case 204:
                    following = true
                default:
                    following = false
                }
            }
            completionHandler(api, unfollowed: following)
        }
    }
    
    /**
     List a user’s buckets
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of buckets.
     
     */
    public class func getAuthBuckets(perPage: Int = 30, page: Int = 1, completionHandler: (ClientReturn, buckets: [BucketDS]?) -> ()) -> (){
        let url = "/user/buckets"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage
        params["page"] = page
        HTTPRequest.request(url, parameters: params){
            api in
            var buckets: [BucketDS]?
            if let json = api.json{
                buckets = BucketDS.initializeArray(json)
            }
            completionHandler(api, buckets: buckets)
        }
    }
    
    /**
     List shot likes for a user
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of shots.
     */
    
    public class func getAuthLikes(perPage perPage: Int = 30, page: Int = 1, completionHandler: (ClientReturn, likes: [UserLikesDS]?) -> ()) -> (){
        let url = "/user/likes"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage
        params["page"] = page
        HTTPRequest.request(url, parameters: params,authRequest: true){
            api in
            var shots: [UserLikesDS]?
            if let json = api.json{
                shots = UserLikesDS.initializeArray(json)
            }
            completionHandler(api, likes: shots)
        }
    }
    
    /**
     List the authenticated user’s projects.
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of projects.
     */
    
    public class func getAuthProjects(perPage perPage: Int = 30, page: Int = 1, completionHandler: (ClientReturn, projects: [ProjectDS]?) -> ()) -> (){
        let url = "/user/projects"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage
        params["page"] = page
        HTTPRequest.request(url, parameters: params, authRequest: true){
            api in
            var projects: [ProjectDS]?
            if let json = api.json{
                projects = ProjectDS.initializeArray(json)
            }
            completionHandler(api, projects: projects)
        }
    }
    
    /**
     List the authenticated user’s shots.
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of shots.
     */
    
    public class func getAuthShots(perPage perPage: Int = 30, page: Int = 1, completionHandler: (ClientReturn, shots: [ShotsDS]?) -> ()) -> (){
        let url = "/user/shots"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage
        params["page"] = page
        HTTPRequest.request(url, parameters: params, authRequest: true){
            api in
            var projects: [ShotsDS]?
            if let json = api.json{
                projects = ShotsDS.initializeArray(json)
            }
            completionHandler(api, shots: projects)
        }
    }
    
    /**
     List a user’s teams
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of teams.
     */
    public class func getTeams(completionHandler: (ClientReturn, teams: [TeamDS]?) -> ()) -> (){
        let url = "/users/teams"
        HTTPRequest.request(url, parameters: nil){
            api in
            var projects: [TeamDS]?
            if let json = api.json{
                projects = TeamDS.initializeArray(json)
            }
            completionHandler(api, teams: projects)
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
    public class func likeShot(shotId shotId: String, completionHandler: (ClientReturn, statusCode: Int?, success: Bool) -> ()) -> (){
        let url = "/shots/\(shotId)/like"
        
        HTTPRequest.request(url, parameters: nil, requestType: .POST, authRequest: true){
            request in
            var liked: Bool!
            var statusCode: Int?
            if let httpResponse = request.response as? NSHTTPURLResponse{
                statusCode = httpResponse.statusCode
                switch httpResponse.statusCode{
                case 201:
                    liked = true
                default:
                    liked = false
                }
            }
            completionHandler(request, statusCode: statusCode, success: liked)
        }
    }
    
    
    /**
     Unlike a shot
     Unliking a shot requires the user to be authenticated with the write scope.
     Must set the OAuth2Token via ConfigDS.setOAuth2Token. If statuscode = 204 or unliked = true, request was completed, else request failed
     
     - parameter shotId:            id of shot to be unliked
     - parameter completionHandler: return NSError, JSON, NSURLResponse, statusCode of request and boolean indicating weather request was succesful or not.
     */
    public class func unlikeShot(shotId shotId: String, completionHandler: (ClientReturn, statusCode: Int?, unliked: Bool) -> ()) -> (){
        let url = "/shots/\(shotId)/like"
        
        HTTPRequest.request(url, parameters: nil, requestType: .DELETE, authRequest: true){
            request in
            var unliked: Bool!
            var statusCode: Int?
            if let httpResponse = request.response as? NSHTTPURLResponse{
                statusCode = httpResponse.statusCode
                switch httpResponse.statusCode{
                case 204:
                    unliked = true
                default:
                    unliked = false
                }
            }
            completionHandler(request, statusCode: statusCode, unliked: unliked)
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
    public class func checkIfShotLiked(shotId shotId: String, completionHandler: (ClientReturn, statusCode: Int?, liked: Bool) -> ()) -> (){
        let url = "/shots/\(shotId)/like"
        
        HTTPRequest.request(url, parameters: nil, requestType: .GET, authRequest: true){
            request in
            var liked: Bool!
            var statusCode: Int?
            if let httpResponse = request.response as? NSHTTPURLResponse{
                statusCode = httpResponse.statusCode
                switch httpResponse.statusCode{
                case 200:
                    liked = true
                default:
                    liked = false
                }
            }
            completionHandler(request, statusCode: statusCode, liked: liked)
        }
    }
    
}