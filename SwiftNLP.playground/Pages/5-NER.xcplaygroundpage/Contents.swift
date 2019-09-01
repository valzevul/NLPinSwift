import Foundation
import NaturalLanguage

let schemes: [NLTagScheme] = [.language, .lemma, .lexicalClass, .nameType]
let tagger = NLTagger(tagSchemes: schemes)
let options: NLTagger.Options = [.joinNames, .omitWhitespace]

func extractNER(text: String) {
  tagger.string = text
  let tags: [NLTag] = [.personalName, .placeName, .organizationName]
  let range = text.startIndex..<text.endIndex
  tagger.enumerateTags(in: range, unit: .word, scheme: .nameType,
                       options: options) { (tag, range) -> Bool in
                        if let tag = tag, tags.contains(tag) {
                          print("\(text[range]) -> \(tag.rawValue)")
                        }
                        return true
  }
}

// https://en.wikipedia.org/wiki/Aberystwyth#Literature
let quote = """
The relatively obscure children's novel, Mr. Bass's Planetoid (1958), by Eleanor Cameron, has a character who claims to be from Aberystwyth.
"""

extractNER(text: quote)
