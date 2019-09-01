import Foundation
import NaturalLanguage

let schemes: [NLTagScheme] = [.language, .lemma, .lexicalClass, .nameType]
let tagger = NLTagger(tagSchemes: schemes)
let options: NLTagger.Options = [.joinNames, .omitWhitespace]

func extractPoS(text: String) {
  tagger.string = text
  let range = text.startIndex..<text.endIndex
  tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass,
                       options: [.joinNames, .omitWhitespace]) { (tag, range) -> Bool in
                        if let tag = tag?.rawValue {
                          print("\(text[range]) -> \(tag)")
                        }
                        return true
  }
}

// http://famouspoetsandpoems.com/poets/r__s__thomas/poems/11308
let quote = """
Pressure on me: You are Welsh, they said;
"""

extractPoS(text: quote)
