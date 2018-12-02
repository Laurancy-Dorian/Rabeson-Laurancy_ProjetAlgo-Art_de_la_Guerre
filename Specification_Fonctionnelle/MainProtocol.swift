protocol MainProtocol : Sequence {
  init()

  mutating func ajouter_main(carte : CarteProtocol)
  mutating func retirer_main(carte : CarteProtocol) -> CarteProtocol // TODO verif si on renvoie vraiment vu qu'on la passe en parametre

  func cartes_en_main() -> CarteProtocol[]

  func count_main() -> Int

  func est_vide () -> Bool // TODO necessaire ?

}
