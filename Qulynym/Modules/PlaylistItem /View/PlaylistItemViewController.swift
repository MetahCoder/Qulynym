 /*
* Qulynym
* PlaylistItemViewController.swift
*
* Created by: Metah on 5/30/19
*
* Copyright © 2019 Automatization X Software. All rights reserved.
 */

import UIKit
import AVKit

protocol PlaylistItemViewControllerProtocol: class {
    var isKaraoke: Bool { get set }
    var contentName: String { get set }
    var lyricsText: String { get set }
    var index: Int { get set }
    var maxIndex: Int { get set }
    var isPlaying: Bool { get }
    
    func setViewsProperties()
    func setTimelineSliderMaxValue()
    func playBtnPressed()
    func setTimelineSliderValue(_ value: Int)
    func scrollTextView(to: Int)
}

class PlaylistItemViewController: UIViewController, PlaylistItemViewControllerProtocol {
    // MARK:- Properties
    var isKaraoke = true
    var contentName = ""
    var lyricsText = ""
    var index = 0
    var maxIndex = 0
    var isPlaying = false
    var isOpenSlider = true
    var presenter: PlaylistItemPresenterProtocol!
    
    private var scrolledToEnd = false
    private let configurator: PLaylistItemConfiguratorProtocol = PlaylistItemConfigurator()
    private var karaokeView: PlaylistItemViewProtocol!
    
    
    // MARK:- Status Bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    // MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        initLayout()
        karaokeView.setupLayout()
        assignActions()
        presenter.getLyricsText()
        presenter.getMaxCount()
        presenter.initTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playBtnPressed()
        setViewsProperties()
        AudioPlayer.backgroundAudioPlayer.stop()
    }
    
    
    // MARK:- Layout
    private func initLayout() {
        karaokeView = PlaylistItemView(self.view, isKaraoke)
    }
    
    // MARK:- Actions
    private func assignActions() {
        karaokeView.playBtn.addTarget(self, action: #selector(playBtnPressed), for: .touchUpInside)
        karaokeView.backBtn.addTarget(self, action: #selector(backBtnPressed), for: .touchUpInside)
        karaokeView.forwardBtn.addTarget(self, action: #selector(nextBtnPressed), for: .touchUpInside)
        karaokeView.closeBtn.addTarget(self, action: #selector(closeBtnPressed), for: .touchUpInside)
        karaokeView.timelineSlider.addTarget(self, action: #selector(timelineSliderValueChanged), for: .valueChanged)
        karaokeView.soundSlider.addTarget(self, action: #selector(soundSliderValueChanged), for: .valueChanged)
        karaokeView.soundButton.addTarget(self, action: #selector(soundBtnPressed), for: .touchUpInside)

        let timelineSliderTap = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(gestureRecognizer:)))
        let soundSliderTap = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(gestureRecognizer:)))
        karaokeView.timelineSlider.addGestureRecognizer(timelineSliderTap)
        karaokeView.soundSlider.addGestureRecognizer(soundSliderTap)
    }
    
    @objc
    func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.view == karaokeView.timelineSlider {
            #warning("test that")
            if gestureRecognizer.location(in: view).x < self.view.frame.height + karaokeView.timelineSlider.frame.minX {
                self.sliderTappedActions(karaokeView.timelineSlider, point: gestureRecognizer.location(in: view))
                self.timelineSliderValueChanged()
            }
        } else {
            sliderTappedActions(karaokeView.soundSlider, point: gestureRecognizer.location(in: view))
            soundSliderValueChanged()
        }
    }
    
    private func sliderTappedActions(_ slider: UISlider, point position: CGPoint) {
        let positionOfSlider: CGPoint = slider.frame.origin
        let widthOfSlider: CGFloat = slider.frame.size.width
        let newValue = ((position.x - positionOfSlider.x) * CGFloat(slider.maximumValue) / widthOfSlider)
        slider.value = Float(newValue)
    }
    
    @objc
    func playBtnPressed() {
        if isPlaying {
            presenter.pauseAudio()
            karaokeView.playBtn.setImage(UIImage(named: "playBtn"), for: .normal)
        } else {
            presenter.playAudio()
            karaokeView.playBtn.setImage(UIImage(named: "pauseBtn"), for: .normal)
        }
        isPlaying = !isPlaying
    }
    
    @objc
    private func backBtnPressed() {
        presenter.backToPreviousAudio()
    }
    
    @objc
    private func nextBtnPressed() {
        presenter.nextAudio()
    }
    
    @objc
    private func closeBtnPressed() {
        presenter.close()
    }
    
    @objc
    private func timelineSliderValueChanged() {
        if !isPlaying {
            playBtnPressed()
        }
        presenter.scrollAudio(to: karaokeView.timelineSlider.value)
    }
    
    @objc
    private func soundSliderValueChanged() {
        presenter.changeAudioVolume(to: karaokeView.soundSlider.value)
        
        changeSoundBtnImage(karaokeView.soundSlider.value)
    }
    
    private func changeSoundBtnImage(_ value: Float) {
        if value == 0.0 {
            karaokeView.soundButton.setImage(UIImage(named: "soundsIconOff"), for: .normal)
            isOpenSlider = false
        } else {
            karaokeView.soundButton.setImage(UIImage(named: "soundsIcon"), for: .normal)
            isOpenSlider = true
        }
    }
    
    @objc
    private func soundBtnPressed() {
        var value: Float
        
        if isOpenSlider {
            value = 0
        } else {
            value = 1
        }
        
        karaokeView.soundSlider.setValue(value, animated: true)
        presenter.changeAudioVolume(to: value)
        changeSoundBtnImage(value)
    }
}


extension PlaylistItemViewController {
    // MARK:- Protocol Methods
    func setViewsProperties() {
        karaokeView.titleLabel.text = contentName
        if isKaraoke {
            karaokeView.lyricsTextView.text = lyricsText
        } else {
            karaokeView.storyImageView.image = UIImage(named: contentName)
        }
        karaokeView.backBtn.isEnabled = (index != 0)
        karaokeView.forwardBtn.isEnabled = (index != maxIndex)
    }
    
    func scrollTextView(to: Int) {
        let range = NSMakeRange(to, 0)
        karaokeView.lyricsTextView.scrollRangeToVisible(range)
    }
    
    func setTimelineSliderMaxValue() {
        karaokeView.timelineSlider.maximumValue = Float(AudioPlayer.playlistItemAudioPlayer.duration)
    }
    
    func setTimelineSliderValue(_ value: Int) {
        karaokeView.timelineSlider.value = Float(value)
        
        if value == Int(presenter.duration) {
            presenter.timer.timerEnded()
            karaokeView.timelineSlider.value = 0 
            playBtnPressed()
        }
    }
}
