/*
* Qulynym
* BeineViewController.swift
*
* Created by: Metah on 10/20/19
*
* Copyright © 2019 Automatization X Software. All rights reserved.
*/

import UIKit
import YoutubePlayer_in_WKWebView


protocol BeineViewControllerProtocol: class {
    var beineler: [Beine]! { get set }
    var token: String? { get set }
    var playlistID: String? { get set }
    var index: Int! { get set }
}

#warning("refactor")
class BeineViewController: UIViewController, BeineViewControllerProtocol, DataFetchAPIDelegate {
    // MARK:- Properties
    var dataFetchAPI: DataFetchAPI!
    var beineler: [Beine]!
    var token: String?
    var index: Int!
    
    var playlistID: String?
    var isPassingSafe = false
    
    private let playVarsDic = ["controls": 1, "playsinline": 1, "showinfo": 1, "autoplay": 0, "rel": 0]
    private lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "close"), for: .normal)
        btn.setupShadow()
        return btn
    }()
    private lazy var videoView: WKYTPlayerView = {
        let view = WKYTPlayerView()
        view.delegate = self
        view.clipsToBounds = false
        return view
    }()
    private lazy var recommendationsCV: UICollectionView = {
        return configureImagesCollectionView(scroll: .horizontal, image: nil, background: nil)
    }()
    private lazy var nextVideoBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "nextVideo"), for: .normal)
        return btn
    }()
    private lazy var previousVideoBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "previousVideo"), for: .normal)
        return btn
    }()
    
    
    // MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(videoView)
        view.addSubview(closeBtn)
        view.addSubview(recommendationsCV)
        view.addSubview(nextVideoBtn)
        view.addSubview(previousVideoBtn)
        setupCV()
        setAutoresizingFalse()
        activateConstraints()
        closeBtn.configureCloseBtnFrame(view)
        closeBtn.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        nextVideoBtn.addTarget(self, action: #selector(nextVideo), for: .touchUpInside)
        previousVideoBtn.addTarget(self, action: #selector(previousVideo), for: .touchUpInside)
        
        dataFetchAPI = DataFetchAPI(delegate: self)
        dataFetchAPI.beineler = self.beineler
        dataFetchAPI.token = self.token
        
        view.backgroundColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if index == 0 {
            previousVideoBtn.isEnabled = false
        }
        if index == dataFetchAPI.beineler.count - 1{
            nextVideoBtn.isEnabled = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoView.load(withVideoId: dataFetchAPI.beineler[index].id, playerVars: playVarsDic)
        AudioPlayer.backgroundAudioPlayer.pause()
        
        #warning("the last cell is also selected somehow")
        let indexPath = IndexPath(item: index, section: 0)
        recommendationsCV.scrollToItem(at: indexPath, at: .left, animated: true)
        makeCellSelected(recommendationsCV.cellForItem(at: IndexPath(item: index, section: 0))!)
    }
    
    
    // MARK:- Layout
    func makeCellSelected(_ cell: UICollectionViewCell) {
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 5
    }
    
    func makeCellDeselected(_ cell: UICollectionViewCell) {
        cell.layer.borderColor = nil
        cell.layer.borderWidth = 0
    }
    
    private func setupCV() {
        recommendationsCV.delegate = self
        recommendationsCV.dataSource = self
    }
    
    private func setAutoresizingFalse() {
        for subview in view.subviews {
            subview.translatesAutoresizingMaskIntoConstraints = false 
        }
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            videoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.65),
            videoView.topAnchor.constraint(equalTo: view.topAnchor),
            videoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            videoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nextVideoBtn.leadingAnchor.constraint(equalTo: videoView.trailingAnchor, constant: 16),
            nextVideoBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.05),
            nextVideoBtn.heightAnchor.constraint(equalTo: nextVideoBtn.widthAnchor),
            nextVideoBtn.centerYAnchor.constraint(equalTo: videoView.centerYAnchor),
            
            previousVideoBtn.trailingAnchor.constraint(equalTo: videoView.leadingAnchor, constant: -16),
            previousVideoBtn.widthAnchor.constraint(equalTo: nextVideoBtn.widthAnchor),
            previousVideoBtn.heightAnchor.constraint(equalTo: previousVideoBtn.widthAnchor),
            previousVideoBtn.centerYAnchor.constraint(equalTo: nextVideoBtn.centerYAnchor),
            
            recommendationsCV.topAnchor.constraint(equalTo: videoView.bottomAnchor, constant: 12),
            recommendationsCV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recommendationsCV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recommendationsCV.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    
    // MARK:- Actions
    @objc
    private func closeView() {
        self.navigationController!.popViewController(animated: true)
        if AudioPlayer.backgroundAudioStatePlaying == true {
            AudioPlayer.backgroundAudioPlayer.play()
        }
    }
    
    #warning("refactor these 2 methods")
    @objc
    private func nextVideo() {
        makeCellDeselected(recommendationsCV.cellForItem(at: IndexPath(item: self.index, section: 0))!)
        index += 1
        videoView.load(withVideoId: dataFetchAPI.beineler[index].id, playerVars: playVarsDic)
        recommendationsCV.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: true)
        makeCellSelected(recommendationsCV.cellForItem(at: IndexPath(item: index, section: 0))!)
    }
    
    @objc
    private func previousVideo() {
        makeCellDeselected(recommendationsCV.cellForItem(at: IndexPath(item: self.index, section: 0))!)
        index -= 1
        videoView.load(withVideoId: dataFetchAPI.beineler[index].id, playerVars: playVarsDic)
        recommendationsCV.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: true)
        makeCellSelected(recommendationsCV.cellForItem(at: IndexPath(item: index, section: 0))!)
    }
}

extension BeineViewController {
    // MARK:- DataFetchAPIDelegate Methods
    func dataReceived() {
        recommendationsCV.reloadData()
    }
}


extension BeineViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataFetchAPI.beineler.count == 0 ? 20 : dataFetchAPI.beineler.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseID", for: indexPath) as! ImageCollectionViewCell
        
        cell.backgroundColor = .gray
        cell.textSize = view.frame.height * 0.1
        cell.layer.cornerRadius = 15
        cell.imageViewCornerRadius = 15
        
        cell.isUserInteractionEnabled = false
        cell.backgroundColor = .gray
        if self.dataFetchAPI.beineler.count != 0 {
            cell.isUserInteractionEnabled = true
            cell.text = self.dataFetchAPI.beineler[indexPath.row].title
            
            let configuration = URLSessionConfiguration.default
            configuration.waitsForConnectivity = true
            let session = URLSession(configuration: configuration)

            let url = URL(string: self.dataFetchAPI.beineler[indexPath.row].thumbnailURL)!
            let task = session.dataTask(with: url) {(data, response, error) in
                guard let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {    return }
                
                guard let data = data else {
                    return
                }
                
                DispatchQueue.main.async {
                    cell.image = UIImage(data: data)
                }
            }
            task.resume()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: recommendationsCV.frame.width * 0.3, height: recommendationsCV.frame.height - 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        #warning("bug if deselected cell isn't visible")
        makeCellDeselected(collectionView.cellForItem(at: IndexPath(item: self.index, section: 0))!)
        if indexPath.row != index {
            videoView.load(withVideoId: dataFetchAPI.beineler[indexPath.row].id, playerVars: playVarsDic)
            recommendationsCV.scrollToItem(at: indexPath, at: .left, animated: true)
            makeCellSelected(collectionView.cellForItem(at: indexPath)!)
            index = indexPath.row
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        #warning("test that")
        guard dataFetchAPI.token != nil else { return }
        
         if (indexPath.row == dataFetchAPI.beineler.count - 1 ) {
            self.dataFetchAPI.fetchBeine()
         }
    }
}


extension BeineViewController: WKYTPlayerViewDelegate {
    func playerViewPreferredWebViewBackgroundColor(_ playerView: WKYTPlayerView) -> UIColor {
        return .clear
    }
}
