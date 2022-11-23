//
//  ViewController.swift
//  GCD
//
//  Created by Alibek Kozhambekov on 24.11.2022.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let service = Service()
    
    private lazy var imageViews: [UIImageView] = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.contentMode = .scaleAspectFit
        return [view]
    }()
    
    private lazy var imageArray = [UIImage]()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: CGRect(x: 220, y: 220, width: 140, height: 140))
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 20
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        onLoad()
    }
    
    private func onLoad() {
        
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "com.alibek.async")
        
        for _ in 0...4 {
            
            dispatchGroup.enter()
            
            dispatchQueue.async {
                self.service.getImageURL { urlString, error in
                    guard
                        let urlString = urlString
                    else {
                        return
                    }
                    let image = self.service.loadImage(urlString: urlString)
                    self.imageArray.append(image ?? UIImage())
                    dispatchGroup.leave()
                }
            }
        }
            
            dispatchGroup.notify(queue: DispatchQueue.main) {
                [weak self] in
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()
                self.stackView.removeArrangedSubview(self.activityIndicator)
                for i in 0...4 {
                    self.imageViews.append(UIImageView())
                    self.imageViews[i].image = self.imageArray[i]
                    print(self.imageArray[i])
                    print(self.imageViews[i])
                    self.stackView.addArrangedSubview(self.imageViews[i])
                }
            }
    }
        
    private func setupViews() {
        view.backgroundColor = .green
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.left.right.equalToSuperview()
        }
        stackView.addArrangedSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
}


