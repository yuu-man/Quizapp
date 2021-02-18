//
//  QuizViewController.swift
//  QuizuApp
//
//  Created by 佐々木悠 on 2021/02/15.
//

import UIKit

class QuizViewController: UIViewController {
    @IBOutlet weak var quizNumberLabel: UILabel!
    @IBOutlet weak var quizTextView: UITextView!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerBotton2: UIButton!
    @IBOutlet weak var answerBotton3: UIButton!
    @IBOutlet weak var answerBotton4: UIButton!
    @IBOutlet weak var judgeImageView: UIImageView!
    
    var csvArray: [String] = []
    var quizArray: [String] = []
    var quizCount = 0
    var correctCount = 0
    var selectlebel = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("選択したのはレベル\(selectlebel)")
        
        csvArray = loadCSV(fileName: "quiz\(selectlebel)")
        csvArray.shuffle()
        print(csvArray)
        
        quizArray = csvArray[quizCount].components(separatedBy: ",")
        
        quizNumberLabel.text = "第\(quizCount + 1)問"
        quizTextView.text = quizArray[0]
        answerButton1.setTitle(quizArray[2], for: .normal)
        answerBotton2.setTitle(quizArray[3], for: .normal)
        answerBotton3.setTitle(quizArray[4], for: .normal)
        answerBotton4.setTitle(quizArray[5], for: .normal)
        
        answerButton1.layer.borderWidth = 2
        answerButton1.layer.borderColor = UIColor.black.cgColor
        answerBotton2.layer.borderWidth = 2
        answerBotton2.layer.borderColor = UIColor.black.cgColor
        answerBotton3.layer.borderWidth = 2
        answerBotton3.layer.borderColor = UIColor.black.cgColor
        answerBotton4.layer.borderWidth = 2
        answerBotton4.layer.borderColor = UIColor.black.cgColor
        
        
        

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let scoreVC = segue.destination as! ScoreViewController
        scoreVC.correct = correctCount
    }
    
    @IBAction func btmAction(sender: UIButton){
        if sender.tag == Int(quizArray[1]){
            print("正解")
            correctCount += 1
            judgeImageView.image = UIImage(named: "correct")
        } else {
            print("不正解")
            judgeImageView.image = UIImage(named: "incorrect")
        }
        print("スコア:\(correctCount)")
        judgeImageView.isHidden = false
        answerButton1.isEnabled = false
        answerBotton2.isEnabled = false
        answerBotton3.isEnabled = false
        answerBotton4.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.judgeImageView.isHidden = true
            self.answerButton1.isEnabled = true
            self.answerBotton2.isEnabled = true
            self.answerBotton3.isEnabled = true
            self.answerBotton4.isEnabled = true
            self.nextQuiz()
        }
    }
    
    func nextQuiz() {
        quizCount += 1
        if quizCount < csvArray.count {
            quizArray = csvArray[quizCount].components(separatedBy: ",")
            quizNumberLabel.text = "第\(quizCount + 1)問"
            quizTextView.text = quizArray[0]
            answerButton1.setTitle(quizArray[2], for: .normal)
            answerBotton2.setTitle(quizArray[3], for: .normal)
            answerBotton3.setTitle(quizArray[4], for: .normal)
            answerBotton4.setTitle(quizArray[5], for: .normal)
        } else {
            performSegue(withIdentifier: "toScoreVC", sender: nil)
        }
    }
    func loadCSV(fileName: String) -> [String] {
        let csvBundle = Bundle.main.path(forResource: fileName, ofType: "csv")!
        do {
            let csvData = try String(contentsOfFile: csvBundle, encoding: String.Encoding.utf8)
            let lineChange = csvData.replacingOccurrences(of: "\r", with: "\n")
            csvArray = lineChange.components(separatedBy: "\n")
            csvArray.removeLast()
        }catch {
            print("エラー")
        }
        return csvArray
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
