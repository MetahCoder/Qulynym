/*
* Kulynym
* PlaylistViewController.swift
*
* Created by: Metah on 5/12/19
*
* Copyright © 2019 Automatization X Software. All rights reserved.
*/

import UIKit

protocol PlaylistViewControllerProtocol: class {
    var isKaraoke: Bool! { get set }
    var content: [String] { get set }
}

class PlaylistViewController: UIViewController, PlaylistViewControllerProtocol, MessageShowingVC {
    // MARK:- Properties
    var isKaraoke: Bool!
    var content = [String]()
    var presenter: PlaylistPresenterProtocol!
    weak var karaokeViewDelegate: KaraokeViewControllerProtocol!
    weak var storyViewDelegate: StoryViewControllerProtocol!
    
    var message: MessageManager!

    private weak var listCollectionView: UICollectionView!
    private weak var closeBtn: UIButton!
    private weak var titleLabel: UILabel!
    
    private var playlistView: PlaylistViewProtocol!
    private let configurator: PlaylistConfiguratorProtocol = PlaylistConfigurator()
    
    
    // MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        
        initLayout()
        playlistView.setupLayout()
        assignViews()
        setupCollectionView()
        setText()
        assignActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.getContent()
        initMessage()
        message.showAlert()
    }
    
    
    // MARK:- Layout
    private func initLayout() {
        playlistView = PlaylistView(view: self.view)
    }
    
    private func assignViews() {
        self.listCollectionView = playlistView.listCollectionView
        self.closeBtn = playlistView.closeBtn
        self.titleLabel = playlistView.titleLabel
    }
    
    
    // MARK:- ListTableView
    private func setupCollectionView() {
        self.listCollectionView.delegate = self
        self.listCollectionView.dataSource = self
    }
    
    private func setText() {
        titleLabel.text = isKaraoke ? "O'lender" : "Ertegiler"
    }
    
    func initMessage() {
        message = MessageManager(calling: self, showing: isKaraoke ? .karaoke : .stories)
    }
    
    
    // MARK:- Actions
    private func assignActions() {
        closeBtn.addTarget(self, action: #selector(closeBtnPressed), for: .touchUpInside)
    }
    
    @objc private func closeBtnPressed() {
        presenter.closeView()
    }
}

extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseID", for: indexPath) as! ImageCollectionViewCell
        cell.imageName = content[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.openItem(at: indexPath.row)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.3, height: view.frame.width * 0.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let distance = (view.frame.width - view.frame.width * 0.6) / 3
        return UIEdgeInsets(top: 40, left: distance, bottom: 40, right: distance)
    }
}


extension PlaylistViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Animator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Animator()
    }
}
