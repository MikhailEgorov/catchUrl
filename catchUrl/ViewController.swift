//
//  ViewController.swift
//  catchUrl
//
//  Created by Егоров Михаил on 30.08.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var answerLabel: UILabel!
    @IBOutlet var imageGifView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var btnGoAnsweView: UIButton!
    
    let url: String = "https://yesno.wtf/api"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        answerLabel.isHidden = true
        btnGoAnsweView.layer.cornerRadius = 10
        btnGoAnsweView.layer.borderWidth = 1
        btnGoAnsweView.layer.borderColor = UIColor.blue.cgColor
        btnGoAnsweView.setTitle("What do you think ?", for: .normal)
    }

    @IBAction func buttonGoAnswer() {
        
        setView()
        
        guard let url = URL(string: url) else {return}
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "no error description")
                return
            }
            do {
                let answer = try JSONDecoder().decode(Answer.self, from: data)
                guard let urlImage = answer.image else {return}
                guard let urlSay = answer.answer else {return}
                self.fetchGif(with: urlImage, and: urlSay)
                print(answer)
            }
            catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    private func setView() {
        btnGoAnsweView.layer.borderWidth = 0
        btnGoAnsweView.isEnabled = false
        btnGoAnsweView.setTitle("Well, i think is ... ", for: .normal)
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        activityIndicator.hidesWhenStopped = true
    }
    
    private func fetchGif(with answer: String, and urlSay: String) {
        DispatchQueue.global().async {
            guard let url = URL(string: answer ) else {return}
            guard let imageData = try? Data(contentsOf: url) else {return}
            DispatchQueue.main.async {
                self.imageGifView.image = UIImage.gifImageWithData(imageData)
                self.answerLabel.text = urlSay.uppercased()
                self.changeBackground()
                self.answerLabel.isHidden = false
                self.activityIndicator.stopAnimating()
                self.btnGoAnsweView.setTitle("What do you think ?", for: .normal)
                self.btnGoAnsweView.isEnabled = true
                self.btnGoAnsweView.layer.borderWidth = 1
            }
        }
    }
    
    private func changeBackground() {
            if self.answerLabel.text == "YES" {
                self.view.backgroundColor = .green
            } else {
                self.view.backgroundColor = .red
            }
    }
}

