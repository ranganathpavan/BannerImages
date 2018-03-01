//
//  ViewController.swift
//  BannerImages
//
//  Created by Janardhan on 28/02/18.
//  Copyright © 2018 RanganathPavan. All rights reserved.
//

import UIKit
import MMBannerLayout

class ViewController: UIViewController {

    var images = [String]()
    @IBOutlet weak var collection: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //commit
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.layoutIfNeeded()
        collection.showsHorizontalScrollIndicator = false
        if let layout = collection.collectionViewLayout as? MMBannerLayout {
            layout.itemSpace = 10
            layout.itemSize = self.collection.frame.insetBy(dx: 40, dy: 40).size
        }

        
        

        get_Images()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        (collection.collectionViewLayout as? MMBannerLayout)?.autoPlayStatus = .play(duration: 2.0)
    }
    
    func get_Images()
    {
        
        let url:URL = URL(string: Constants.IMAGES_API)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.timeoutInterval = 10
        
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (
            data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response, error == nil else {
                
                return
            }
            
            self.extract_json_data(data!)
            
        })
        
        task.resume()
        
    }
    
    func extract_json_data(_ data:Data)
    {
        let json: Any?
        
        do
        {
            json = try JSONSerialization.jsonObject(with: data, options: [])
            
        }
        catch
        {
            print("error")
            return
        }
        
        guard let images_array = json! as? NSArray else
        {
            print("error")
            return
        }
        
        for j in 0 ..< images_array.count
        {
            images.append(images_array[j] as! String)
        }
        
        DispatchQueue.main.async(execute: refresh)
    }
    
    func refresh()
    {
        print(images.count)
        self.collection.reloadData()
    }
    
//    func tap(sender: UITapGestureRecognizer){
//        
//        
//        if let indexPath = collection?.indexPathForItem(at: sender.location(in: collection)) {
//            let cell = self.collection?.cellForItem(at: indexPath)
//            print("you can do something with the cell or index path here")
//            (collection.collectionViewLayout as? MMBannerLayout)?.autoPlayStatus = .none
//
//        } else {
//            
//                    let detailViewObj = self.storyboard!.instantiateViewController(withIdentifier: "detailedVC") as! DetailedViewController
//                    detailViewObj.imagePath = images[indexPath]
//                    self.navigationController!.pushViewController(detailViewObj, animated: true)        }
//    }
//    
    
    
    func processDoubleTap (sender: UITapGestureRecognizer)
    {
        
        let point:CGPoint = sender.location(in: collection)
        let indelPath:NSIndexPath = collection.indexPathForItem(at: point)! as NSIndexPath
        print(indelPath)
        
        let detailViewObj = self.storyboard!.instantiateViewController(withIdentifier: "detailedVC") as! DetailedViewController
        detailViewObj.imagePath = images[indelPath.row]
        self.navigationController!.pushViewController(detailViewObj, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: BannerLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, focusAt indexPath: IndexPath) {
        print("Focus At \(indexPath)")
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell {
            //cell.imgView.image = images[indexPath.row]
            
            cell.imgView.image = nil
            //let url = URL(string: yourArray.objectAtIndex(indexPath.row))
            
            //let url = URL(string:self.jsonArr[row]["IMAGESKEY"].string!
            
            let url = URL(string: images[indexPath.row])
            let task = URLSession.shared.dataTask(with: url!, completionHandler: {(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void in
                if data != nil {
                    let image = UIImage(data: data!)
                    if image != nil {
                        DispatchQueue.main.async(execute: {() -> Void in
                            let updateCell = (collectionView.cellForItem(at: indexPath) as? Any) as? ImageCell
                            if updateCell != nil {
                                updateCell?.imgView.image = image
                            }
                        })
                    }
                }
            }) as? URLSessionTask
            task?.resume()
            return cell
        }
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        

        
//            print("You selected cell #\(indexPath)!")
//            print("You selected cell #\(images[indexPath.row])")
//        
        (collection.collectionViewLayout as? MMBannerLayout)?.autoPlayStatus = .none
//
//
//        let detailViewObj = self.storyboard!.instantiateViewController(withIdentifier: "detailedVC") as! DetailedViewController
//        detailViewObj.imagePath = images[indexPath.row]
//        self.navigationController!.pushViewController(detailViewObj, animated: true)
        let doubletapgesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(processDoubleTap))
        doubletapgesture.numberOfTapsRequired = 2
        collectionView.addGestureRecognizer(doubletapgesture)
        
    }

}


