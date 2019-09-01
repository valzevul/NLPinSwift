import Foundation
import NaturalLanguage

let schemes: [NLTagScheme] = [.language, .lemma, .lexicalClass, .nameType]
let tagger = NLTagger(tagSchemes: schemes)
let options: NLTagger.Options = [.joinNames, .omitWhitespace]

func dominantLanguage(for text: String) {
  tagger.string = text
  if let languageName = tagger.dominantLanguage?.rawValue {
    print(languageName)
  }
}

let quote = """
Добро пожаловать в Великобританию.
"""

dominantLanguage(for: quote)
