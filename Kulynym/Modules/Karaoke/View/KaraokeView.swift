/*
* Kulynym
* KaraokeView.swift
*
* Created by: Metah on 5/30/19
*
* Copyright © 2019 Automatization X Software. All rights reserved.
*/

import UIKit
import AVKit

protocol KaraokeViewProtocol: class {
    var contentLabel: UILabel { get set }
    var nextBtn: UIButton { get set }
    var backBtn: UIButton { get set }
    var videoView: UIView { get set }
    var closeBtn: UIButton { get set }
    
    func setupLayout()
    func initLayer(_ player: AVPlayer?)
    func removeLayer()
}

class KaraokeView: KaraokeViewProtocol {
    // MARK:- Properties
    weak var view: UIView!
    
    lazy var contentLabel: UILabel = {
        let lbl = UILabel()
        lbl.setupContentLabel(size: view.frame.height * 0.1)
        return lbl
    }()
    lazy var videoView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 5
        v.layer.borderColor = UIColor.black.cgColor
        v.layer.borderWidth = 5
        return v
    }()
    lazy var nextBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "nextVideoBtn"), for: .normal)
        return btn
    }()
    lazy var backBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "backVideoBtn"), for: .normal)
        return btn
    }()
    lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "close"), for: .normal)
        return btn
    }()
    private lazy var gramophoneImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "gramophone")
        return iv
    }()
    private lazy var microImage: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "microphone"))
        return iv
    }()
    private lazy var background: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "playlistBg"))
        iv.layer.zPosition = -1
        return iv
    }()
    
    private var noteClipView: UIView!
    private var noteView: NoteView!
    
    // MARK:- Initialization
    required init(_ view: UIView) {
        self.view = view
    }
    
    
    // MARK:- Layout
    func setupLayout() {
        addSubviews()
        setSubviewsMask()
        closeBtn.configureCloseBtnFrame(view)
        background.configureBackgroundImagePosition(view)
//        initNoteView()
        activateConstraints()
    }
    
    
    private func addSubviews() {
        view.addSubview(contentLabel)
        view.addSubview(gramophoneImage)
        view.addSubview(closeBtn)
        view.addSubview(nextBtn)
        view.addSubview(backBtn)
        view.addSubview(videoView)
        view.addSubview(microImage)
        view.addSubview(background)
    }
    
    private func setSubviewsMask() {
        for subview in view.subviews {
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func activateConstraints() {
        let constant = view.frame.height * 0.25 + 56
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            contentLabel.leadingAnchor.constraint(equalTo: closeBtn.trailingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(constant)),
            
            gramophoneImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gramophoneImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            gramophoneImage.widthAnchor.constraint(equalTo: closeBtn.heightAnchor, constant: 40),
            gramophoneImage.heightAnchor.constraint(equalTo: closeBtn.heightAnchor, constant: 40),
            
            microImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            microImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            microImage.widthAnchor.constraint(equalTo: gramophoneImage.widthAnchor),
            microImage.heightAnchor.constraint(equalTo: gramophoneImage.heightAnchor),
            
            videoView.leadingAnchor.constraint(equalTo: microImage.trailingAnchor, constant: 20),
            videoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            videoView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: view.frame.height * 0.05),
            videoView.trailingAnchor.constraint(equalTo: gramophoneImage.leadingAnchor, constant: -20),
            
            backBtn.centerYAnchor.constraint(equalTo: videoView.centerYAnchor),
            backBtn.trailingAnchor.constraint(equalTo: videoView.leadingAnchor),
            backBtn.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            backBtn.heightAnchor.constraint(equalTo: backBtn.widthAnchor),
            
            nextBtn.centerYAnchor.constraint(equalTo: videoView.centerYAnchor),
            nextBtn.leadingAnchor.constraint(equalTo: videoView.trailingAnchor),
            nextBtn.widthAnchor.constraint(equalTo: backBtn.widthAnchor),
            nextBtn.heightAnchor.constraint(equalTo: backBtn.heightAnchor)
        ])
    }
    
    
    // MARK:- Layer
    func initLayer(_ player: AVPlayer?) {
        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        layer.frame = videoView.bounds
        layer.videoGravity = .resizeAspectFill
        
        videoView.layer.addSublayer(layer)
    }
    
    func removeLayer() {
        guard let sublayers = videoView.layer.sublayers else { return }
        sublayers[0].removeFromSuperlayer()
    }
    
    
    // MARK:- Animation
    private func initNoteView() {
        initFrames()
        noteClipView.addSubview(noteView)
        view.addSubview(noteClipView)
    }
    
    private func initFrames() {
        let frameHeight = view.frame.height
        let frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y + frameHeight * 0.25, width: view.frame.width, height: frameHeight)
    
        noteClipView = UIView(frame: frame)
        noteClipView.clipsToBounds = false
        noteView = NoteView(frame: frame)
    }
}
