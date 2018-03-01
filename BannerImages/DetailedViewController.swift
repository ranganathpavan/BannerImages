//
//  DetailedViewController.swift
//  BannerImages
//
//  Created by Janardhan on 01/03/18.
//  Copyright © 2018 RanganathPavan. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {

    var imagePath:String!
    @IBOutlet weak var fullImage:UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: imagePath)
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                self.fullImage.image = UIImage(data: data!)
            }
        }
        
//        fullImage.image = UIImage(named:imagePath)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
