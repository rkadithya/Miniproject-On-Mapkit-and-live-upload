import UIKit
import MapKit

class ViewController: UIViewController {
    private var videosTableView: UITableView = {
        let table = UITableView()
        table.register(VideoTableViewCell.self, forCellReuseIdentifier: "VideoTableViewCell")
        return table
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        return label
    }()
    
    private let aboutMeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        return label
    }()
    
    private let dobLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        return label
    }()
    
    private let uploadVideoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Upload", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let imagesScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let scrollMainView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let mapView = MKMapView()
    var uploadedVideos: [URL] = []
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Profile"
        
        setupUI()
        displayUserData()
        setupMap()
        
        if let user = user {
            self.aboutMeLabel.text = user.aboutMe
            self.dobLabel.text = user.dob
            self.nameLabel.text = "\(user.firstName) \(user.lastName)"
            self.setupImagesScrollView(with: user.profilePics)
        }
        
        videosTableView.delegate = self
        videosTableView.dataSource = self
        uploadVideoButton.addTarget(self, action: #selector(didTapUploadVideo), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.addSubview(scrollMainView)
        scrollMainView.addSubview(imagesScrollView)
        scrollMainView.addSubview(nameLabel)
        scrollMainView.addSubview(dobLabel)
        scrollMainView.addSubview(aboutMeLabel)
        scrollMainView.addSubview(mapView)
        scrollMainView.addSubview(uploadVideoButton)
        scrollMainView.addSubview(videosTableView)
        scrollMainView.isScrollEnabled = true
        scrollMainView.alwaysBounceVertical = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let padding: CGFloat = 16
        var currentY: CGFloat = padding
        scrollMainView.frame = view.bounds
        
        imagesScrollView.frame = CGRect(
            x: padding,
            y: currentY,
            width: view.frame.width - 2 * padding,
            height: 200
        )
        currentY += imagesScrollView.frame.height + padding
          
        nameLabel.frame = CGRect(
            x: padding,
            y: currentY,
            width: view.frame.width - 2 * padding,
            height: 30
        )
        currentY += nameLabel.frame.height + padding
        
        dobLabel.frame = CGRect(
            x: padding,
            y: currentY,
            width: view.frame.width - 2 * padding,
            height: 30
        )
        currentY += dobLabel.frame.height + padding
        
        aboutMeLabel.frame = CGRect(
            x: padding,
            y: currentY,
            width: view.frame.width - 2 * padding,
            height: 80
        )
        currentY += aboutMeLabel.frame.height + padding
        
        mapView.frame = CGRect(
            x: padding,
            y: currentY,
            width: view.frame.width - 2 * padding,
            height: 200
        )
        currentY += mapView.frame.height + padding
        
        uploadVideoButton.frame = CGRect(
            x: padding,
            y: currentY,
            width: view.frame.width - 2 * padding,
            height: 50
        )
        currentY += uploadVideoButton.frame.height + padding
        
        let tableHeight = CGFloat(uploadedVideos.count * 300)
        videosTableView.frame = CGRect(
            x: padding,
            y: currentY,
            width: view.frame.width - 2 * padding,
            height: tableHeight
        )
        
        currentY += tableHeight + padding
        scrollMainView.contentSize = CGSize(width: view.frame.width, height: currentY)
    }
    
    private func setupImagesScrollView(with images: [UIImage]) {
        imagesScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(images.count), height: 200)
        imagesScrollView.isPagingEnabled = true
        imagesScrollView.showsHorizontalScrollIndicator = false
        
        for (index, image) in images.enumerated() {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.frame = CGRect(x: CGFloat(index) * view.frame.width, y: 0, width: view.frame.width, height: 200)
            imagesScrollView.addSubview(imageView)
        }
    }
    
    private func displayUserData() {
        guard let user = user else { return }
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        dobLabel.text = "Date of Birth: \(user.dob)"
        aboutMeLabel.text = user.aboutMe.count > 300 ? String(user.aboutMe.prefix(300)) + "..." : user.aboutMe
    }
    
    private func setupMap() {
        guard let user = user else { return }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(user.pincode) { [weak self] placemarks, error in
            guard let self = self, let placemark = placemarks?.first, error == nil else { return }
            if let location = placemark.location {
                let annotation = MKPointAnnotation()
                annotation.coordinate = location.coordinate
                annotation.title = "My Location"
                self.mapView.addAnnotation(annotation)
                self.mapView.setRegion(MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500), animated: true)
            }
        }
    }
    
    @objc private func didTapUploadVideo() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.mediaTypes = ["public.movie"]
        picker.videoQuality = .typeHigh
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    private func handlePlaybackForVisibleCells() {
        for cell in videosTableView.visibleCells {
            if let videoCell = cell as? VideoTableViewCell {
                videoCell.player?.pause()
            }
        }
        
        if let topVisibleCell = videosTableView.visibleCells.first as? VideoTableViewCell {
            topVisibleCell.player?.play()
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let videoURL = info[.mediaURL] as? URL {
            uploadedVideos.append(videoURL)
            videosTableView.reloadData()
            viewDidLayoutSubviews()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uploadedVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell", for: indexPath) as? VideoTableViewCell else {
            return UITableViewCell()
        }
        
        let videoURL = uploadedVideos[indexPath.row]
        cell.configure(with: videoURL)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}
