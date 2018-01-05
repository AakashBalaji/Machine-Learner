/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    The primary view controller. The speach-to-text engine is managed an configured here.
*/

import UIKit
import Speech
import Intents

public class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    // MARK: Properties
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    @IBOutlet var textView : UITextView!
    
    @IBOutlet var recordButton : UIButton!
    
    // MARK: UIViewController
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        
        
        
        
        
        INPreferences.requestSiriAuthorization { (status) in
            
        }
        
        /*var nameArray = arrayFromContentsOfFileWithName(fileName: "names.txt");
        INVocabulary.shared().setVocabularyStrings(nameArray, of: .contactName);
         */
    INVocabulary.shared().setVocabularyStrings([ "Chakravarthy", "Thirupati Panyala", "Shanmukesh", "Rakesh", "Bhuvneshwar", "Parmeshwar", "Adway", "Srikanth", "Narayana Ramani", "Padmanaban", "Bhargava", "Jugeshwar", "Gajini", "Ramanathan", "Pulimanithan", "Rishabh Tewari", "Rishabh Raju", "Shashishekhar", "shwathi", "Sri Priya Jain", "Banu", "Vishnupriya Nair", "Priyanshi Banerjee", "Sumitra Ragavendran", "Tanmay Bhakshi", "Tejas Srini","Abhishek Nandnan", "ShanmugaPayan", "Aadithyaa Nathamuni", "KrisnaSenthil", "Jhanvi Iyer", "Gomrapudi Natrajan", "Sharan Durbha", "Mahesh Hamsi", "Monishwaran", "Vigneshwaran Srinivasan", "Amarnath Vaid", "Arvind Shetty", "Vinod Kumar","Mukund Sharma", "Mukhul Varma", "Devanandhi Nayak", "Nehal Dayanand", "Fauzaan Ahaad", "Nikhil Burle", "Suhas Anil", "Aarti Ajit", "Sahana Ramprasad","Harsh Kulkarni", "Pranav Tedimedi", "Gurunath Iyappan", "Praveen Moksha", "Preeti Ashok", "Roja Kajol", "Sneha Rathore", "Snigdha Shetty", "Salmaan Harambe", "abhijeet Kumble", "aishwarya Priyesh", "Arihant Mukerjee", "Keshav Rana", "Lakshmi Rana", "Laxmi Rani", "Tanya", "Divya", "Rathore","Riksha","Jiksha","Ramkesh","GaneshRam","Athul Dube","Brindha","Brindhaa","Nandini Chandrakesha", "Suraj","Dinakar", "Abhinav", "Abhikesh","Keshava","Ajesh", "Bharadvaj","Simon Malik","Aryan","Anubhav","Jayaditya","Santhish Kumar","Dina","Lokesh Bavana", "Rohith Pamidi", "Parvathi", "Meena","Meenu","Handara Node", "Gayatri","Gayathri","Evan Puri", "Ananya", "Esha","Isha","Varsha", "Siva","Shiva"], of: .contactName)
       
    
    
    
        // Disable the record buttons until authorization has been granted.
        recordButton.isEnabled = false
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            /*
                The callback may not be called on the main thread. Add an
                operation to the main queue to update the record button's state.
            */
            OperationQueue.main.addOperation {
                switch authStatus {
                    case .authorized:
                        self.recordButton.isEnabled = true

                    case .denied:
                        self.recordButton.isEnabled = false
                        self.recordButton.setTitle("User denied access to speech recognition", for: .disabled)

                    case .restricted:
                        self.recordButton.isEnabled = false
                        self.recordButton.setTitle("Speech recognition restricted on this device", for: .disabled)

                    case .notDetermined:
                        self.recordButton.isEnabled = false
                        self.recordButton.setTitle("Speech recognition not yet authorized", for: .disabled)
                }
            }
        }
    }
    
    private func startRecording() throws {

        // Cancel the previous task if it's running.
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        
        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = true
        
        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                self.textView.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordButton.isEnabled = true
                self.recordButton.setTitle("Start Recording", for: [])
                
                
                
                
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        try audioEngine.start()
        
        textView.text = "(Go ahead, I'm listening)"
        
        
        
    }
    
    /*func arrayFromContentsOfFileWithName(fileName: String) -> [String]? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "txt") else {
            return nil
        }
        
        do {
            let content = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
            return content.components(separatedBy: "\n");
        } catch _ as NSError {
            return nil
        }
    }
 */
    // MARK: SFSpeechRecognizerDelegate
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton.isEnabled = true
            recordButton.setTitle("Start Recording", for: [])
        } else {
            recordButton.isEnabled = false
            recordButton.setTitle("Recognition not available", for: .disabled)
        }
    }
    
    // MARK: Interface Builder actions
    
    @IBAction func recordButtonTapped() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
            recordButton.setTitle("Stopping", for: .disabled)
        } else {
            try! startRecording()
            recordButton.setTitle("Stop recording", for: [])
        }
        
        
    }
}

