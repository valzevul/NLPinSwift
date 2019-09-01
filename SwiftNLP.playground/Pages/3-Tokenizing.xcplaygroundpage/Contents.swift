import Foundation
import NaturalLanguage

let schemes: [NLTagScheme] = [.language, .lemma, .lexicalClass, .nameType]
let tagger = NLTagger(tagSchemes: schemes)
let options: NLTagger.Options = [.joinNames, .omitWhitespace]

func tokenize(text: String, for unit: NLTokenUnit) {
  let tokenizer = NLTokenizer(unit: unit)
  tokenizer.string = text
  let tokens = tokenizer.tokens(for: text.startIndex..<text.endIndex)
  for token in tokens {
    print(text[token])
  }
}

// https://en.wikipedia.org/wiki/Aberystwyth#Literature
let quote = """
In Mr. Douglas Adams' dictionary of toponymic neologisms, an Aberystwyth (or A.B.E.R.Y.S.T.W.Y.T.H) is "A nostalgic yearning which is in itself more pleasant than the thing being yearned for".
"""

tokenize(text: quote, for: .word) // 32
tokenize(text: quote, for: .sentence) // 1
