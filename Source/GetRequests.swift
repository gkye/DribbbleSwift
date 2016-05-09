//
//  Models.swift
//  DribbbleSwift
//
//  Created by George on 2016-05-06.
//  Copyright © 2016 George. All rights reserved.
//

import Foundation


var access_token: String! = nil
var OAuth2Token: String! = nil

public class ConfigDS{
    public class func setAccessToken(token: String!){
        access_token = token
    }   
}



//Mark: Shots

/**
 Limit the results to a specific type with the following possible values
 */
public enum ShotListDS: String{
    case animated, attachments, debuts, playoffs, rebounds, teams, any
}

/**
 A period of time to limit the results to with the following possible values
 */
public enum ShotTimeFrameDS: String{
    case week, month, year, ever
}

/**
 The sort field with the following possible values.
 */
public enum ShotSortDS: String{
    case comments, recent, views
}

//Mark: Images

public class ImagesDS{
    public var hidpi: String?
    public var normal: String!
    public var teaser: String!
    
    init(json: JSON){
        hidpi = json["hidpi"].string
        normal = json["normal"].string
        teaser = json["teaser"].string
    }
}


public class ShotsDS{
    public var id : Int!
    public var title : String!
    public var description : String?
    public var width: Int!
    public var height: Int!
    public var images: ImagesDS!
    public var views_count : Int!
    public var likes_count :  Int!
    public var comments_count : Int!
    public var attachments_count: Int!
    public var rebounds_count: Int!
    public var buckets_count: Int!
    public var created_at: String!
    public var updated_at: String!
    public var html_url: String!
    public var attachments_url: String!
    public var buckets_url: String!
    public var comments_url: String!
    public var likes_url: String!
    public var projects_url: String!
    public var rebounds_url: String!
    public var animated: Bool!
    public var tags: [String]?
    public var user: UserDS!
    public var team: TeamDS?
    
    init(json: JSON){
        id = json["id"].int
        title = json["title"].string
        description = json["description"].string
        width = json["width"].int
        height = json["height"].int
        images = ImagesDS.init(json: json["images"])
        views_count = json["views_count"].int
        likes_count = json["likes_count"].int
        comments_count = json["comments_count"].int
        attachments_count = json["attachments_count"].int
        rebounds_count = json["rebounds_count"].int
        buckets_count = json["buckets_count"].int
        created_at = json["created_at"].string
        updated_at = json["updated_at"].string
        html_url = json["html_url"].string
        attachments_url = json["attachments_url"].string
        buckets_url = json["buckets_url"].string
        comments_url = json["comments_url"].string
        likes_url = json["likes_url"].string
        projects_url = json["projects_url"].string
        rebounds_url = json["rebounds_url"].string
        animated = json["animated"].bool
        tags = json["tags"].arrayObject as? [String]
        user = UserDS.init(json: json["user"])
        team = TeamDS.init(team: json["team"])
        
    }
    
    class func initializeArray(json: JSON)->[ShotsDS]? {
        var shotsArray = [ShotsDS]()
        for i in 0..<json.count{
            shotsArray.append(ShotsDS(json: json[i]))
        }
        
        return shotsArray
    }
    /**
     List shots
     
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter list:              Limit the results to a specific type with the following possible values: animated, attachments, debuts, playoffs, rebounds, teams     teams
     - parameter sort:              The sort field with the following possible values: comments, recent, views. Default = .views
     - parameter timeframe:         A period of time to limit the results to with the following possible values: week, month, year, ever
     - parameter date:              Limit the timeframe to a specific date, week, month, or year. Must be in the format of YYYY-MM-DD.
     - parameter completionHandler:   return NSError, JSON, NSURLResponse  and an array of shots.
     */
    
    public class func getShots(perPage perPage: Int = 30, page: Int = 1, list: ShotListDS? = nil, sort: ShotSortDS? = nil, timeframe: ShotTimeFrameDS? = nil,date: String? = nil, completionHandler: (ClientReturn, shots: [ShotsDS]?) -> ()) -> (){
        
        let url = "/shots"
        var params: [String: AnyObject] = [:]
        
        params["per_page"] = perPage
        params["page"] = page
        if(list != nil){
            params["list"] = list!.rawValue
        }
        if(sort != nil){
            params["sort"] = sort!.rawValue
        }
        if(timeframe != nil){
            params["timeframe"] = timeframe?.rawValue
        }
        if(date != nil){
            params["date"] = date
        }
        
        HTTPRequest.request(url, parameters: params){
            api in
            var shots: [ShotsDS]?
            if let json = api.json{
                shots = ShotsDS.initializeArray(json)
            }
            completionHandler(api, shots: shots)
        }
    }
    
    /**
     List attachments for a shot
     
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter shotID:            id assigned to shot
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of attachments
     */
    public class func getAttachments(shotID shotID: Int, perPage: Int = 30, page: Int = 1, completionHandler: (ClientReturn, attachments: [AttachmentDS]?) -> ()) -> (){
        let url = "/shots/\(shotID)/attachments"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage
        params["page"] = page
        
        HTTPRequest.request(url, parameters: params){
            api in
            var attachments: [AttachmentDS]?
            if let json = api.json{
                attachments = AttachmentDS.initializeArray(json)
            }
            completionHandler(api, attachments: attachments)
        }
    }
    
    /**
     List buckets for a shot
     
     - parameter perPage:           Resources per page, maximum = 100
     - parameter page: Current page of resource. Default = 1
     - parameter shotID: id assigned to shot
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of buckets
     */
    public class func getBuckets(shotID shotID: Int, perPage: Int = 30, page: Int = 1, completionHandler: (ClientReturn, buckets: [BucketDS]?) -> ()) -> (){
        let url = "/shots/\(shotID)/buckets"
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
     List comments for a shot
     
     - parameter perPage:           Resources per page, maximum = 100. Default = 30
     - parameter page: Current page of resource. Default = 1
     - parameter shotID: id assigned to shot
     - parameter completionHandler: return NSError, JSON, NSURLResponse  and an array of comments
     */
    
    public class func getComments(shotID shotID: Int, perPage: Int = 30, page: Int = 1, completionHandler: (ClientReturn, comments: [CommentDS]?) -> ()) -> (){
        let url = "/shots/\(shotID)/comments"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage
        params["page"] = page
        HTTPRequest.request(url, parameters: params){
            api in
            var comments:[CommentDS]?
            if let json = api.json{
                comments = CommentDS.initializeArray(json)
            }
            completionHandler(api, comments: comments)
        }
    }
    
    /**
     List the likes for a shot
     
     - parameter perPage:           Resources per page, maximum = 100
     - parameter page: Current page of resource. Default = 1
     - parameter shotID: id assigned to shot
     - parameter completionHandler: return NSError, JSON, NSURLResponse  and an array of likes
     */
    
    public class func getLikes(shotID shotID: Int, perPage: Int = 30, page: Int = 1, completionHandler: (ClientReturn, likes: [ShotLikesDS]?) -> Void) -> (){
        let url = "/shots/\(shotID)/likes"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage
        params["page"] = page
        
        HTTPRequest.request(url, parameters: params){
            api in
            var likes:[ShotLikesDS]?
            if let json = api.json{
                likes = ShotLikesDS.initializeArray(json)
            }
            completionHandler(api, likes: likes)
        }
    }
    
    /**
     List projects for a shot
     
     - parameter perPage:           Resources per page, maximum = 100
     - parameter page: Current page of resource. Default = 1
     - parameter shotID: id assigned to shot
     - parameter completionHandler: return NSError, JSON, NSURLResponse  and an array of projects
     */
    
    public class func getProjects(shotID shotID: Int, perPage: Int = 30, page: Int = 1, completionHandler: (ClientReturn, projects: [ProjectDS]?) -> ()) -> (){
        let url = "/shots/\(shotID)/projects"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage
        params["page"] = page
        
        HTTPRequest.request(url, parameters: params){
            api in
            var project:[ProjectDS]?
            if let json = api.json{
                project = ProjectDS.initializeArray(json)
            }
            completionHandler(api, projects: project)
        }
    }
    
    /**
     List rebounds for a shot
     
     
     - parameter perPage:           Resources per page, maximum = 100
     - parameter page: Current page of resource. Default = 1
     - parameter shotID: id assigned to shot
     - parameter completionHandler: return NSError, JSON, NSURLResponse  and an array of rebounds.
     */
    
    public class func getRebounds(shotID shotID: Int, perPage: Int = 30, page: Int = 1, completionHandler: (ClientReturn, rebounds: [ShotsDS]?) -> ()) -> (){
        let url = "/shots/\(shotID)/rebounds"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage
        params["page"] = page
        
        HTTPRequest.request(url, parameters: params){
            api in
            var shots:[ShotsDS]?
            if let json = api.json{
                shots = ShotsDS.initializeArray(json)
            }
            completionHandler(api, rebounds: shots)
        }
    }
}

//MARK: User/Team Model

public class UserAndTeamBaseModel{
    public var id: Int!
    public var name: String!
    public var username: String!
    public var html_url: String!
    public var avatar_url: String!
    public var bio: String!
    public var location: String!
    public var links: (web: String?, twitter: String?)
    public var buckets_count: Int!
    public var comments_received_count: Int!
    public var followers_count: Int!
    public var followings_count: Int!
    public var likes_count: Int!
    public var likes_received_count: Int!
    public var projects_count: Int!
    public var rebounds_received_count: Int!
    public var shots_count: Int!
    public var can_upload_shot: Bool!
    public var type: String!
    public var pro: Bool!
    public var buckets_url: String!
    public var followers_url: String!
    public var following_url: String!
    public var likes_url: String!
    public var projects_url: String!
    public var shots_url: String!
    public var teams_url: String!
    public var created_at: String!
    public var updated_at: String!
    
    init(json: JSON){
        
        id = json["id"].int
        name = json["name"].string
        username = json["username"].string
        html_url = json["html_url"].string
        avatar_url = json["avatar_url"].string
        bio = json["bio"].string
        location = json["location"].string
        links = (web: json["links"]["web"].string, twitter: json["links"]["twitter"].string)
        buckets_count = json["buckets_count"].int
        comments_received_count = json["comments_received_count"].int
        followers_count = json["followers_count"].int
        followings_count = json["followings_count"].int
        likes_count = json["likes_count"].int
        likes_received_count = json["likes_received_count"].int
        projects_count = json["projects_count"].int
        rebounds_received_count = json["rebounds_received_count"].int
        shots_count = json["shots_count"].int
        can_upload_shot = json["can_upload_shot"].bool
        type = json["type"].string
        pro = json["pro"].bool
        buckets_url = json["buckets_url"].string
        followers_url = json["followers_url"].string
        likes_url = json["likes_url"].string
        projects_url = json["projects_url"].string
        shots_url = json["shots_url"].string
        teams_url = json["teams_url"].string
        created_at = json["created_at"].string
        updated_at = json["updated_at"].string
        
    }
}

//MARK: User

public class FollowersDS{
    
    public var id: Int!
    public var created_at: String!
    public var follower: UserDS!
    
    init(json: JSON){
        id = json["id"].int
        created_at = json["created_at"].string
        follower = UserDS.init(json: json["follower"])
    }
    
    public class func initializeArray(json: JSON)->[FollowersDS] {
        var followersArray = [FollowersDS]()
        for i in 0..<json.count{
            followersArray.append(FollowersDS(json: json[i]))
        }
        return followersArray
    }
    
}


public class FolloweeDS{
    
    public var id: Int!
    public var created_at: String!
    public var followee: UserDS!
    
    init(json: JSON){
        id = json["id"].int
        created_at = json["created_at"].string
        followee = UserDS.init(json: json["followee"])
    }
    
    public class func initializeArray(json: JSON)->[FolloweeDS] {
        var followersArray = [FolloweeDS]()
        for i in 0..<json.count{
            followersArray.append(FolloweeDS(json: json[i]))
        }
        return followersArray
    }
    
}

public class UserDS: UserAndTeamBaseModel{
    
    public class func initializeArray(json: JSON)->[UserDS] {
        var userArray = [UserDS]()
        for i in 0..<json.count{
            userArray.append(UserDS(json: json[i]))
        }
        return userArray
    }
    /**
     Get a single user
     
     - parameter username:          username assigned to user
     - parameter completionHandler: return NSError, JSON, NSURLResponse and a user object.
     */
    
    public class func getUser(username: String, completionHandler: (ClientReturn, user: UserDS?) -> ()) -> (){
        let url = "/users/\(username)"
        HTTPRequest.request(url, parameters: nil){
            api in
            var user: UserDS?
            if let json = api.json{
                user = UserDS.init(json: json)
            }
            completionHandler(api, user: user)
        }
    }
    
    /**
     List a user’s buckets
     - parameter username:          username assigned to user
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of buckets.
     
     */
    public class func getBuckets(username: String, perPage: Int = 30, page: Int = 1, completionHandler: (ClientReturn, buckets: [BucketDS]?) -> ()) -> (){
        let url = "/users/\(username)/buckets"
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
     List followers of a user
     - parameter username:          username assigned to user
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse  and an array followers.
     
     */
    
    public class func getFollowers(username: String, perPage: Int = 30, page: Int = 1, completionHandler: (ClientReturn, followers: [FollowersDS]?) -> ()) -> (){
        let url = "/users/\(username)/followers"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage
        params["page"] = page
        HTTPRequest.request(url, parameters: params){
            api in
            var users: [FollowersDS]?
            if let json = api.json{
                users = FollowersDS.initializeArray(json)
            }
            completionHandler(api, followers: users)
        }
    }
    
    /**
     List users followed by a user
     - parameter username:          username assigned to user
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of followees.
     
     */
    
    public class func getFollowing(username: String, perPage: Int = 30, page: Int = 1, completionHandler: (ClientReturn, followees: [FolloweeDS]?) -> ()) -> (){
        let url = "/users/\(username)/following"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage
        params["page"] = page
        HTTPRequest.request(url, parameters: params){
            api in
            var users: [FolloweeDS]?
            if let json = api.json{
                users = FolloweeDS.initializeArray(json)
            }
            completionHandler(api, followees: users)
        }
    }
    
    /**
     Check if one user is following another
     
     - parameter username:          username of user
     - parameter targetUser:        username of user to be checked if following
     - parameter completionHandler: return NSError, JSON, NSURLResponse and returns true if status code = 204, else returns false if status code = 404
     */
    public class func checkIfUserFollowingUser(username: String, targetUser: String, completionHandler: (ClientReturn, isFollowing: Bool) -> ()) -> (){
        let url = "/users/\(username)/following/\(targetUser)"
        HTTPRequest.request(url, parameters: nil){
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
     List shot likes for a user
     - parameter username:          username assigned to user
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of shots.
     */
    
    public class func getLikes(username: String, perPage: Int = 30, page: Int = 1, completionHandler: (ClientReturn, likes: [UserLikesDS]?) -> ()) -> (){
        let url = "/users/\(username)/likes"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage
        params["page"] = page
        HTTPRequest.request(url, parameters: params){
            api in
            var shots: [UserLikesDS]?
            if let json = api.json{
                shots = UserLikesDS.initializeArray(json)
            }
            completionHandler(api, likes: shots)
        }
    }
    
    /**
     List a user’s projects
     - parameter username:          username assigned to user
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of projects.
     */
    
    public class func getProjects(username: String, perPage: Int = 30, page: Int = 1, completionHandler: (ClientReturn, projects: [ProjectDS]?) -> ()) -> (){
        let url = "/users/\(username)/projects"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage
        params["page"] = page
        HTTPRequest.request(url, parameters: params){
            api in
            var projects: [ProjectDS]?
            if let json = api.json{
                projects = ProjectDS.initializeArray(json)
            }
            completionHandler(api, projects: projects)
        }
    }
    
    /**
     List shots for a user
     - parameter username:          username assigned to user
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of shots.
     */
    
    public class func getShots(username: String, perPage: Int = 30, page: Int = 1, completionHandler: (ClientReturn, shots: [ShotsDS]?) -> ()) -> (){
        let url = "/users/\(username)/shots"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage
        params["page"] = page
        HTTPRequest.request(url, parameters: params){
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
     - parameter username:          username assigned to user
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of teams.
     */
    
    public class func getTeams(username: String, completionHandler: (ClientReturn, teams: [TeamDS]?) -> ()) -> (){
        let url = "/users/\(username)/teams"
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

//Mark: Team

public class TeamDS: UserAndTeamBaseModel{
    
    public var members_count: Int!
    public var members_url: String!
    public var team_shots_url: String!
    
    public init(team: JSON){
        super.init(json: team)
        members_count = team["members_count"].int
        members_url = team["members_url"].string
        team_shots_url = team["team_shots_url"].string
    }
    
    public class func initializeArray(json: JSON)->[TeamDS] {
        var teamArray = [TeamDS]()
        for i in 0..<json.count{
            teamArray.append(TeamDS(team: json[i]))
        }
        return teamArray
    }
    
    /**
     List a team’s members
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of users.
     */
    
    public class func getTeamMembers(teamName: String, perPage: Int = 30, page: Int = 1, completionHandler: (ClientReturn, members: [UserDS]?) -> ()) -> (){
        let url = "/teams/\(teamName)/members"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage
        params["page"] = page
        HTTPRequest.request(url, parameters: params){
            api in
            var members: [UserDS]?
            if let json = api.json{
                members = UserDS.initializeArray(json)
            }
            completionHandler(api, members: members)
        }
    }
    
    /**
     List shots for a team
     
     - parameter teamId: id assigned to team
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of shots.
     */
    
    public class func getTeamShots(teamName: String, perPage: Int = 30, page: Int = 1, completionHandler: (ClientReturn, shots: [ShotsDS]?) -> ()) -> (){
        let url = "/teams/\(teamName)/shots"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage
        params["page"] = page
        HTTPRequest.request(url, parameters: params){
            api in
            var shots: [ShotsDS]?
            if let json = api.json{
                shots = ShotsDS.initializeArray(json)
            }
            completionHandler(api, shots: shots)
        }
        
    }
}

//Mark: Likes

public class ShotLikesDS{
    public var id: Int!
    public var created_at: String!
    public var user: UserDS!
    
    public init(json: JSON){
        id = json["id"].int
        created_at = json["created_at"].string
        user = UserDS.init(json: json["user"])
    }
    
    public class func initializeArray(json: JSON)->[ShotLikesDS] {
        var likesArray = [ShotLikesDS]()
        for i in 0..<json.count {
            likesArray.append(ShotLikesDS(json: json[i]))
        }
        return likesArray
    }
}

public class UserLikesDS {
    public var id: Int!
    public var created_at: String!
    public var shot: ShotsDS!
    
    public init(json: JSON){
        id = json["id"].int
        created_at = json["created_at"].string
        shot = ShotsDS.init(json: json["shot"])
    }
    
    public class func initializeArray(json: JSON)->[UserLikesDS] {
        var likesArray = [UserLikesDS]()
        for i in 0..<json.count {
            likesArray.append(UserLikesDS(json: json[i]))
        }
        return likesArray
    }
}

//Mark: Comments

public class CommentDS{
    
    public var id: Int!
    public var body: String!
    public var likes_count: Int!
    public var likes_url: String!
    public var created_at: String!
    public var updated_at: String!
    public var user: UserDS!
    
    public init(json: JSON){
        id = json["id"].int
        body = json["body_text"].string
        likes_count = json["likes_count"].int
        likes_url = json["likes_url"].string
        created_at = json["created_at"].string
        updated_at = json["updated_at"].string
        user = UserDS.init(json: json["user"])
    }
    
    public class func initializeArray(json: JSON)->[CommentDS] {
        var comments = [CommentDS]()
        for i in 0..<json.count {
            comments.append(CommentDS(json: json[i]))
        }
        return comments
    }
}

//Mark: Attachment

public class AttachmentDS{
    
    public var id: Int!
    public var url: String!
    public var thumbnail_url: String!
    public var size: Int!
    public var content_type: String!
    public var views_count: Int!
    public var created_at: String!
    
    public init(json: JSON){
        id = json["id"].int
        url = json["url"].string
        thumbnail_url = json["thumbnail_url"].string
        size = json["size"].int
        content_type = json["content_type"].string
        views_count = json["views_count"].int
        created_at = json["created_at"].string
    }
    
    public class func initializeArray(json: JSON)->[AttachmentDS] {
        var attachments = [AttachmentDS]()
        for i in 0..<json.count {
            attachments.append(AttachmentDS(json: json[i]))
        }
        
        return attachments
    }
    
    
}


//Mark: Bucket

public class BucketDS{
    
    public var id: Int!
    public var name: String!
    public var description: String?
    public var shots_count: Int!
    public var created_at: String!
    public var updated_at: String!
    public var user: UserDS!
    
    public init(json: JSON){
        id = json["id"].int
        name = json["name"].string
        description = json["description"].string
        created_at = json["created_at"].string
        updated_at = json["updated_at"].string
        user = UserDS.init(json: json["user"])
    }
    
    public class func initializeArray(json: JSON)->[BucketDS] {
        var buckets = [BucketDS]()
        for i in 0...json.count {
            buckets.append(BucketDS(json: json[i]))
        }
        return buckets
    }
    
    /**
     Get a bucket
     - parameter bucketId: ID assigned to bucket
     - parameter completionHandler:   return NSError, JSON, NSURLResponse and a bucket object
     */
    
    public class func getBucket(bucketId bucketId: Int, completionHandler: (clientReturn: ClientReturn?, bucket: BucketDS?) -> ()) -> (){
        let url = "/buckets/\(bucketId)"
        HTTPRequest.request(url, parameters: nil, completionHandler: {
            api in
            var bucket: BucketDS?
            if let json = api.json{
                bucket = BucketDS.init(json: json)
            }
            completionHandler(clientReturn: api, bucket: bucket)
            
        })
    }
    
    /**
     List shots for a bucket
     - parameter bucketId: ID assigned to bucket
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler:   return NSError, JSON, NSURLResponse and an array of shots
     */
    
    public class func getShots(bucketId bucketId: Int, perPage: Int = 30, page: Int = 1, completionHandler: (clientReturn: ClientReturn?, shots: [ShotsDS]?) -> ()) -> (){
        let url = "/buckets/\(bucketId)/shots"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage
        params["page"] = page
        HTTPRequest.request(url, parameters: params, completionHandler: {
            api in
            var shots: [ShotsDS]?
            if let json = api.json{
                shots = ShotsDS.initializeArray(json)
            }
            completionHandler(clientReturn: api, shots: shots)
            
        })
    }
    
}

//Mark: Project

public class ProjectDS{
    
    public var id: Int!
    public var name: String!
    public var description: String?
    public var shots_count: Int!
    public var created_at: String!
    public var updated_at: String!
    public var user: UserDS!
    
    public init(json: JSON){
        id = json["id"].int
        name = json["name"].string
        description = json["description"].string
        created_at = json["created_at"].string
        updated_at = json["updated_at"].string
        user = UserDS.init(json: json["user"])
    }
    
    public class func initializeArray(json: JSON)->[ProjectDS] {
        var projects = [ProjectDS]()
        for i in 0...json.count {
            projects.append(ProjectDS(json: json[i]))
        }
        return projects
    }
    
    /**
     Get a project
     - parameter projectID: ID assigned to project
     - parameter completionHandler:   return NSError, JSON, NSURLResponse and a project object
     */
    
    public class func getProject(projectId projectId: Int, completionHandler: (clientReturn: ClientReturn?, project: ProjectDS?) -> ()) -> (){
        let url = "/projects/\(projectId)"
        HTTPRequest.request(url, parameters: nil, completionHandler: {
            api in
            var bucket: ProjectDS?
            if let json = api.json{
                bucket = ProjectDS.init(json: json)
            }
            completionHandler(clientReturn: api, project: bucket)
            
        })
    }
    
    /**
     List shots for a project
     - parameter projectId: ID assigned to project
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler:   return NSError, JSON, NSURLResponse and an array of shots
     */
    
    public class func getShots(projectID projectId: Int, page: Int = 0, perPage: Int = 30, completionHandler: (clientReturn: ClientReturn?, shots: [ShotsDS]?) -> ()) -> (){
        let url = "/projects/\(projectId)/shots"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage
        params["page"] = page
        HTTPRequest.request(url, parameters: params, completionHandler: {
            api in
            var shots: [ShotsDS]?
            if let json = api.json{
                shots = ShotsDS.initializeArray(json)
            }
            completionHandler(clientReturn: api, shots: shots)
            
        })
    }
    
}
