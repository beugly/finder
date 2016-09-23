//
//  TestUtils.swift
//  X_Framework
//
//  Created by xifanGame on 15/9/17.
//  Copyright © 2015年 yeah. All rights reserved.
//

import Foundation


class TestUtils {
    fileprivate static var _bundle:Bundle?;
    
    fileprivate static var bundle:Bundle{
        if let b = _bundle
        {
            return b;
        }
        _bundle = Bundle(for: self);
        return _bundle!;
    }
    
    static func loadLocalData(_ fileName:String, _ ofType:String, _ success:(Data?) -> ())
    {
        let p = self.bundle.path(forResource: fileName, ofType: ofType);
        
        do{
            let data = try Data(contentsOf: URL(fileURLWithPath: p!), options: Data.ReadingOptions.uncached);
            success(data);
        }
        catch {
            print("loadLocalData error file:\(fileName).\(ofType)");
        }
    }
    
    class func loadDataFromURL(_ url: URL, completion:@escaping (_ data: Data?, _ error: NSError?) -> Void) {
        let session = URLSession.shared
        
        // Use NSURLSession to get data from an NSURL
        let loadDataTask = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: NSError?) -> Void in
            if let responseError = error {
                completion(nil, responseError)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    let statusError = NSError(domain:"com.raywenderlich", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(nil, statusError)
                } else {
                    completion(data, nil)
                }
            }
        } as! (Data?, URLResponse?, Error?) -> Void)
        
        loadDataTask.resume()
    }
}
