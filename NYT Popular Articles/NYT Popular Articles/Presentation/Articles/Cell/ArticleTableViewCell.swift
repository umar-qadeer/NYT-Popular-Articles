
import UIKit

final class ArticleTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var articleImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .placeholder))
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()

    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkText
        return label
    }()

    private lazy var chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.tintColor = .darkGray
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .bold, scale: .large)
        let largeBoldChevron = UIImage(systemName: "chevron.right", withConfiguration: largeConfig)
        imageView.image = largeBoldChevron
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessibilityIdentifier = AccessibilityIdentifier.articleCellIdentifier

        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func prepareForReuse() {
        super.prepareForReuse()

        articleImageView.image = UIImage(resource: .placeholder)
        titleLabel.text = nil
        subTitleLabel.text = nil
    }

    // MARK: - Private Functions
    
    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(containerView)
        containerView.addSubview(articleImageView)
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
        containerView.addSubview(chevronImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),

            articleImageView.widthAnchor.constraint(equalToConstant: 50),
            articleImageView.heightAnchor.constraint(equalToConstant: 50),
            articleImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            articleImageView.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor, constant: 16),
            articleImageView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -16),
            articleImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            stackView.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -16),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            chevronImageView.widthAnchor.constraint(equalToConstant: 16),
            chevronImageView.heightAnchor.constraint(equalToConstant: 16),
            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    // MARK: - Configure

    func configure(article: Article) {
        Task { [weak self] in
            guard let self,
                  let thumbnailURL = article.thumbnailURL else {
                return
            }

            articleImageView.image = await ImageService.download(from: thumbnailURL) ?? UIImage(resource: .placeholder)
        }

        titleLabel.text = article.title
        subTitleLabel.text = article.byline
    }
}
