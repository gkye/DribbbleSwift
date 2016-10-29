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

open class ConfigDS{
    open class func setAccessToken(_ token: String!){
        access_token = token
    }   
}



//MARK: Array protocol returns an array of types by initlizaing using the json passed
protocol ArrayProtocol {
    init(json: JSON)
}

extension ArrayProtocol {
    
    static func initArray<T:ArrayProtocol>(json: JSON) -> [T] {
        var array = [T]()
        json.forEach(){
            array.append(T.init(json: $0.1))
        }
        return array
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

open class ImagesDS{
    open var hidpi: String?
    open var normal: String!
    open var teaser: String!
    
    init(json: JSON){
        hidpi = json["hidpi"].string
        normal = json["normal"].string
        teaser = json["teaser"].string
    }
}


open class ShotsDS: ArrayProtocol{
    open var id : Int!
    open var title : String!
    open var description : String?
    open var width: Int!
    open var height: Int!
    open var images: ImagesDS!
    open var views_count : Int!
    open var likes_count :  Int!
    open var comments_count : Int!
    open var attachments_count: Int!
    open var rebounds_count: Int!
    open var buckets_count: Int!
    open var created_at: String!
    open var updated_at: String!
    open var html_url: String!
    open var attachments_url: String!
    open var buckets_url: String!
    open var comments_url: String!
    open var likes_url: String!
    open var projects_url: String!
    open var rebounds_url: String!
    open var animated: Bool!
    open var tags: [String]?
    open var user: UserDS!
    open var team: TeamDS?
    
    required public init(json: JSON){
        id = json["id"].int
        title = json["title"].string
        description = json["description_text"].string
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
        team = TeamDS.init(json: json["team"])
        
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
    
    open class func getShots(perPage: Int = 30, page: Int = 1, list: ShotListDS? = nil, sort: ShotSortDS? = nil, timeframe: ShotTimeFrameDS? = nil,date: String? = nil, completionHandler: @escaping (ClientReturn, _ shots: [ShotsDS]?) -> ()) -> (){
        
        let url = "/shots"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage as AnyObject?
        params["page"] = page as AnyObject?
        if(list != nil){
            params["list"] = list!.rawValue as AnyObject?
        }
        if(sort != nil){
            params["sort"] = sort!.rawValue as AnyObject?
        }
        if(timeframe != nil){
            params["timeframe"] = timeframe?.rawValue as AnyObject?
        }
        if(date != nil){
            params["date"] = date as AnyObject?
        }
        
        HTTPRequest.request(url, parameters: params){
            api in
            var shots: [ShotsDS]?
            if let json = api.json{
                shots = ShotsDS.initArray(json: json)
            }
            completionHandler(api, shots)
        }
    }
    
    /**
     List attachments for a shot
     
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter shotID:            id assigned to shot
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of attachments
     */
    open class func getAttachments(shotID: Int, perPage: Int = 30, page: Int = 1, completionHandler: @escaping (ClientReturn, _ attachments: [AttachmentDS]?) -> ()) -> (){
        let url = "/shots/\(shotID)/attachments"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage as AnyObject?
        params["page"] = page as AnyObject?
        
        HTTPRequest.request(url, parameters: params){
            api in
            var attachments: [AttachmentDS]?
            if let json = api.json{
                attachments = AttachmentDS.initArray(json: json)
            }
            completionHandler(api, attachments)
        }
    }
    
    /**
     List buckets for a shot
     
     - parameter perPage:           Resources per page, maximum = 100
     - parameter page: Current page of resource. Default = 1
     - parameter shotID: id assigned to shot
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of buckets
     */
    open class func getBuckets(shotID: Int, perPage: Int = 30, page: Int = 1, completionHandler: @escaping (ClientReturn, _ buckets: [BucketDS]?) -> ()) -> (){
        let url = "/shots/\(shotID)/buckets"
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
     List comments for a shot
     
     - parameter perPage:           Resources per page, maximum = 100. Default = 30
     - parameter page: Current page of resource. Default = 1
     - parameter shotID: id assigned to shot
     - parameter completionHandler: return NSError, JSON, NSURLResponse  and an array of comments
     */
    
    open class func getComments(shotID: Int, perPage: Int = 30, page: Int = 1, completionHandler: @escaping (ClientReturn, _ comments: [CommentDS]?) -> ()) -> (){
        let url = "/shots/\(shotID)/comments"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage as AnyObject?
        params["page"] = page as AnyObject?
        HTTPRequest.request(url, parameters: params){
            api in
            var comments:[CommentDS]?
            if let json = api.json{
                comments = CommentDS.initArray(json: json)
            }
            completionHandler(api, comments)
        }
    }
    
    /**
     List the likes for a shot
     
     - parameter perPage:           Resources per page, maximum = 100
     - parameter page: Current page of resource. Default = 1
     - parameter shotID: id assigned to shot
     - parameter completionHandler: return NSError, JSON, NSURLResponse  and an array of likes
     */
    
    open class func getLikes(shotID: Int, perPage: Int = 30, page: Int = 1, completionHandler: @escaping (ClientReturn, _ likes: [ShotLikesDS]?) -> Void) -> (){
        let url = "/shots/\(shotID)/likes"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage as AnyObject?
        params["page"] = page as AnyObject?
        
        HTTPRequest.request(url, parameters: params){
            api in
            var likes:[ShotLikesDS]?
            if let json = api.json{
                likes = ShotLikesDS.initArray(json: json)
            }
            completionHandler(api, likes)
        }
    }
    
    /**
     List projects for a shot
     
     - parameter perPage:           Resources per page, maximum = 100
     - parameter page: Current page of resource. Default = 1
     - parameter shotID: id assigned to shot
     - parameter completionHandler: return NSError, JSON, NSURLResponse  and an array of projects
     */
    
    open class func getProjects(shotID: Int, perPage: Int = 30, page: Int = 1, completionHandler: @escaping (ClientReturn, _ projects: [ProjectDS]?) -> ()) -> (){
        let url = "/shots/\(shotID)/projects"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage as AnyObject?
        params["page"] = page as AnyObject?
        
        HTTPRequest.request(url, parameters: params){
            api in
            var project:[ProjectDS]?
            if let json = api.json{
                project = ProjectDS.initArray(json: json)
            }
            completionHandler(api, project)
        }
    }
    
    /**
     List rebounds for a shot
     
     
     - parameter perPage:           Resources per page, maximum = 100
     - parameter page: Current page of resource. Default = 1
     - parameter shotID: id assigned to shot
     - parameter completionHandler: return NSError, JSON, NSURLResponse  and an array of rebounds.
     */
    
    open class func getRebounds(shotID: Int, perPage: Int = 30, page: Int = 1, completionHandler: @escaping (ClientReturn, _ rebounds: [ShotsDS]?) -> ()) -> (){
        let url = "/shots/\(shotID)/rebounds"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage as AnyObject?
        params["page"] = page as AnyObject?
        
        HTTPRequest.request(url, parameters: params){
            api in
            var shots:[ShotsDS]?
            if let json = api.json{
                shots = ShotsDS.initArray(json: json)
            }
            completionHandler(api, shots)
        }
    }
}

//MARK: User/Team Model

open class UserAndTeamBaseModel{
    open var id: Int!
    open var name: String!
    open var username: String!
    open var html_url: String!
    open var avatar_url: String!
    open var bio: String!
    open var location: String!
    open var links: (web: String?, twitter: String?)
    open var buckets_count: Int!
    open var comments_received_count: Int!
    open var followers_count: Int!
    open var followings_count: Int!
    open var likes_count: Int!
    open var likes_received_count: Int!
    open var projects_count: Int!
    open var rebounds_received_count: Int!
    open var shots_count: Int!
    open var can_upload_shot: Bool!
    open var type: String!
    open var pro: Bool!
    open var buckets_url: String!
    open var followers_url: String!
    open var following_url: String!
    open var likes_url: String!
    open var projects_url: String!
    open var shots_url: String!
    open var teams_url: String!
    open var created_at: String!
    open var updated_at: String!
    open var teams_count: Int!

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
        teams_count = json["teams_count"].int
    }
}

//MARK: FollowersDS

open class FollowersDS: ArrayProtocol{
    
    open var id: Int!
    open var created_at: String!
    open var follower: UserDS!

    required public init(json: JSON){
        id = json["id"].int
        created_at = json["created_at"].string
        follower = UserDS.init(json: json["follower"])
    }
}

//MARK: FolloweeDS
open class FolloweeDS: ArrayProtocol{
    
    open var id: Int!
    open var created_at: String!
    open var followee: UserDS!
    
    required public init(json: JSON){
        id = json["id"].int
        created_at = json["created_at"].string
        followee = UserDS.init(json: json["followee"])
    }
    
}

//MARK: UserDS
open class UserDS: UserAndTeamBaseModel, ArrayProtocol{
    
    open var team: TeamDS?
    override required public init(json: JSON) {
        super.init(json: json)
        
        if(json["type"] == "Team"){
            team = TeamDS.init(json: json)
        }
    }

    /**
     Get a single user
     
     - parameter username:          username assigned to user
     - parameter completionHandler: return NSError, JSON, NSURLResponse and a user object.
     */
    
    open class func getUser(_ username: String, completionHandler: @escaping (ClientReturn, _ user: UserDS?) -> ()) -> (){
        let url = "/users/\(username)"
        HTTPRequest.request(url, parameters: nil){
            api in
            var user: UserDS?
            if let json = api.json{
                user = UserDS.init(json: json)
            }
            completionHandler(api, user)
        }
    }
    
    /**
     List a user’s buckets
     - parameter username:          username assigned to user
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of buckets.
     
     */
    open class func getBuckets(_ username: String, perPage: Int = 30, page: Int = 1, completionHandler: @escaping (ClientReturn, _ buckets: [BucketDS]?) -> ()) -> (){
        let url = "/users/\(username)/buckets"
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
     List followers of a user
     - parameter username:          username assigned to user
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse  and an array followers.
     
     */
    
    open class func getFollowers(_ username: String, perPage: Int = 30, page: Int = 1, completionHandler: @escaping (ClientReturn, _ followers: [FollowersDS]?) -> ()) -> (){
        let url = "/users/\(username)/followers"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage as AnyObject?
        params["page"] = page as AnyObject?
        HTTPRequest.request(url, parameters: params){
            api in
            var users: [FollowersDS]?
            if let json = api.json{
                users = FollowersDS.initArray(json: json)
            }
            completionHandler(api, users)
        }
    }
    
    /**
     List users followed by a user
     - parameter username:          username assigned to user
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of followees.
     
     */
    
    open class func getFollowing(_ username: String, perPage: Int = 30, page: Int = 1, completionHandler: @escaping (ClientReturn, _ followees: [FolloweeDS]?) -> ()) -> (){
        let url = "/users/\(username)/following"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage as AnyObject?
        params["page"] = page as AnyObject?
        HTTPRequest.request(url, parameters: params){
            api in
            var users: [FolloweeDS]?
            if let json = api.json{
                users = FolloweeDS.initArray(json: json)
            }
            completionHandler(api, users)
        }
    }
    
    /**
     Check if one user is following another
     
     - parameter username:          username of user
     - parameter targetUser:        username of user to be checked if following
     - parameter completionHandler: return NSError, JSON, NSURLResponse and returns true if status code = 204, else returns false if status code = 404
     */
    open class func checkIfUserFollowingUser(_ username: String, targetUser: String, completionHandler: @escaping (ClientReturn, _ isFollowing: Bool) -> ()) -> (){
        let url = "/users/\(username)/following/\(targetUser)"
        HTTPRequest.request(url, parameters: nil){
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
     List shot likes for a user
     - parameter username:          username assigned to user
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of shots.
     */
    
    open class func getLikes(_ username: String, perPage: Int = 30, page: Int = 1, completionHandler: @escaping (ClientReturn, _ likes: [UserLikesDS]?) -> ()) -> (){
        let url = "/users/\(username)/likes"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage as AnyObject?
        params["page"] = page as AnyObject?
        HTTPRequest.request(url, parameters: params){
            api in
            var shots: [UserLikesDS]?
            if let json = api.json{
                shots = UserLikesDS.initArray(json: json)
            }
            completionHandler(api, shots)
        }
    }
    
    
    /**
     List a user’s projects
     - parameter username:          username assigned to user
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of projects.
     */
    
    open class func getProjects(_ username: String, perPage: Int = 30, page: Int = 1, completionHandler: @escaping (ClientReturn, _ projects: [ProjectDS]?) -> ()) -> (){
        let url = "/users/\(username)/projects"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage as AnyObject?
        params["page"] = page as AnyObject?
        HTTPRequest.request(url, parameters: params){
            api in
            var projects: [ProjectDS]?
            if let json = api.json{
                projects = ProjectDS.initArray(json: json)
            }
            completionHandler(api, projects)
        }
    }
    
    /**
     List shots for a user
     - parameter username:          username assigned to user
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of shots.
     */
    
    open class func getShots(_ username: String, perPage: Int = 30, page: Int = 1, completionHandler: @escaping (ClientReturn, _ shots: [ShotsDS]?) -> ()) -> (){
        let url = "/users/\(username)/shots"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage as AnyObject?
        params["page"] = page as AnyObject?
        HTTPRequest.request(url, parameters: params){
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
     - parameter username:          username assigned to user
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of teams.
     */
    
    open class func getTeams(_ username: String, completionHandler: @escaping (ClientReturn, _ teams: [TeamDS]?) -> ()) -> (){
        let url = "/users/\(username)/teams"
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

//Mark: Team

open class TeamDS: UserAndTeamBaseModel, ArrayProtocol{
    
    open var members_count: Int!
    open var members_url: String!
    open var team_shots_url: String!
    
    public required override init(json: JSON){
        super.init(json: json)
        members_count = json["members_count"].int
        members_url = json["members_url"].string
        team_shots_url = json["team_shots_url"].string
    }
    
    
    /**
     List a team’s members
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of users.
     */
    
    open class func getTeamMembers(_ teamName: String, perPage: Int = 30, page: Int = 1, completionHandler: @escaping (ClientReturn, _ members: [UserDS]?) -> ()) -> (){
        let url = "/teams/\(teamName)/members"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage as AnyObject?
        params["page"] = page as AnyObject?
        HTTPRequest.request(url, parameters: params){
            api in
            var members: [UserDS]?
            if let json = api.json{
                members = UserDS.initArray(json: json)
            }
            completionHandler(api, members)
        }
    }
    
    /**
     List shots for a team
     
     - parameter teamId: id assigned to team
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler: return NSError, JSON, NSURLResponse and an array of shots.
     */
    
    open class func getTeamShots(_ teamName: String, perPage: Int = 30, page: Int = 1, completionHandler: @escaping (ClientReturn, _ shots: [ShotsDS]?) -> ()) -> (){
        let url = "/teams/\(teamName)/shots"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage as AnyObject?
        params["page"] = page as AnyObject?
        HTTPRequest.request(url, parameters: params){
            api in
            var shots: [ShotsDS]?
            if let json = api.json{
                shots = ShotsDS.initArray(json: json)
            }
            completionHandler(api, shots)
        }
        
    }
}

//Mark: Likes

//MARK: ShotLikes
open class ShotLikesDS: ArrayProtocol{
    open var id: Int!
    open var created_at: String!
    open var user: UserDS!
    
    public required init(json: JSON){
        id = json["id"].int
        created_at = json["created_at"].string
        user = UserDS.init(json: json["user"])
    }
}

//MARK: UserLikes
open class UserLikesDS: ArrayProtocol {
    open var id: Int!
    open var created_at: String!
    open var shot: ShotsDS!
    
    public required init(json: JSON){
        id = json["id"].int
        created_at = json["created_at"].string
        shot = ShotsDS.init(json: json["shot"])
    }
}

//Mark: Comments

open class CommentDS: ArrayProtocol{
    
    open var id: Int!
    open var body: String!
    open var likes_count: Int!
    open var likes_url: String!
    open var created_at: String!
    open var updated_at: String!
    open var user: UserDS!
    
    public required init(json: JSON){
        id = json["id"].int
        body = json["body_text"].string
        likes_count = json["likes_count"].int
        likes_url = json["likes_url"].string
        created_at = json["created_at"].string
        updated_at = json["updated_at"].string
        user = UserDS.init(json: json["user"])
    }
}

//Mark: Attachment

open class AttachmentDS: ArrayProtocol{
    
    open var id: Int!
    open var url: String!
    open var thumbnail_url: String!
    open var size: Int!
    open var content_type: String!
    open var views_count: Int!
    open var created_at: String!
    
    public required init(json: JSON){
        id = json["id"].int
        url = json["url"].string
        thumbnail_url = json["thumbnail_url"].string
        size = json["size"].int
        content_type = json["content_type"].string
        views_count = json["views_count"].int
        created_at = json["created_at"].string
    }
}


//Mark: Bucket

open class BucketDS: ArrayProtocol{
    
    open var id: Int!
    open var name: String!
    open var description: String?
    open var shots_count: Int!
    open var created_at: String!
    open var updated_at: String!
    open var user: UserDS!
    
    public required init(json: JSON){
        id = json["id"].int
        name = json["name"].string
        description = json["description"].string
        created_at = json["created_at"].string
        updated_at = json["updated_at"].string
        user = UserDS.init(json: json["user"])
    }

    
    /**
     Get a bucket
     - parameter bucketId: ID assigned to bucket
     - parameter completionHandler:   return NSError, JSON, NSURLResponse and a bucket object
     */
    
    open class func getBucket(bucketId: Int, completionHandler: @escaping (_ clientReturn: ClientReturn?, _ bucket: BucketDS?) -> ()) -> (){
        let url = "/buckets/\(bucketId)"
        HTTPRequest.request(url, parameters: nil, completionHandler: {
            api in
            var bucket: BucketDS?
            if let json = api.json{
                bucket = BucketDS.init(json: json)
            }
            completionHandler(api, bucket)
            
        })
    }
    
    /**
     List shots for a bucket
     - parameter bucketId: ID assigned to bucket
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler:   return NSError, JSON, NSURLResponse and an array of shots
     */
    
    open class func getShots(bucketId: Int, perPage: Int = 30, page: Int = 1, completionHandler: @escaping (_ clientReturn: ClientReturn?, _ shots: [ShotsDS]?) -> ()) -> (){
        let url = "/buckets/\(bucketId)/shots"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage as AnyObject?
        params["page"] = page as AnyObject?
        HTTPRequest.request(url, parameters: params, completionHandler: {
            api in
            var shots: [ShotsDS]?
            if let json = api.json{
                shots = ShotsDS.initArray(json: json)
            }
            completionHandler(api, shots)
            
        })
    }
    
}

//Mark: Project

open class ProjectDS: ArrayProtocol{
    
    open var id: Int!
    open var name: String!
    open var description: String?
    open var shots_count: Int!
    open var created_at: String!
    open var updated_at: String!
    open var user: UserDS!
    
    public required init(json: JSON){
        id = json["id"].int
        name = json["name"].string
        description = json["description"].string
        created_at = json["created_at"].string
        updated_at = json["updated_at"].string
        user = UserDS.init(json: json["user"])
    }
  
    
    /**
     Get a project
     - parameter projectID: ID assigned to project
     - parameter completionHandler:   return NSError, JSON, NSURLResponse and a project object
     */
    
    open class func getProject(projectId: Int, completionHandler: @escaping (_ clientReturn: ClientReturn?, _ project: ProjectDS?) -> ()) -> (){
        let url = "/projects/\(projectId)"
        HTTPRequest.request(url, parameters: nil, completionHandler: {
            api in
            var bucket: ProjectDS?
            if let json = api.json{
                bucket = ProjectDS.init(json: json)
            }
            completionHandler(api, bucket)
            
        })
    }
    
    /**
     List shots for a project
     - parameter projectId: ID assigned to project
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter completionHandler:   return NSError, JSON, NSURLResponse and an array of shots
     */
    
    open class func getShots(projectID projectId: Int, page: Int = 0, perPage: Int = 30, completionHandler: @escaping (_ clientReturn: ClientReturn?, _ shots: [ShotsDS]?) -> ()) -> (){
        let url = "/projects/\(projectId)/shots"
        var params: [String: AnyObject] = [:]
        params["per_page"] = perPage as AnyObject?
        params["page"] = page as AnyObject?
        HTTPRequest.request(url, parameters: params, completionHandler: {
            api in
            var shots: [ShotsDS]?
            if let json = api.json{
                shots = ShotsDS.initArray(json: json)
            }
            completionHandler(api, shots)
            
        })
    }
    
}
