//
//  ViewController.swift
//  collectionview-movie
//
//  Created by Burak Kubat on 23.02.2023.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    @IBOutlet weak var movieCollection: UICollectionView!
    var result = [Result]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getData()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        movieCollection.setCollectionViewLayout(layout, animated: true)
    }
    func getData() {
        var movies: Movies?
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=fba90e6e75a3cfff5d0986d5aa77fc9f&language=tr-TR") else {return}
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data , error == nil else {
                print("error")
                return
            }
            movies = try! JSONDecoder().decode(Movies.self, from: data)
            self.result = movies!.results
            
            DispatchQueue.main.async {
                self.movieCollection.reloadData()
            }
        }.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = movieCollection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieViewCell
        cell.movieTitle.text = result[indexPath.row].title
        cell.movieImage.downloaded(from: result[indexPath.row].poster_path)
        cell.movieImage.layer.cornerRadius = 20
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            let gridLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let widthPerItem = collectionView.frame.width / 2 - gridLayout.minimumInteritemSpacing
            return CGSize(width:widthPerItem, height:300)
        
        
        //let size = (movieCollection.frame.size.width - 10) / 2
        //let size1 = (movieCollection.frame.size.height / 2.5)
        //return CGSize(width: size, height: size1)
    }


}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(link)") else { return }
        downloaded(from: url, contentMode: mode)
    }
}


