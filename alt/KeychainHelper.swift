//
//  KeychainHelper.swift
//  alt
//
//  Created by Andrew Brandt on 2/4/15.
//  Copyright (c) 2015 dorystudios. All rights reserved.
//

import UIKit
import Security

let serviceIdentifier = "com.dorystudios.alt"

let kSecClassValue = kSecClass as NSString
let kSecAttrAccountValue = kSecAttrAccount as NSString
let kSecValueDataValue = kSecValueData as NSString
let kSecClassGenericPasswordValue = kSecClassGenericPassword as NSString
let kSecAttrServiceValue = kSecAttrService as NSString
let kSecMatchLimitValue = kSecMatchLimit as NSString
let kSecReturnDataValue = kSecReturnData as NSString
let kSecMatchLimitOneValue = kSecMatchLimitOne as NSString

class KeychainHelper: NSObject {
    
    class func setKeyboardAvailable(keyboardName: String) {
        self.setKeychainValue("Available", forKey:keyboardName)
    }
    
    class func getAvailableKeyboards() -> Set<String> {
        let path = NSBundle.mainBundle().bundlePath + "/Keyboards.plist"
        var pListData = NSArray(contentsOfFile: path)
        var keyboardData = pListData as! [Dictionary<String,String>]
        
        var result: Set<String> = Set<String>()
        
        for var i = 0; i < keyboardData.count; i++ {
            var keyboardString = keyboardData[i]["Name"] as String!
            if let keychainValue = self.keychainValueForKey(keyboardString) as String? {
                NSLog("key: %@ value: %@", keyboardString, keychainValue)
                result.insert(keyboardString)
            } else if keyboardString == "AZERTY" {
                NSLog("first time setup, enable free keyboard")
                self.setKeyboardAvailable(keyboardString)
                result.insert(keyboardString)
            } else {
               // NSLog("couldn't find value for key: %@", keyboardString)
            }
        }
        
        return result
    }
    
    class func setKeychainValue(value: String, forKey key: String) {
        var data = value.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        
        var query: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, serviceIdentifier, key, data], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
        
        //SecItemDelete(query as CFDictionaryRef)
        
        if key != "" {
            var status = SecItemAdd(query as CFDictionaryRef, nil) as OSStatus
            
            switch status {
            case errSecSuccess:
                NSLog("keychain added without error")
                break;
            case errSecParam:
                #if DEBUG
                NSLog("a parameter is missing from query")
                #endif
                break;
            case errSecAuthFailed, errSecInteractionNotAllowed:
                #if DEBUG
                NSLog("some security error happened")
                #endif
                break;
            case errSecDuplicateItem:
                NSLog("the item already exists")
                break;
            default:
                #if DEBUG
                NSLog("something unexpected happened!")
                #endif
                break;
            }
        }
    }
    
    class func keychainValueForKey(key: String) -> String? {
        
        //build query for keychain lookup
        var query: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, serviceIdentifier, key, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        
        var typeRef: Unmanaged<AnyObject>?
        
        //search keychain
        var keychainResponse: AnyObject?
        var result: String?
        
        var status = withUnsafeMutablePointer(&keychainResponse) { SecItemCopyMatching(query as CFDictionaryRef, UnsafeMutablePointer($0)) }
        
        switch status {
        case errSecSuccess:
            NSLog("value found")
            if let data = keychainResponse as! NSData? {
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    result = string as String
                }
            }
            break;
        case errSecItemNotFound:
            NSLog("key %@ not found", key)
            break;
        case errSecAuthFailed, errSecInteractionNotAllowed:
            #if DEBUG
            NSLog("some security error happened")
            #endif
            break;
        default:
            #if DEBUG
            NSLog("something unexpected happened!")
            #endif
            break;
        }
        
        return result
    }
}