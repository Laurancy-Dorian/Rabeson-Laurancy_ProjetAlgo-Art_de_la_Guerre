/* MainProtocol (ou La Main) represente la collection qui contiendra des CarteProtocol (Cartes)
  Une MainProtocol possede les caracteristiques suivantes :
    On doit pouvoir ajouter des cartes a La Main
    On doit pouvoir retirer des cartes a La Main
    On doit pouvoir savoir le nombre de cartes dans La Main
*/

public protocol MainProtocol: Sequence {

    /*
      init : -> MainProtocol
      Creee une Main vide
    */
    public init()

    /*
      ajouter_main : MainProtocol x CarteProtocol -> MainProtocol
      Param : la carte a ajouter
      Pre :
      Post : la carte est ajoutee a La Main
    */
    public mutating func ajouter_main(_ carte: CarteProtocol)

    /*
      retirer_main : MainProtocol x CarteProtocl -> MainProtocol x CarteProtocol
      retire la carte de la main : la carte a retirer ne sera plus dans la Main
      Param : la carte a retirer
      Pre :
      Post : renvoie la carte retiree si elle est retiree
    */
    public mutating func retirer_main(_ carte: CarteProtocol) throws -> CarteProtocol // TODO verif si on renvoie vraiment vu qu'on la passe en parametre

    /*
      count_main : MainProtocol -> MainProtocol x Int
      Pre :
      Post : retourne le nombre de carte dans la main
    */
    public func count_main() -> Int

    /*
      est_vide : MainProtocol -> MainProtocol x Bool
      Pre :
      Post : retourne vrai si la main est vide
    */
    public func est_vide() -> Bool

    /*

    */
    public func makeIterator() -> MainProtocolIterator
}

/*
  MainProtocolIterator est un iterateur de MainProtocol qui aide au parcours de la collection
  de MainProtocol.
*/
public protocol MainProtocolIterator: IteratorProtocol {

    /*
      next : MainProtocolIterator -> MainProtocol x CarteProtocol?
      renvoie la prochaine carte de la collection de la Main
      Pre :
      Post : retourne la carte suivante dans la collection de la Main, ou nil si on a atteint le fin de la collection
    */
    public func next() -> CarteProtocol? 
}