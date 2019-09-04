import Foundation
import NaturalLanguage

let schemes: [NLTagScheme] = [.language, .lemma, .lexicalClass, .nameType]
let tagger = NLTagger(tagSchemes: schemes)
let options: NLTagger.Options = [.joinNames, .omitWhitespace]

func lemmatization(for text: String) {
  tagger.string = text
  let range = text.startIndex..<text.endIndex
  tagger.enumerateTags(in: range, unit: .word, scheme: .lemma,
                       options: options) { (tag, range) -> Bool in
                        if let lemma = tag?.rawValue {
                          print("\(text[range]) -> \(lemma)")
                        }
                        return true
  }
}

// http://famouspoetsandpoems.com/poets/roald_dahl/poems/7799
let quote = """
 Silver coins were minted at Aberystwyth Castle.
"""

lemmatization(for: quote)
