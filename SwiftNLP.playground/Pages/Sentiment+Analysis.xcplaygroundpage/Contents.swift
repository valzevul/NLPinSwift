import NaturalLanguage

let tagger = NLTagger(tagSchemes: [.sentimentScore])

func sentiment(for quote: String) {
  tagger.string = quote
  let (sentiment, _) = tagger.tag(at: quote.startIndex, unit: .sentence,
                                  scheme: .sentimentScore)
  if let sentimentScore = sentiment?.rawValue {
    if sentimentScore > 0 { print("😀") }
    else if sentimentScore == 0 { print("😐") }
    else { print("😭") }
  }
}

sentiment(for: "Such an awesome breeze you have here!") // -> 😀
sentiment(for: "What a day, isn't it?") // -> 😀
sentiment(for: "I hate that stormy wind!") // -> 😭
sentiment(for: "The weather is ok.") // -> 😐
