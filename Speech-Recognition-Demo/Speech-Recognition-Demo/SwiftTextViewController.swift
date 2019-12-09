import UIKit
import Speech

//https://medium.com/ios-os-x-development/speech-recognition-with-swift-in-ios-10-50d5f4e59c48
//Adapted Source Tutorial: https://github.com/jen2/Speech-Recognition-Demo

class SwiftTextViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var textHolder: UILabel!
    @IBOutlet weak var inputString: UITextField!
    @IBOutlet weak var SubmitWritten: UIButton!
    
    
    
    var masterTextList:[String] = [];
    
    override func viewDidLoad() {
        masterTextList = []
        super.viewDidLoad()
    }
    
    
    @IBAction func OnClickSubmit(_ sender: Any) {
        var text = inputString.text
        
        masterTextList = []
        masterTextList = (text?.components(separatedBy: ","))!
        
        //https://stackoverflow.com/questions/28548908/how-to-remove-whitespaces-in-strings-in-swift
        masterTextList = masterTextList.map { $0.trimmingCharacters(in: .whitespaces) }
        masterTextList = masterTextList.map { $0.lowercased()}
        showPossibleDrinks();
        
        
    }
    
    func showPossibleDrinks(){
        textHolder.text = ""
        if(masterTextList.contains("vodka") && masterTextList.contains("lime")) {
            textHolder.text = textHolder.text! + "Vodka Lime "
        }
        if(masterTextList.contains("tequila") && masterTextList.contains("lime")) {
            textHolder.text = textHolder.text! + "Tequila and Lime "
        }
        if(masterTextList.contains("rum") && masterTextList.contains("coke")) {
            textHolder.text = textHolder.text! + "Rum and Coke "
        }
        if(masterTextList.contains("tequila") && masterTextList.contains("sprite")) {
            textHolder.text = textHolder.text! + "Tequila and Sprite "
        }
        if(masterTextList.contains("red bull") && masterTextList.contains("vodka")) {
            textHolder.text = textHolder.text! + "Vodka Redbull "
        }
        if(masterTextList.contains("peppermint") && masterTextList.contains("vodka")) {
            textHolder.text = textHolder.text! + "Peppermint vodka "
        }
    }
    
   
}
