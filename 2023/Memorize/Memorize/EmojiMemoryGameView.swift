import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var memoryGame: EmojiMemoryGame
    typealias Card = MemoryGame<String>.Card
    
    
    private let aspectRatio: CGFloat = 2/3
    private let dealInterval: TimeInterval = 0.08
    private let deckWidth: CGFloat = 50
    private let dealAnimation: Animation = .easeInOut(duration: 1)
    
    var body: some View {
        NavigationView {
            VStack {
                cards
                    
                deck
            }
            .foregroundColor(memoryGame.themeColor)
            .navigationTitle(memoryGame.themeName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.75)) {
                            memoryGame.newGame()
                        }
                    }) {
                        Image(systemName: "rectangle.portrait.badge.plus.fill")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: {
                            memoryGame.shuffle()
                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.75)) {
                                memoryGame.shuffle()
                            }
                        }) {
                            Image(systemName: "rectangle.portrait.rotate")
                        }
                        HStack {
                            Text("\(memoryGame.score)")
                                .font(.system(.headline, weight: .semibold))
                                .contentTransition(.numericText())
                                .animation(.spring(duration: 0.2), value: memoryGame.score)
                            Text("Points")
                                .font(.subheadline)
                            }
                            .padding(10)
                            .foregroundStyle(.white)
                            .background(.blue)
                            .mask { RoundedRectangle(cornerRadius: 12, style: .continuous) }
                    }
                }
                
            }
            
        }
    }

    private var cards: some View {
        AspectVGrid(memoryGame.cards, aspectRatio: aspectRatio) { card in
            if isDealt(card) {
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                    .zIndex(scoreChange(causedBy: card) != 0 ? 100 : 0)
                    .onTapGesture {
                        withAnimation {
                            let scoreBeforeChoosing = memoryGame.score
                            memoryGame.choose(card)
                            let scoreChange = memoryGame.score - scoreBeforeChoosing
                            lastScoreChange = (scoreChange, causedByCardId: card.id)
                        }
                    }
                }
            }
        .padding()
    }
    
    @State private var lastScoreChange = (0, causedByCardId: "")
    @State private var dealt = Set<Card.ID>()
    
    private func isDealt(_ card: Card) -> Bool {
        dealt.contains(card.id)
    }
    
    private var undealtCards: [Card]  {
        memoryGame.cards.filter { !isDealt($0)}
    }
    
    private func deal() {
        memoryGame.shuffle()
        var delay: TimeInterval = 0
        for card in memoryGame.cards{
            withAnimation(.easeInOut(duration: 1).delay(delay)) {
                _ = dealt.insert(card.id)
            }
            delay += dealInterval
        }
    }
    
    
    @Namespace private var dealingNamespace
    
    private var deck: some View{
        ZStack{
            ForEach(undealtCards) { card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            }
        }
        .frame(width: deckWidth, height: deckWidth / aspectRatio)
        .onTapGesture{
            deal()
        }
    }
    
    private func scoreChange(causedBy card: Card) -> Int {
        let (amount, causedByCardId: id) = lastScoreChange
        return card.id == id ? amount : 0
    }
}

#Preview {
    EmojiMemoryGameView(memoryGame: EmojiMemoryGame())
}
