# VocabSync (2017-Present)

What is VocabSync? 

VocabSync is a Speech-To-Text application that was developed to help Apple's Siri correctly spell out foreign names and names that are inaudible or long. Siri doesn't have the capability to understand any name or word that exists. Often, it gives the user problems, by repeating the word incorrectly or spelling it out wrong. Hence, VocabSync solves this issue and makes user interaction with Siri easy.

How it Works?

Custom Vocabulary Words are registered with Sirikit by invoking the INVocabulary method and setVocabularyStrings(_:of:) method. The list of names are stored in the AppIntentVocabulary.plist file.

Also, the global vocabulary file contains two keys at the root level:
1. The IntentPhrases key contains example phrases for invoking your services. Always include this key.
1. The ParameterVocabularies key defines your app’s custom terms that apply to all users of your app and the intent parameters to which they apply. You may omit this key if you do not have any custom vocabulary terms.

  1. Download clone project to Xcode
  1. Open project and perform any imports, if required.
  1. Run the app on iphone, go to Settings-->Siri-->App Support and manually toggle the app to enable siri for the app.
  1. Tell Siri a name, and it will spell it out correctly, by fetching it from the downloaded VocabSync app.

Unique Features: Users can use this application as a base for various other purposes, like: Calling and messaging a friend from a third party app, and just having a lively conversation with Siri!

Limitations: Currently Apple has put some limitations on third party users using these intents, so The .plist file can only store a limited number of names(1-1000), i.e, after 20 to 30 names, Siri fails to accuratley fetch the names and recognize them.

Resources: 
1. Apple Developer Documentation: https://developer.apple.com/documentation
