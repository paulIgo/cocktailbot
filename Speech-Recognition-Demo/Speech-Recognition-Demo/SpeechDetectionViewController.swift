import UIKit
import Speech

//https://medium.com/ios-os-x-development/speech-recognition-with-swift-in-ios-10-50d5f4e59c48
//Adapted Source Tutorial: https://github.com/jen2/Speech-Recognition-Demo

class SpeechDetectionViewController: UIViewController, SFSpeechRecognizerDelegate {

    @IBOutlet weak var detectedTextLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var textHolder: UILabel!
    @IBOutlet weak var inputString: UITextField!
    @IBOutlet weak var SubmitWritten: UIButton!
    
    
    
    var masterTextList:[String] = [];
    
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var isRecording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestSpeechAuthorization()
        self.startButton.isEnabled = false
    }
    
    
    //MARK: IBActions and Cancel
    @IBAction func startButtonTapped(_ sender: UIButton) {
        textHolder.text = ""
        
        if isRecording == true {
            cancelRecording()
            isRecording = false
            startButton.backgroundColor = UIColor.gray
        } else {
            masterTextList = []
            self.recordAndRecognizeSpeech()
            isRecording = true
            startButton.backgroundColor = UIColor.red
        }
    }
    
    func cancelRecording() {
        recognitionTask?.finish()
        recognitionTask = nil
        
        // stop audio
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        showPossibleDrinks()
    }
    
    func showPossibleDrinks(){
        textHolder.text = ""
        if(masterTextList.contains("vodka") && masterTextList.contains("lime")) {
            textHolder.text = textHolder.text! + "VODKA + LIME "
        }
        if(masterTextList.contains("tequila") && masterTextList.contains("lime")) {
            textHolder.text = textHolder.text! + "Tequila + LIME "
        }
        if(masterTextList.contains("rum") && masterTextList.contains("coke")) {
            textHolder.text = textHolder.text! + "rum + coke "
        }
        if(masterTextList.contains("tequila") && masterTextList.contains("sprite")) {
            textHolder.text = textHolder.text! + "tequila + Sprite "
        }
        if(masterTextList.contains("red bull") && masterTextList.contains("vodka")) {
            textHolder.text = textHolder.text! + "VODKA + redbull "
        }
        if(masterTextList.contains("peppermint") && masterTextList.contains("lime")) {
            textHolder.text = textHolder.text! + "peppermint + LIME "
        }
        
        
    }
    
//MARK: - Recognize Speech
    func recordAndRecognizeSpeech() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            self.sendAlert(title: "Speech Recognizer Error", message: "There has been an audio engine error.")
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
            self.sendAlert(title: "Speech Recognizer Error", message: "Speech recognition is not supported for your current locale.")
            return
        }
        if !myRecognizer.isAvailable {
            self.sendAlert(title: "Speech Recognizer Error", message: "Speech recognition is not currently available. Check back at a later time.")
            // Recognizer is not available right now
            return
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                
                let bestString = result.bestTranscription.formattedString
                var lastString: String = ""
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = String(bestString[indexTo...])
                }
                print(lastString)
                self.checkWord(lastString: lastString)

            } else if let error = error {
                self.sendAlert(title: "Speech Recognizer Error", message: "There has been a speech recognition error.")
                print(error)
            }
        })
    }
    
    func checkWord(lastString: String) {
        //String Type would
        var lowerLastString = lastString.lowercased()
            if(!masterTextList.contains(lowerLastString)) {
                masterTextList.append(lowerLastString)
                self.textHolder.text = self.textHolder.text! + masterTextList.last! + " "
            }
        
        
    }
    
//MARK: - Check Authorization Status
func requestSpeechAuthorization() {
    SFSpeechRecognizer.requestAuthorization { authStatus in
        OperationQueue.main.addOperation {
            switch authStatus {
            case .authorized:
                self.startButton.isEnabled = true
            case .denied:
                self.startButton.isEnabled = false
                self.detectedTextLabel.text = "User denied access to speech recognition"
            case .restricted:
                self.startButton.isEnabled = false
                self.detectedTextLabel.text = "Speech recognition restricted on this device"
            case .notDetermined:
                self.startButton.isEnabled = false
                self.detectedTextLabel.text = "Speech recognition not yet authorized"
            @unknown default:
                return
            }
        }
    }
}

    
//MARK: - Alert
    func sendAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
