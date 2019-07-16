//
//  Home.swift
//  Cake Run
//
//  Created by Anessa Petteruti on 8/6/18.
//  Copyright © 2018 Anessa Petteruti. All rights reserved.
//

import UIKit
import AVFoundation

class Home: UIViewController {

    var audioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var play: UIButton!
    
    @IBOutlet weak var manStand: UIImageView!
    
    @IBOutlet weak var cakeIconHome: UIImageView!
    @IBOutlet weak var runLabel: UILabel!
    @IBOutlet weak var cakeLabel: UILabel!
    @IBOutlet weak var squiggly: UIImageView!
    
    var isPlaying = false
    
    @IBOutlet weak var speaker: UIButton!
    
//    @IBAction func unwindToHome(_sender: UIStoryboardSegue) {}
    
    @IBAction func speakerButton(_ sender: Any) {
        
        if isPlaying {
            speaker.setImage(UIImage(named: "audioOn.png"), for: .normal)
            audioPlayer.play()
            isPlaying = false
        }
        else {
            speaker.setImage(UIImage(named: "audioOff.png"), for: .normal)
            audioPlayer.stop()
            isPlaying = true
        }
    }
    var manImages: [UIImage] = []
    
    @IBAction func playButton(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToGame", sender: self)
        audioPlayer.stop()
        print("Button clicked")
    }
    
    func createImageArray(total: Int, imagePrefix: String) -> [UIImage] {
        
        var imageArray: [UIImage] = []
        
        for imageCount in 1...2 {
            let imageName = "gif-\(imageCount).png"
            let image = UIImage(named: imageName)!
            
            imageArray.append(image)
        }
        return imageArray
    }
    
    func animate(imageView: UIImageView, images: [UIImage]) {
        imageView.animationImages = images
        imageView.animationDuration = 1.0
        imageView.animationRepeatCount = -1
        imageView.startAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        manImages = createImageArray(total: 2, imagePrefix: "gif-")
        animate(imageView: manStand, images: manImages)
//        cakeIconHome.alpha = 0
//        runLabel.alpha = 0
//        cakeLabel.alpha = 0
//        squiggly.alpha = 0
        
        self.manStand.alpha = 5
        
        play.layer.shadowColor = UIColor.gray.cgColor
        play.layer.shadowOffset = CGSize(width: 5, height: 5)
        play.layer.shadowRadius = 5
        play.layer.shadowOpacity = 1.0
        
        let audioPath = Bundle.main.path(forResource: "cakeRunAudio", ofType: "mp3")

        do {
            try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
            audioPlayer.play()
            audioPlayer.numberOfLoops = -1
        }
        catch {
            print(error)
        }
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        UIView.animate(withDuration: 1, animations: {
//        }) { _ in
//            UIView.animate(withDuration: 1, delay: 0.25, options: [.autoreverse, .repeat], animations: {
//                self.play.frame.origin.y -= 10
//            })
//        }
        //self.cakeLabel.frame = CGRect(x: 6, y: 70, width: 0, height: 0)
        self.cakeLabel.frame.size.width += 0
        self.cakeLabel.frame.size.height += 5
        
        //self.runLabel.frame = CGRect(x: 6, y: 150, width: 0, height: 0)
        self.runLabel.frame.size.width += 0
        self.runLabel.frame.size.height += 5
        
        //self.cakeIconHome.frame = CGRect(x: 30, y: 150, width: 0, height: 0)
        self.cakeIconHome.frame.size.width += 0
        self.cakeIconHome.frame.size.height += 0
        
        UIView.animate(withDuration: 0.8, animations: {
            //self.cakeLabel.frame = CGRect(x: 6, y: 70, width: 550, height: 550)
            self.cakeLabel.frame.size.width += 0
            self.cakeLabel.frame.size.height += 30


            //self.runLabel.frame = CGRect(x: 6, y: 150, width: 550, height: 550)
            self.runLabel.frame.size.width += 0
            self.runLabel.frame.size.height += 30
            
            //self.cakeIconHome.frame = CGRect(x: 30, y: 150, width: 50, height: 50)
            self.cakeIconHome.frame.size.width += 0
            self.cakeIconHome.frame.size.height += 3
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
//
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
