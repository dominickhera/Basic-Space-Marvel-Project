//
//  ProfileDetailViewController.swift
//  Basic Space Marvel Database
//
//  Created by Dominick Hera on 9/20/23.
//

import UIKit

class ProfileDetailViewController: UIViewController
{
    //Hero Base Info
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var heroBaseInfoView: UIView!
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var heroDescriptionLabel: UILabel!
    
    //Comic Toggle Button
    @IBOutlet weak var comicToggleView: UIView!
    @IBOutlet weak var comicToggleImageView: UIImageView!
    @IBOutlet weak var comicToggleCountLabel: UILabel!
    
    //Movie Toggle Button
    @IBOutlet weak var movieToggleImageView: UIImageView!
    @IBOutlet weak var movieToggleCountLabel: UILabel!
    @IBOutlet weak var movieToggleView: UIView!
    
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    lazy var comicArray = [Content]()
    lazy var eventArray = [Content]()
    
    var apiCallManager: APICallManager?
    var characterModel: Character?
    var isComicSelected: Bool = true
    var imageCaching: ImageCaching?
    
    let selectedColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.00)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let listNib = UINib(nibName: "CharacterListCollectionViewCell", bundle: nil)
        profileCollectionView.register(listNib, forCellWithReuseIdentifier: "CharacterListCollectionViewCell")
        guard let layout = profileCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let itemWidth = ( UIScreen.main.bounds.width / 3) - 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.backBarButtonItem?.tintColor = .black
        setupBaseHeroView()
        setupToggleButtons()
        getNextContentPage(forContentType: .comics)
        getNextContentPage(forContentType: .events)
        // Do any additional setup after loading the view.
    }
    
    func getNextContentPage(forContentType heroContentType: contentType)
    {
        guard let hero = characterModel else { return }
        apiCallManager?.getContentList(pageCount: heroContentType == .comics ? comicArray.count : eventArray.count, hero: hero, contentType: heroContentType)
        {
            contentList, error in

            if let contentList = contentList
            {
                DispatchQueue.main.async
                {
                    if (self.isComicSelected)
                    {
                        if heroContentType == .comics
                        {
                            self.profileCollectionView?.performBatchUpdates(
                            {
                                for content in contentList
                                {
                                    let indexPath = IndexPath(row: self.comicArray.count, section: 0)
                                    self.comicArray.append(content)
                                    self.profileCollectionView?.insertItems(at: [indexPath])
                                }
                            }, completion: nil)
                        }
                        else
                        {
                            self.eventArray.append(contentsOf: contentList)
                        }
                    }
                    else
                    {
                        if heroContentType == .events
                        {
                            self.profileCollectionView?.performBatchUpdates(
                            {
                                for content in contentList
                                {
                                    let indexPath = IndexPath(row: self.eventArray.count, section: 0)
                                    self.eventArray.append(content)
                                    self.profileCollectionView?.insertItems(at: [indexPath])
                                }
                            }, completion: nil)
                        }
                        else
                        {
                            self.comicArray.append(contentsOf: contentList)
                        }
                    }
                }
            }
        }
    }
    
    func setupBaseHeroView()
    {
        if let hero = characterModel
        {
            heroNameLabel.text = hero.name
            imageCaching?.getImage(path: hero.thumbnail.path, imageExtension: hero.thumbnail.thumbnailExtension)
            {
                image in
                
                guard let image = image else { return }
                
                DispatchQueue.main.async
                {
                    self.heroImageView.image = image
                }
            }

            let nsString = hero.characterDescription as NSString
            if nsString.length >= 150
            {
                heroDescriptionLabel.text = nsString.substring(with: NSRange(location: 0, length: nsString.length > 150 ? 150 : nsString.length)) + "..."
            }
            
            heroImageView.layer.cornerRadius = heroImageView.frame.width / 2
            heroBaseInfoView.layer.cornerRadius = 10
            heroBaseInfoView.layer.shadowColor = UIColor.black.cgColor
            heroBaseInfoView.layer.shadowOpacity = 0.1
            heroBaseInfoView.layer.shadowOffset = .zero
            heroBaseInfoView.layer.shadowRadius = 10
        }
    }
    
    func setupToggleButtons()
    {
        comicToggleView.layer.cornerRadius = 15
        movieToggleView.layer.cornerRadius = 15
        
        if let hero = characterModel
        {
            comicToggleCountLabel.text = "\(hero.comics.available)"
            movieToggleCountLabel.text = "\(hero.events.available)"
        }
        
        comicToggleCountLabel.textColor = isComicSelected ? .black : .gray
        movieToggleCountLabel.textColor = isComicSelected ? .gray : .black
        
        movieToggleImageView.image = isComicSelected ? UIImage(systemName: "tv") : UIImage(systemName: "tv.fill")
        movieToggleImageView.tintColor = isComicSelected ? .gray : .black
        
        comicToggleImageView.image = isComicSelected ? UIImage(systemName: "book.fill") : UIImage(systemName: "book")
        comicToggleImageView.tintColor = isComicSelected ? .black : .gray
        
        comicToggleView.backgroundColor = isComicSelected ? selectedColor : .white
        movieToggleView.backgroundColor = isComicSelected ? .white : selectedColor
    }
    
    func toggleAction()
    {
        isComicSelected = !isComicSelected
        movieToggleImageView.image = isComicSelected ? UIImage(systemName: "tv") : UIImage(systemName: "tv.fill")
        comicToggleImageView.image = isComicSelected ? UIImage(systemName: "book.fill") : UIImage(systemName: "book")
        movieToggleImageView.tintColor = isComicSelected ? .gray : .black
        comicToggleImageView.tintColor = isComicSelected ? .black : .gray
        comicToggleCountLabel.textColor = isComicSelected ? .black : .gray
        movieToggleCountLabel.textColor = isComicSelected ? .gray : .black
        comicToggleView.backgroundColor = isComicSelected ? selectedColor : .white
        movieToggleView.backgroundColor = isComicSelected ? .white : selectedColor
        self.profileCollectionView.reloadData()
    }
    
    //MARK: Actions
    
    @IBAction func didTapMore(_ sender: Any) 
    {
        let alert = UIAlertController(title: "More", message: "For more information regarding \(characterModel?.name ?? "the character.")", preferredStyle: .actionSheet)
        guard let urls = characterModel?.urls else { return }
    
        for url in urls
        {
            if let title = urlType(rawValue: url.type)?.title
            {
                alert.addAction(UIAlertAction(title: title, style: .default , handler:{ (UIAlertAction)in
                    guard let url = URL(string: url.url) else { return }

                    if #available(iOS 10.0, *) 
                    {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } 
                    else
                    {
                        UIApplication.shared.openURL(url)
                    }
                }))
            }
        }
              
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))

        
        alert.popoverPresentationController?.sourceView = self.view

        self.present(alert, animated: true, completion: {
            print("complete")
        })
    }
    
    @IBAction func didTapComicButton(_ sender: Any)
    {
        if !isComicSelected
        {
            toggleAction()
        }
    }
    
    @IBAction func didTapMovieButton(_ sender: Any)
    {
        if isComicSelected
        {
            toggleAction()
        }
    }
}

//MARK: UICollectionViewDataSource
extension ProfileDetailViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return isComicSelected ? comicArray.count : eventArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterListCollectionViewCell", for: indexPath) as! CharacterListCollectionViewCell
        
        cell.textGradientBackground.isHidden = true
        cell.heroNameLabel.isHidden = true
        let data = isComicSelected ? comicArray[indexPath.item] : eventArray[indexPath.item]
        if let thumbnail = data.thumbnail
        {
            imageCaching?.getImage(path: thumbnail.path, imageExtension: thumbnail.thumbnailExtension)
            {
                [weak cell] image in
                
                guard let cell = cell, let image = image else { return }
                
                DispatchQueue.main.async
                {
                    cell.activityIndicator.isHidden = true
                    cell.heroImageView.image = image
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        let indexCount = (isComicSelected ? comicArray.count : eventArray.count)
        
        if indexPath.item == (indexCount - 10)
        {
            self.getNextContentPage(forContentType: isComicSelected ? .comics : .events)
        }
    }
}

//MARK: UICollectionViewDelegate
extension ProfileDetailViewController: UICollectionViewDelegate
{
    
}
