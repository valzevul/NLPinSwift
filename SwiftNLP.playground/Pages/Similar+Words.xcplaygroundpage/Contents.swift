import Foundation
import NaturalLanguage

func findSimilar(for word: String) {
  let embedding = NLEmbedding.wordEmbedding(for: .english)
  embedding?.enumerateNeighbors(for: word.lowercased(),
                                maximumCount: 5) { (string, distance) -> Bool in
                                  print(string)
                                  return true
  }
}


findSimilar(for: "rarebit") // -> sauce, cheese, toast, bread, mustard
findSimilar(for: "swift") // -> fast, fleet, speedy, quick, rapid


