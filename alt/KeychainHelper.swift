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
        self.setKeychainValue(keyboardName, forKey:"Available")
    }
    
    class func getAvailableKeyboards() -> Dictionary<String,String> {
        let path = NSBundle.mainBundle().bundlePath + "/Keyboards.plist"
        var pListData = NSArray(contentsOfFile: path)
        var keyboardData = pListData as! [Dictionary<String,String>]
        
        var result: Dictionary = Dictionary<String, String>()
        
        for var i = 0; i < keyboardData.count; i++ {
            var keyboardString = keyboardData[i]["Name"] as String!
            if let keychainValue = self.keychainValueForKey(keyboardString) as String? {
                result.updateValue(keychainValue, forKey: keyboardString)
            }
        }
        
        return result
    }
    
    class func setKeychainValue(value: String, forKey key: String) {
        var data = key.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        
        var query: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, serviceIdentifier, key, data], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
        
        SecItemDelete(query as CFDictionaryRef)
        
        if key != "" {
            var status = SecItemAdd(query, nil)
        }
    }
    
    class func keychainValueForKey(key: String) -> String? {
        
        //build query for keychain lookup
        var query: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, serviceIdentifier, key, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        
        var typeRef: Unmanaged<AnyObject>?
        
        //search keychain
        var keychainResponse: AnyObject?
        var result: String?
        var status = withUnsafeMutablePointer(&keychainResponse) { SecItemCopyMatching(query, UnsafeMutablePointer($0)) }
        
        if status == errSecSuccess {
            if let data = keychainResponse as! NSData? {
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    result = string as! String
                }
            }
        }
        
        return result
        /*
        let status: OSStatus = SecItemCopyMatching(query, &typeRef)
        let opaque = typeRef?.toOpaque()

        if let o = opaque? {
            let retrievedData = Unmanaged<NSData>.fromOpaque(o).takeUnretainedValue()
            
            result = NSString(data: retrievedData, encoding: NSUTF8StringEncoding)
        } else {
            return nil
        }
        */
    }
}