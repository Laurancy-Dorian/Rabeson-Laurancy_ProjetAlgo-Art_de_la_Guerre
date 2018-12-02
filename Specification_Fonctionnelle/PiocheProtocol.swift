protocol PiocheProtocol {
  init()

  mutating func piocher() -> CarteProtocol?

  mutating func ajouter_pioche(carte : CarteProtocol)

  func count_pioche() -> Int
}
