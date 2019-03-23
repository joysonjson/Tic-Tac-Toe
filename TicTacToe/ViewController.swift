//
//  ViewController.swift
//  TicTacToe
//
//  Created by Cumulations on 12/03/19.
//  Copyright © 2019 Cumulations. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    var count = 9
    var player = UserDefaults.standard.set(true, forKey: "player1")
    let winningCombinations = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
    var arrayOfPlayer1=[Int]()
    var arrayOfPlayer2=[Int]()
    
    
    @IBOutlet weak var blueColorLabel: UILabel!
    @IBOutlet weak var redColorLabel: UILabel!
    @IBOutlet weak var buttonOutlet: UIButton!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBAction func newGameButton(_ sender: UIButton) {
    // reset all user data and reload collection view
       count=9
        UserDefaults.standard.set(true, forKey: "player1")
        arrayOfPlayer1.removeAll()
        arrayOfPlayer2.removeAll()
        myCollectionView.reloadData()
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        redColorLabel.text = nil
//        blueColorLabel.text = nil
        self.myCollectionView.isScrollEnabled = false;

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.backgroundColor = .blue
        let newCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
        newCell.cellImageView.image = UIImage(named: "")
        newCell.backgroundColor = .cyan
        return newCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = myCollectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
        if cell.cellImageView.image == nil {
            if UserDefaults.standard.bool(forKey: "player1") == true{
             //   cell.cellImageView.image = UIImage(named: "Cross")
                UIView.transition(with: cell.cellImageView,
                                  duration: 0.75,
                                  options: .transitionCrossDissolve,
                                  animations: { cell.cellImageView.image = UIImage(named: "Cross")},
                                  completion: nil)
                count = count-1
                arrayOfPlayer1.append(indexPath.row)
                let (status,wonArray,wonPlayerName) = checkIfWon(matchingArray: arrayOfPlayer1)
                if status == true{
                    for cellIn in wonArray{
                        let myIndexPath:IndexPath = IndexPath(row: cellIn, section: 0)
                        let cell = myCollectionView.cellForItem(at: myIndexPath) as! MyCollectionViewCell
                        cell.backgroundColor = .green

                     //   cell.cellImageView.image=UIImage(named: "selected")

                        
                    }
                    winningAlert(winner: wonPlayerName)
                    

                }
                collectionView.backgroundColor = .red
                UserDefaults.standard.set(false, forKey: "player1")

            }else{
              //  cell.cellImageView.image = UIImage(named: "Nought")
                UIView.transition(with: cell.cellImageView,
                                  duration: 0.75,
                                  options: .transitionCrossDissolve,
                                  animations: { cell.cellImageView.image = UIImage(named: "Nought")},
                                  completion: nil)
                count = count-1
                arrayOfPlayer2.append(indexPath.row)
                checkIfWon(matchingArray: arrayOfPlayer2)
                let (status,wonArray,wonPlayerName) = checkIfWon(matchingArray: arrayOfPlayer2)
                if status == true{
                    for cellIn in wonArray{
                        print(cellIn)
                        let myIndexPath:IndexPath = IndexPath(row: cellIn, section: 0)
                        let cell = myCollectionView.cellForItem(at: myIndexPath) as! MyCollectionViewCell
                        cell.backgroundColor = .green

                       // cell.cellImageView.image=UIImage(named: "selected")
                        
                    }
                    winningAlert(winner: wonPlayerName)
                }
                collectionView.backgroundColor = .blue
                UserDefaults.standard.set(true, forKey: "player1")

            }
        }
        if count == 0{
            let alert = UIAlertController(title: "Draw", message: "click ok to restart.", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
 //           alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { UIAlertAction in
                self.buttonOutlet.sendActions(for: .touchUpInside)
            }))
            // show the alert
         //   self.present(alert,animated: true,completion: )
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    func winningAlert(winner:String){
        let alert = UIAlertController(title: winner, message: "has won, Congratulations.click ok to restart.", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { UIAlertAction in
            self.buttonOutlet.sendActions(for: .touchUpInside)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func checkIfWon(matchingArray: [Int])->(Bool,[Int],String){
        if matchingArray.count>=3{
            for smallArray in winningCombinations{
                let playerSet = Set(matchingArray)
                let winningSet = Set(smallArray)
                
                if winningSet.isSubset(of: playerSet) == true{
                        var wonPlayer:String
                        if UserDefaults.standard.bool(forKey: "player1") == true{
                            wonPlayer = "player1"
                            return (true,smallArray.sorted(),"player1")

                        }else{
                            wonPlayer = "player2"
                            return (true,smallArray.sorted(),"player2")
                            
                        }
                }
            }
        }
        return (false,[],"none")
        
    }
    

   


}
extension ViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionNumber = collectionView.bounds.width
        return CGSize(width: collectionNumber/3-2, height: collectionNumber/3-2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}
