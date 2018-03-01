//
//  AFWrapper.swift
//  DocUScribe
//
//  Created by RanganathPavan on 7/26/17.
//  Copyright © 2017 Saince. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class AFWrapper: NSObject {
    
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    class func isConnectedToWifi() ->Bool {
        return NetworkReachabilityManager()!.isReachableOnEthernetOrWiFi
    }
    
    class func requestGETURL(_ strURL: String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        Alamofire.request(strURL).responseJSON { (responseObject) -> Void in
            
            //print(responseObject)

            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    class func requestPOSTURL(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        manager.request(strURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            
            //print(responseObject)
            
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
}

extension UIActivityIndicatorView {
    
    convenience init(activityIndicatorStyle: UIActivityIndicatorViewStyle, color: UIColor, placeInTheCenterOf parentView: UIView) {
        self.init(activityIndicatorStyle: activityIndicatorStyle)
        center = parentView.center
        self.color = color
        parentView.addSubview(self)
    }
}

