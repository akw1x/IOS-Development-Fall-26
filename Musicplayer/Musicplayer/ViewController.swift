//
//  ViewController.swift
//  Musicplayer
//
//  Created by Адель Кикбай on 28.10.2026.
//

import UIKit
import AVFoundation

// MARK: - Models
struct Track {
    let title: String
    let artist: String
    let fileName: String
    let coverImageName: String
}

struct TrackLibrary {
    static let tracks: [Track] = [
        Track(title: "Август это ты", artist: "МОТ", fileName: "song1", coverImageName: "cover1"),
        Track(title: "Ты и Я", artist: "Xcho", fileName: "song2", coverImageName: "cover2"),
        Track(title: "Асылым", artist: "Айқын Төлепберген", fileName: "song3", coverImageName: "cover3"),
        Track(title: "APT.", artist: "ROSÉ & Bruno Mars", fileName: "song4", coverImageName: "cover4"),
        Track(title: "Attention", artist: "NewJeans", fileName: "song5", coverImageName: "cover5"),
        Track(title: "Kobelek", artist: "Yenlik", fileName: "song6", coverImageName: "cover6"),
        Track(title: "basqany", artist: "Dequine", fileName: "song7", coverImageName: "cover7"),
        Track(title: "kozder", artist: "Miras Zhugunusov", fileName: "song8", coverImageName: "cover8"),
        Track(title: "Tokta", artist: "Abzal Uteshev", fileName: "song9", coverImageName: "cover9"),
        Track(title: "Unaidy Magan", artist: "Ерке Есмахан", fileName: "song10", coverImageName: "cover10")
    ]
}

// MARK: - View Controller
class ViewController: UIViewController, AVAudioPlayerDelegate {

    // MARK: - Outlets
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!
    @IBOutlet private weak var playPauseButton: UIButton!
    
    // MARK: - Properties
    private var player: AVAudioPlayer?
    private var currentIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTrack()
    }

    // MARK: - Private Methods
    private func loadTrack() {
        let currentTrack = TrackLibrary.tracks[currentIndex]
        
        titleLabel.text = currentTrack.title
        artistLabel.text = currentTrack.artist
        coverImageView.image = UIImage(named: currentTrack.coverImageName)

        guard let url = Bundle.main.url(forResource: currentTrack.fileName, withExtension: "mp3") else {
            print("Ошибка: файл \(currentTrack.fileName).mp3 не найден")
            return
        }

        player = try? AVAudioPlayer(contentsOf: url)
        player?.delegate = self
        player?.prepareToPlay()
    }

    private func play() {
        player?.play()
        playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }

    private func pause() {
        player?.pause()
        playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }

    // MARK: - Actions
    @IBAction private func playPauseTapped(_ sender: UIButton) {
        guard let player = player else { return }
        
        if player.isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    @IBAction private func nextTapped(_ sender: UIButton) {
        let wasPlaying = player?.isPlaying ?? false

        if currentIndex < TrackLibrary.tracks.count - 1 {
            currentIndex += 1
        } else {
            currentIndex = 0
        }

        loadTrack()

        if wasPlaying {
            play()
        }
    }
    
    @IBAction private func previousTapped(_ sender: UIButton) {
        let wasPlaying = player?.isPlaying ?? false

        if currentIndex > 0 {
            currentIndex -= 1
        } else {
            currentIndex = TrackLibrary.tracks.count - 1
        }

        loadTrack()

        if wasPlaying {
            play()
        }
    }
    // MARK: - AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if currentIndex < TrackLibrary.tracks.count - 1 {
            currentIndex += 1
        } else {
            currentIndex = 0
        }
        
        loadTrack()
        play()
    }
}

