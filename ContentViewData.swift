//
//  ContentViewData.swift
//  NewsAndStock
//
//  Created by PSH-LP-C02G37NYQ6L4 on 01/05/23.
// var webServiceObj = WebAPIServices()

import Foundation



struct GetNewsEverything : Decodable{
    let status : String?
    let totalResults : Int?
    let articles : [GetNewsEverythingAPIDataArticles]?
}

struct GetNewsEverythingAPIDataRespSource : Decodable{
    let id : String?
    let name : String?
}
struct GetNewsEverythingAPIDataArticles : Decodable{
    
    let source : GetNewsEverythingAPIDataRespSource?
    let author : String?
    let title : String?
    let description : String?
    let url : String?
    let urlToImage : String?
    let publishedAt : String?
    let content : String?
}

struct GetNewsEverythingAPIDataArticlesSourceUI : Identifiable{
    var id = ""
    var name = ""
    
}
struct GetNewsEverythingAPIDataRespAPIDataArticlesUI : Identifiable{
    var id = UUID()
    var source = GetNewsEverythingAPIDataArticlesSourceUI()
    var author = ""
    var title = ""
    var description = ""
    var url = ""
    var urlToImage = ""
    var publishedAt = ""
    var content = ""
}

import SwiftyJSON

class ContentViewData : ObservableObject{
    
    var webServiceObj = WebAPIServices()
    
    @Published var alertMessage = ""
    @Published var showLoaderView = false
    @Published var totalResultsInt = 0
    @Published var pageNumber = 10
    @Published var showAlertMsg = false
    @Published var noRecordFound = false
    @Published var onScroll = false
    @Published var onScrollnewsFeeds = [GetNewsEverythingAPIDataRespAPIDataArticlesUI]()
    
    @Published var newsFeeds : [GetNewsEverythingAPIDataRespAPIDataArticlesUI]?
    func fetchNewsFeed(){
        self.onScroll = true
        webServiceObj.fetchNewsFeeds { isSucess,data,responseSwagger,err in
            
            self.showLoaderView = false
                           if let error  = err{
                               self.alertMessage = error.localizedDescription
                               self.showAlertMsg = true
                               return
                           }
                           if isSucess!{
                               guard let httpResponse = responseSwagger as? HTTPURLResponse else{
                                   return
                               }
                               switch httpResponse.statusCode {
                               case 401:
                                  // self.alertMessage = "Session expired"
                                 
                                   return
                               case 200:
                                   do{
                                    guard let data = data  else{
                                        self.noRecordFound = true
                                        self.alertMessage = "Something went wrong. Your request is not completed."
                                        self.showAlertMsg = true
                                        return
                                    }
                                    let getData : GetNewsEverything = try JSONDecoder().decode(GetNewsEverything.self, from : data)

                                       guard let totalResults = getData.totalResults else {
                                           
                                           return
                                       }
                                       self.totalResultsInt = totalResults
                                       
                                       guard let statusCode = getData.status else {
                                           self.alertMessage = "Something went wrong. Your request is not completed."
                                           self.showAlertMsg = true
                                           return
                                       }
                                       if statusCode == "ok" {


                                           self.newsFeeds = [GetNewsEverythingAPIDataRespAPIDataArticlesUI]()
                                           
                                              if let articles = getData.articles{

                                                  for article in articles{
                                                      
                                                      
                                                      var news = GetNewsEverythingAPIDataRespAPIDataArticlesUI()
                                                        
                                                        var source = GetNewsEverythingAPIDataArticlesSourceUI()
                                                       
                                                        source.id = article.source?.id ?? ""
                                                        source.name = article.source?.name ?? ""
                                                        news.source = source
                                                       
                                                      news.author = article.author ?? ""
                                                      news.title = article.title ?? ""
                                                      news.description = article.description ?? ""
                                                      news.url = article.url ?? ""
                                                      news.urlToImage = article.urlToImage ?? ""
                                                      news.publishedAt = article.publishedAt ?? ""
                                                      news.content = article.content ?? ""
                                                       
                                                      self.newsFeeds?.append(news)
                                                  }
                                               
                                                  if self.newsFeeds != nil {
                                                      
                                                      if self.newsFeeds!.count > 10{
                                                          
                                                          for index in 0...10{
                                                              
                                                              self.onScrollnewsFeeds.append(self.newsFeeds![index])
                                                          }
                                                          
                                                      }else{
                                                          
                                                          self.onScrollnewsFeeds = self.newsFeeds!
                                                      }
                                                      
                                                  }
                                                 
                                                  
                                                  self.onScroll = false
                                           }

                                       }else{
                                           self.alertMessage = ""//flagWiseMessage(flagMessage: getData.message ?? "", msg: "")
                                           self.showAlertMsg = true
                                       }

                                   }
                                    catch let error as NSError{
                                    self.alertMessage = error.localizedDescription
                                    self.showAlertMsg = true
                                      // self.showAlertMessage(vc: self, titleStr: AppName, messageStr: error.localizedDescription)
                                   }
                                   return
                               case 500:
                                   self.alertMessage = "Service Unavailable."
                                   self.showAlertMsg = true
                                   return
                               default:
                                    print("httpResponse.statusCode = \(httpResponse.statusCode)")
                                   }

                                  

                           }else{
                                 self.alertMessage = "noInternet"
                               self.showAlertMsg = true
                           }

            
        }
    }

    
    init(){}
    
    deinit{}
    
    
}


