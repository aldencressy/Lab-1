import UIKit

class ImageZoomViewController: UIViewController, UIScrollViewDelegate {

    var imageView = UIImageView()
    var scrollView = UIScrollView()
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView = UIScrollView(frame: view.bounds)
        scrollView.delegate = self
        scrollView.maximumZoomScale = 6.0
        scrollView.minimumZoomScale = 1.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.bouncesZoom = false

        imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        scrollView.addSubview(imageView)
        view.addSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustImageViewForCurrentOrientation()
    }

    private func adjustImageViewForCurrentOrientation() {
        guard let image = image else { return }

        let scrollViewSize = scrollView.bounds.size

        let imageAspectRatio = image.size.width / image.size.height
        let scrollViewAspectRatio = scrollViewSize.width / scrollViewSize.height

        if imageAspectRatio > scrollViewAspectRatio {
            let width = scrollViewSize.width
            let height = width / imageAspectRatio
            imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        } else {
            let height = scrollViewSize.height
            let width = height * imageAspectRatio
            imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        }

        scrollView.contentSize = imageView.bounds.size

        let widthScale = scrollViewSize.width / imageView.bounds.width
        let heightScale = scrollViewSize.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)

        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale

        centerImageInScrollView()
    }

    private func centerImageInScrollView() {
        let horizontalInset = max(0, (scrollView.bounds.size.width - scrollView.contentSize.width) / 2)
        let verticalInset = max(0, (scrollView.bounds.size.height - scrollView.contentSize.height) / 2)

        scrollView.contentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { _ in
            self.adjustImageViewForCurrentOrientation()
        }, completion: nil)
    }
}
