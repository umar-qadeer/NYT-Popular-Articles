
import UIKit
import Combine

protocol ArticlesViewControllerCoordinationDelegate: AnyObject {
    func showArticleDetail(article: Article)
}

final class ArticlesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties

    private weak var coordinator: ArticlesViewControllerCoordinationDelegate?
    private var viewModel: ArticlesViewModel
    private var cancellables = Set<AnyCancellable>()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame)
        tableView.backgroundColor = .systemGray6
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isOpaque = true
        tableView.clipsToBounds = true
        tableView.refreshControl = refreshControl
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerCell(class: ArticleTableViewCell.self)
        return tableView
    }()

    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .lightGray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: Strings.List.pullToRefresh)
        return refreshControl
    }()

    // MARK: - Initializers

    init(_ coordinator: ArticlesViewControllerCoordinationDelegate, viewModel: ArticlesViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupNavigationBar()
        setupConstraints()
        bindViewModel() // Bind the view model properties to UI updates

        viewModel.fetchArticles()
    }

    // MARK: - Private Functions

    private func setupUI() {
        view.backgroundColor = .white
        view.isOpaque = true

        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)

        view.addSubview(tableView)
        view.addSubview(activityIndicator)
    }

    private func setupNavigationBar() {
        title = Strings.Titles.articles
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func bindViewModel() {
        // Bind articles to reload table view
        viewModel.$articles
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
            .store(in: &cancellables)

        // Bind loading state to show/hide activity indicator
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)

        // Bind error to show alert
        viewModel.$error
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { error in
                AlertBuilder.failureAlertWithMessage(message: error.localizedDescription)
            }
            .store(in: &cancellables)
    }

    // MARK: - Selectors

    @objc private func didPullToRefresh() {
        viewModel.fetchArticles()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let article = viewModel.articles?[indexPath.row] else {
            return UITableViewCell()
        }

        let cell: ArticleTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(article: article)
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let article = viewModel.articles?[indexPath.row] else {
            return
        }

        coordinator?.showArticleDetail(article: article)
    }
}
