//
//  WebAPIManager.swift
//  NewsAndStock
//
//  Created by PSH-LP-C02G37NYQ6L4 on 01/05/23.
//

import Foundation
import UIKit

enum News : String {
    case everything
    
}
enum ApiMethod :String{
    case POST
    case GET
}

typealias responseSwaggerAPI = (_ connected:Bool?,_ data:Data?,_ response:URLResponse?,_ error : Error?) -> Void
typealias responseAPI = (_ isSucess:Bool?,_ data:Data?,_ error : Error?) -> Void


//import SwiftyJSON
class DMApiManager: NSObject{

    static let sharedInstance = DMApiManager()
    var baseURLSwaggerAPI = "https://newsapi.org/"
    var folderName = "v2/"
    let sessionDefault = URLSession(configuration:URLSessionConfiguration.default)

    func requestSwagerURL(type:String,method:String,param:[String:AnyObject],withCompletionHandler:(_ url:URL?,_ header:Data?,_ err : Error?) -> Void){
        
        var url = URL(string:baseURLSwaggerAPI+folderName+type)

        if method == ApiMethod.POST.rawValue{

            guard let jsonData = try? JSONSerialization.data(withJSONObject: param) else {
                return
            }
           // print(url.debugDescription)
            withCompletionHandler(url,jsonData,nil)
        }else{
            for paramItem in param{

                url = url!.appending(paramItem.key, value: paramItem.value as? String)
                // url = url!.appending(paramItem.key, value:(paramItem.value as! String))
            }
           // print(url.debugDescription)
            withCompletionHandler(url,nil,nil)
        }
    }
    func callSwagerAPI(type:String,method:String,param : [String: AnyObject],responseHandler:@escaping responseSwaggerAPI){
        if Reachability.isConnectedToNetwork(){
            requestSwagerURL(type: type, method: method, param:param){(url,header,requestError) in
                if UIApplication.shared.canOpenURL(url!){
                    var request = URLRequest(url:url!)
                        request.httpMethod = method
                   
                    if method == ApiMethod.POST.rawValue{
                        request.httpBody = header
                    }
                   // request.setValue(userDefaults.string(forKey:swaggerToken) ?? "", forHTTPHeaderField: "Authorization")
                    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
                    print(url!.absoluteString)

                    let task = sessionDefault.dataTask(with: request, completionHandler: {data, response,sessionError -> Void in
                        responseHandler(true,data,response, sessionError)

                    })

                    task.resume()

                }else {
                    responseHandler(true,nil,nil,requestError)
                }
            }
        }else{
            responseHandler(false,nil,nil,nil)
            print("Internet Connection not Available!")
        }
    }

}
extension URL {

    func appending(_ queryItem: String, value: String?) -> URL {

        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }

        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

        // Create query item
        let queryItem = URLQueryItem(name: queryItem, value: value)

        // Append the new query item in the existing query items array
        queryItems.append(queryItem)

        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems

        // Returns the url from new url components
        return urlComponents.url!
    }
}

import Combine

class ImageLoader: ObservableObject {
    
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}


class WebAPIServices{
    
    func fetchNewsFeeds(responseHandler:@escaping responseSwaggerAPI){
        let param = [
            "domains": "wsj.com",
            "apiKey": "506e1c3d0c2b4cd9991a956ce2b0141d",
        ]
        print("login Param = \(param)")
        DMApiManager.sharedInstance.callSwagerAPI(type: News.everything.rawValue, method: ApiMethod.GET.rawValue, param: param as [String : AnyObject]) {(isSucess,data,responseSwagger,err) in
            DispatchQueue.main.async{
                responseHandler(isSucess,data,responseSwagger,err)
            }
        }
    }
    
}
