//
//  ViewController.swift
//  Basic Space Marvel Database
//
//  Created by Dominick Hera on 9/20/23.
//

import UIKit

class MainListViewController: UIViewController
{
    
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    private let apiCallManager = APICallManager(networkManager: NetworkManager())
    private let imageCaching = ImageCaching(networkManager: NetworkManager())
    private var selectedHero: Character?
    lazy var heroArray = [Character]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
        let listNib = UINib(nibName: "CharacterListCollectionViewCell", bundle: nil)
        listCollectionView.register(listNib, forCellWithReuseIdentifier: "CharacterListCollectionViewCell")
        guard let layout = listCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let itemWidth = ( UIScreen.main.bounds.width / 3) - 1
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        getNextHeroPage()
    }
    
    func getNextHeroPage()
    {
        apiCallManager.getHeroList(pageCount: heroArray.count)
        {
            heroList, error in
            
            if let heroList = heroList
            {
                DispatchQueue.main.async
                {
                    self.listCollectionView?.performBatchUpdates(
                    {
                       
                        for hero in heroList
                        {
                            let indexPath = IndexPath(row: self.heroArray.count, section: 0)
                            self.heroArray.append( hero) //add your object to data source first
                            self.listCollectionView?.insertItems(at: [indexPath])
                        }
                    }, completion: nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "didSelectCell"
        {
            if let segueDestination = segue.destination as? ProfileDetailViewController
            {
                segueDestination.apiCallManager = apiCallManager
                segueDestination.characterModel = selectedHero
                segueDestination.imageCaching = imageCaching
            }
        }
    }
}

//MARK: UICollectionViewDelegate

extension MainListViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.selectedHero = heroArray[indexPath.item]
        performSegue(withIdentifier: "didSelectCell", sender: self)
    }
}

//MARK: UICollectionViewDataSource

extension MainListViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return heroArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterListCollectionViewCell", for: indexPath) as! CharacterListCollectionViewCell
        let hero = heroArray[indexPath.item]
        
        cell.heroNameLabel.text = hero.name
        imageCaching.getImage(path: hero.thumbnail.path, imageExtension: hero.thumbnail.thumbnailExtension)
        {
            [weak cell] image in
            
            guard let cell = cell, let image = image else { return }
            
            DispatchQueue.main.async
            {
                cell.activityIndicator.isHidden = true
                cell.heroImageView.image = image
            }
        }
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        if indexPath.item == (heroArray.count - 20)
        {
            self.getNextHeroPage()
        }
    }
    
}

