//
//  Constant.swift
//  NewsAndStock
//
//  Created by PSH-LP-C02G37NYQ6L4 on 01/05/23.
//
import SystemConfiguration
import Foundation
import UIKit



//FontsConstants.swift
struct FontNames {

    static let LatoName = "Lato"
    struct Lato {
        static let LatoBold = "Lato-Bold"
        static let LatoMedium = "Lato-Medium"
        static let LatoRegular = "Lato-Regular"
        static let LatoExtraBold = "Lato-ExtraBold"
    }
}


//ColorConstants.swift
struct AppColor {

    private struct Alphas {
        static let Opaque = CGFloat(1)
        static let SemiOpaque = CGFloat(0.8)
        static let SemiTransparent = CGFloat(0.5)
        static let Transparent = CGFloat(0.3)
    }

    static let appPrimaryColor =  UIColor.white.withAlphaComponent(Alphas.SemiOpaque)
    static let appSecondaryColor =  UIColor.blue.withAlphaComponent(Alphas.Opaque)

    struct TextColors {
        static let Error = AppColor.appSecondaryColor
        static let Success = UIColor(red: 0.1303, green: 0.9915, blue: 0.0233, alpha: Alphas.Opaque)
    }

    struct TabBarColors{
        static let Selected = UIColor.white
        static let NotSelected = UIColor.black
    }

    struct OverlayColor {
        static let SemiTransparentBlack = UIColor.black.withAlphaComponent(Alphas.Transparent)
        static let SemiOpaque = UIColor.black.withAlphaComponent(Alphas.SemiOpaque)
        static let demoOverlay = UIColor.black.withAlphaComponent(0.6)
    }
}

//KeyConstants.swift
    struct Key {

        static let DeviceType = "iOS"
        struct Beacon{
            static let ONEXUUID = "xxxx-xxxx-xxxx-xxxx"
        }

        struct UserDefaults {
            static let k_App_Running_FirstTime = "userRunningAppFirstTime"
        }

        struct Headers {
            static let Authorization = "Authorization"
            static let ContentType = "Content-Type"
        }
        struct Google{
            static let placesKey = "some key here"//for photos
            static let serverKey = "some key here"
        }

        struct ErrorMessage{
            static let listNotFound = "ERROR_LIST_NOT_FOUND"
            static let validationError = "ERROR_VALIDATION"
        }
    }


let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
let SCREEN_MAX_LENGTH    = max(SCREEN_WIDTH,SCREEN_HEIGHT)
let SCREEN_MIN_LENGTH    = min(SCREEN_WIDTH,SCREEN_HEIGHT)

public class Reachability {

        class func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         return isReachable && !needsConnection
         */

        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret

    }
}
