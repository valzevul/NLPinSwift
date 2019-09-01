import Foundation
import NaturalLanguage

let schemes: [NLTagScheme] = [.language, .lemma, .lexicalClass, .nameType]
let tagger = NLTagger(tagSchemes: schemes)
let options: NLTagger.Options = [.joinNames, .omitWhitespace]

// https://en.wikipedia.org/wiki/Aberystwyth#Main_features_of_the_town
let article = "Aberystwyth is a university town and tourist destination, and forms a cultural link between North Wales and South Wales. Constitution Hill, scaled by the Aberystwyth Cliff Railway, gives access to panoramic views and to other attractions at the summit, including a camera obscura. Scenic Mid Wales landscape within easy reach of the town includes the wilderness of the Cambrian Mountains, whose valleys contain forests and meadows which have changed little in centuries. A convenient way to access the interior is by the preserved narrow-gauge Vale of Rheidol Railway. \nAlthough the town is relatively modern, there are a number of historic buildings, including the remains of the castle and the Old College of Aberystwyth University nearby. The Old College was originally built and opened in 1865 as a hotel, but after the owner's bankruptcy the shell of the building was sold to the university in 1867.[13] \n The new university campus overlooks Aberystwyth from Penglais Hill to the east of the town centre. The station, a terminus of the main railway, was built in 1924 in the typical style of the period, mainly in a mix of Gothic, Classical Revival, and Victorian architecture. \nThe town is the unofficial capital of Mid Wales, and several institutions have regional or national offices there. Public bodies located in the town include the National Library of Wales, which incorporates the National Screen and Sound Archive of Wales, one of six British regional film archives. The Royal Commission on the Ancient and Historical Monuments of Wales maintains and curates the National Monuments Record of Wales (NMRW), providing the public with information about the built heritage of Wales. Aberystwyth is also the home to the national offices of UCAC and Cymdeithas yr Iaith Gymraeg (Welsh Language Society), and the site of the Institute of Grassland and Environmental Research. The Welsh Books Council and the offices of the standard historical dictionary of Welsh, Geiriadur Prifysgol Cymru, are also located in the town."

let stopwords = ["a", "", "share", "linkthese", "about", "above", "after", "again", "against", "all", "am", "an", "and", "any","are","aren't","as","at","be","because","been","before","being","below","between","both","but","by","can't","cannot","could","couldn't","did","didn't","do","does","doesn't","doing","don't","down","during","each","few","for","from","further","had","hadn't","has","hasn't","have","haven't","having","he","he'd","he'll","he's","her","here","here's","hers","herself","him","himself","his","how","how's","i","i'd","i'll","i'm","i've","if","in","into","is","isn't","it","it's","its","itself","let's","me","more","most","mustn't","my","myself","no","nor","not","of","off","on","once","only","or","other","ought","our","ours","ourselves","out","over","own","same","shan't","she","she'd","she'll","she's","should","shouldn't","so","some","such","than","that","that's","the","their","theirs","them","themselves","then","there","there's","these","they","they'd","they'll","they're","they've","this","those","through","to","too","under","until","up","very","was","wasn't","we","we'd","we'll","we're","we've","were","weren't","what","what's","when","when's","where","where's","which","while","who","who's","whom","why","why's","with","won't","would","wouldn't","you","you'd","you'll","you're","you've","your","yours","yourself","yourselves", "this"]

// From previous lessons
func tokenize(text: String, for unit: NLTokenUnit) -> [String] {
  let tokenizer = NLTokenizer(unit: unit)
  tokenizer.string = text
  var tokensArray = [String]()
  let range = text.startIndex..<text.endIndex
  for token in tokenizer.tokens(for: range) {
    tokensArray.append(String(text[token]))
  }
  return tokensArray
}

// New code
func uniqueWords(words: [String]) -> [String] {
  return Array(Set(words))
}

func prettify(article: String) -> [String] {
  return tokenize(text: article, for: .word).filter { str -> Bool in
    !stopwords.contains(str) && str.count > 2
  }
}

func countWords(words: [String]) -> [String: Double] {
  var results = [String: Double]()
  let uniqueW = uniqueWords(words: words)
  for word in words {
    if uniqueW.contains(word) {
      results[word] = (results[word] ?? 0) + 1
    }
  }
  return results
}

let allWords = prettify(article: article.lowercased())
let allSentences = tokenize(text: article, for: .sentence)
let allUniqueWords = uniqueWords(words: allWords)
var allUniqueWordsFrequency = countWords(words: allWords)

func countForSentences(sentences: [String], values: [String: Double]) -> [String: Double] {
  var sentenceFrequences = [String: Double]()
  for sentence in sentences {
    var sum = 0.0
    let sentenceWords = prettify(article: sentence.lowercased())
    for word in sentenceWords {
      sum += (values[word.lowercased()] ?? 0)
    }
    sentenceFrequences[sentence] = sum / Double(sentenceWords.count)
  }
  return sentenceFrequences
}

func termFrequency() -> [String: Double] {
  var currentFrequency = [String: Double]()
  for word in allUniqueWordsFrequency.keys {
    currentFrequency[word] = (allUniqueWordsFrequency[word] ?? 0.0) / Double(allWords.count)
  }
  return countForSentences(sentences: allSentences,
                           values: currentFrequency)
}

func inverseDocumentFrequence() -> [String: Double] {
  var inverseFrequency = [String: Double]()
  for word in allUniqueWordsFrequency.keys {
    inverseFrequency[word] = log10(Double(allSentences.count) / (allUniqueWordsFrequency[word] ?? 0.0))
  }
  return countForSentences(sentences: allSentences,
                           values: inverseFrequency)
}

func TFIDF() -> [String: Double] {
  let tf = termFrequency()
  let idf = inverseDocumentFrequence()
  var tfidf = [String: Double]()
  for word in tf.keys {
    guard let tf = tf[word], let idf = idf[word] else { continue }
    tfidf[word] = tf * idf
  }
  return tfidf
}

let sortedResults = TFIDF().sorted { (lhr, rhr) -> Bool in
  return lhr.value > rhr.value
}

print(sortedResults[0])
print(sortedResults[1])
print(sortedResults[2])


// (key: "Aberystwyth is a university town and tourist destination, and forms a cultural link between North Wales and South Wales. ", value: 0.014382807375465158)
// (key: "The town is the unofficial capital of Mid Wales, and several institutions have regional or national offices there. ", value: 0.013139647594908592)
// (key: "The Royal Commission on the Ancient and Historical Monuments of Wales maintains and curates the National Monuments Record of Wales (NMRW), providing the public with information about the built heritage of Wales. ", value: 0.012642474277418311)


