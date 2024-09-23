
import UIKit
import Combine

final class ArticleDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: ArticleDetailViewModel
    private var cancellables = Set<AnyCancellable>()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .placeholder))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        return stackView
    }()

    private lazy var dateImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "calendar"))
        imageView.tintColor = .darkGray
        return imageView
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkText
        label.numberOfLines = 0
        return label
    }()

    private lazy var readMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle(Strings.Button.readMore, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(readMoreButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Initializers
    
    init(viewModel: ArticleDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupNavigationBar()
        setupConstraints()
        bindViewModel() // Bind the view model properties to UI updates
    }

    // MARK: - Selectors

    @objc private func readMoreButtonTapped() {
        if let articleURL = viewModel.article.url,
           let url = URL(string: articleURL) {
            UIApplication.shared.open(url)
        }
    }

    // MARK: - Private Functions
    
    private func setupViews() {
        view.backgroundColor = .white
        view.isOpaque = true

        view.addSubview(imageView)
        view.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
        stackView.addArrangedSubview(dateStackView)
        stackView.addArrangedSubview(descriptionLabel)
        dateStackView.addArrangedSubview(dateImageView)
        dateStackView.addArrangedSubview(dateLabel)
        view.addSubview(readMoreButton)

        stackView.setCustomSpacing(24, after: dateStackView)
    }
    
    private func setupNavigationBar() {
        title = Strings.Titles.articleDetails
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),

            readMoreButton.heightAnchor.constraint(equalToConstant: 44),
            readMoreButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            readMoreButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            readMoreButton.topAnchor.constraint(greaterThanOrEqualTo: stackView.bottomAnchor, constant: 16),
            readMoreButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    private func bindViewModel() {
        // Subscribe to changes in the article
        viewModel.$article
            .receive(on: DispatchQueue.main)
            .sink { [weak self] article in
                self?.populate(with: article)
            }
            .store(in: &cancellables)
    }

    private func populate(with article: Article) {
        Task { [weak self] in
            guard let self,
                  let imageURL = article.imageURL else {
                return
            }

            imageView.image = await ImageService.download(from: imageURL) ?? UIImage(resource: .placeholder)
        }

        titleLabel.text = article.title
        subTitleLabel.text = article.byline
        dateLabel.text = article.publishedDate
        descriptionLabel.text = article.abstract
    }
}
