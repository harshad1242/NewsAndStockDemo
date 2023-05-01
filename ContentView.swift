//
//  ContentView.swift
//  NewsAndStock
//
//  Created by PSH-LP-C02G37NYQ6L4 on 01/05/23.
//

import SwiftUI



struct ContentViewCell: View {
    
    
    @State var imgData : Data?
    @State var readMore = false
    @State var obj = GetNewsEverythingAPIDataRespAPIDataArticlesUI(id: UUID(),source: GetNewsEverythingAPIDataArticlesSourceUI(id: "independent",name: "Independent"), author: "Vishwam Sankaran",title: "Jack Dorsey says Twitter ‘went south’ after company’s sale to Elon Musk", description: "Tesla billionaire should have ‘walked away’ from Twitter acquisition, says co-founder", url: "https://www.independent.co.uk/tech/twitter-musk-dorsey-went-south-b2330037.html",urlToImage: "https://static.independent.co.uk/2021/11/29/19/newFile-4.jpg?quality=75&width=1200&auto=webp", publishedAt: "2023-05-01T05:09:57Z", content: "For free real time breaking news alerts sent straight to your inbox sign up to our breaking news emails\r\nSign up to our free breaking news emails\r\nJack Dorsey has openly criticised the leadership of … [+2941 chars")
    
    var body: some View {
        VStack{
            
            HStack{
                AsyncImage(
                            url: URL(string: obj.urlToImage ),
                            transaction: Transaction(animation: .easeInOut)
                        ) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .transition(.scale(scale: 0.1, anchor: .center))
                            case .failure:
                                Image(systemName: "wifi.slash")
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(width: 44, height: 44)
                        .background(Color.gray)
                        .clipShape(Circle())
                Text(obj.title).font(.subheadline).bold()
               
            }.font(.subheadline).multilineTextAlignment(.leading)
            VStack{
                HStack(spacing: 0){
                    Text(obj.description).font(Font.custom(FontNames.Lato.LatoBold,size:16)).lineLimit(1)
                    Text(readMore ? "Collapse" : "Read More...").foregroundColor(.blue).onTapGesture {
                        readMore.toggle()
                    }
                }
                
                if readMore{
                    Text(obj.content).font(Font.custom(FontNames.Lato.LatoRegular,size:14)).padding()
                }
            }
           
            
           // if self.imgData != nil{
            
           
           
               // Image(uiImage: UIImage(data:self.imgData!)!)
           // }
            
           
            
           
        }.padding(20)
        .onAppear(){
           
            if self.imgData == nil{
                
            
                 self.imgData = ImageLoader(urlString: obj.urlToImage).data
            }
            
        }
        
    }
}
/*
struct ContentViewCell_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewCell().previewLayout(.fixed(width: 400, height: 60))
    }
}*/

struct ContentView: View {
    
    @StateObject var dataObj = ContentViewData()
   
    var body: some View {
        VStack {
            
            HStack{
                Image(systemName: "line.3.horizontal")
                Spacer()
                Text("News And Stock")
                Spacer()
                Image(systemName: "globe.americas.fill")
            }.font(.title).padding().background(Color.red).foregroundColor(.white)
            HStack{
                Spacer()
                Button {
                    dataObj.isNewsActive = true
                    
                    if dataObj.isNewsActive{
                        dataObj.fetchNewsFeed()
                    }else{
                        dataObj.fetchStockMarket()
                    }
                } label: {
                    Text("News")
                }.padding(10).background( dataObj.isNewsActive ? Color.red : .white).foregroundColor(dataObj.isNewsActive ? Color.white : .red).cornerRadius(10)
                Spacer()
                
                Button {
                    dataObj.isNewsActive = false
                    
                    if dataObj.isNewsActive{
                        dataObj.fetchNewsFeed()
                    }else{
                        dataObj.fetchStockMarket()
                    }
                } label: {
                    Text("Stock Market")
                }.padding(10).background( dataObj.isNewsActive ? Color.white : .red).foregroundColor(dataObj.isNewsActive ? Color.red : .white).cornerRadius(10)
                Spacer()
            }.padding(20).frame(width: SCREEN_WIDTH - 40).overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(UIColor.red), lineWidth: 1)
            )
           // HStack{
            
            if dataObj.isNewsActive{
                ScrollView{
                    LazyVStack{
                        ForEach(dataObj.onScrollnewsFeeds) { obj in
                            
                            ContentViewCell(obj:obj).onAppear(){
                                
                                if dataObj.totalResultsInt != dataObj.onScrollnewsFeeds.count{
                                    
                                    if dataObj.totalResultsInt > dataObj.onScrollnewsFeeds.count{
                                        
                                        
                                        if let i1 = dataObj.onScrollnewsFeeds.firstIndex(where: {$0.title == dataObj.onScrollnewsFeeds.last?.title}){
                                            
                                            print("fetch index == \(i1)")
                                            
                                            if let currentIndex = dataObj.onScrollnewsFeeds.firstIndex(where: {$0.title == obj.title}){
                                                
                                                
                                                print("currentIndex index == \(currentIndex)")
                                                
                                                if currentIndex - 2 == i1 - 2{
                                                    
                                                    print("Last index == \(currentIndex - 2)")
                                                    
                                                    self.dataObj.onScroll = true
                                                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
                                                       
                                                        for index in 0...10{
                                                                                                       
                                                                                                       let position : Int = i1  + index
                                                                                                       
                                                                                                       
                                                                                                       guard let newObj = self.dataObj.newsFeeds?[position] else{
                                                                                                           return
                                                                                                           
                                                                                                       }
                                                                                                       
                                                                                                       self.dataObj.onScrollnewsFeeds.append(newObj)
                                                                                                   }

                                                        
                                                        
                                                        self.dataObj.onScroll = false
                                                    })
                                                    
                                                    
                                                }
                                            }
                                           
                                            
                                            
                                            if i1 - 2 == dataObj.onScrollnewsFeeds.count - 2{
                                                
                                                print("index == \(i1 - 2)")
                                            }
                                            
                                            
                                            
                                            
                                            
                                        }

                                       
                                       
                                       /* if let lastId = dataObj.vendorBillsList.last?.id{
                                            
                                            if lastId == obj.id{
                                                
                                                dataObj.pageIndex = dataObj.pageIndex + 1
                                                
                                                print("dataObj.pageIndex  \(dataObj.pageIndex)")
                                                
                                                dataObj.getAllVendorBillsByVendorCode(vendorCode: dataObj.selectedVendorCode)
                                            }
                                            
                                        }*/
                                        
                                    }
                                }
                            }
                        }
                    }
                }
                    
                if dataObj.onScroll{
                    
                    VStack{
                        
                        CircularActivityIndicatory().frame(width: 40,height: 40).opacity(dataObj.onScroll ? 0.9:0.0)
                    }
                }
            }
            else{
                if dataObj.showAlertMsg{
                    VStack{
                        Spacer()
                        Text(dataObj.alertMessage).padding()
                        Spacer()
                    }
                    
                }
            }
           
            
           // }
        Spacer()
        }
        .onAppear(){
            
            if dataObj.isNewsActive{
                dataObj.fetchNewsFeed()
            }else{
                dataObj.fetchStockMarket()
            }
           
        }
        
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct CircularActivityIndicatory: View {

    @State var spinCircle = false

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.5, to: 1)
                .stroke(Color.red, lineWidth:4)
                .frame(width:60)
                .rotationEffect(.degrees(spinCircle ? 0 : -360), anchor: .center)
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
        }
        .onAppear {
            self.spinCircle = true
        }
    }
}


