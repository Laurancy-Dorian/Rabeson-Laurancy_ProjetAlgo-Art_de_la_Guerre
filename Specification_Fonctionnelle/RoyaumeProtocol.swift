/*
  RoyaumeProtocol (ou Royaume) est une file (FIFO) qui contient des CarteProtocol (ou Cartes)
  Le Royaume contient des cartes "demobilisees" et chaque joueur possede un Royaume
  Avec le Royaume on doit pouvoir :
    - ajouter une carte 
    - retirer une carte 
    - savoir s'il est vide
    - compter le nombre de cartes
*/

public protocol RoyaumeProtocol: Sequence {

    /*
      init : -> RoyaumeProtocol
      Creee un Royaume vide
    */
    public init()

    /*
      ajouter_royaume : RoyaumeProtocol x CarteProtocol -> RoyaumeProtocol
      Ajoute une carte au Royaume
      Pre : la carte a ajouter ne doit pas etre deja dans le Royaume
      Post : ajoute la carte au Royaume
    */
    public mutating func ajouter_royaume(_ carte: CarteProtocol)

    /*
      retirer_royaume : RoyaumeProtocol x CarteProtocol -> RoyaumeProtocol x CarteProtocol
      Retire la premiere carte/la carte la plus ancienne ajoutee au Royaume (FIFO)
      Pre : le Royaume n'est pas vide, sinon renvoie une erreur
      Post : retire la carte du Royaume
    */
    public mutating func retirer_royaume() throws -> CarteProtocol // TODO On renvoie ?

    /*
      est_vide : RoyaumeProtocol -> RoyaumeProtocol x Bool
      Verifie si le Royaume est vide
      Pre :
      Post : retourne true si le Royaume est vide, false sinon
    */
    public func est_vide() -> Bool

    /*
      count_royaume : RoyaumeProtocol -> RoyaumeProtocol x Int
      Compte le nombre de cartes dans le Royaume
      Pre :
      Post : retourne le nombre de cartes dans le Royaume
    */
    public func count_royaume() -> Int

    /*
      makeIterator : RoyaumeProtocol -> RoyaumeProtocol x RoyaumeProtocolIterator
      cree un iterateur sur la collection de cartes en FIFO (premiere carte ajoutee, premiere carte sortie)
    */
    public func makeIterator() -> RoyaumeProtocolIterator 
}


/*
  RoyaumeProtocolIterator (ou iterateur de RoyaumeProtocol) est un iterateur qui sert a aider au parcours de la collection
  de RoyaumeProtocol. 

  On itere dans le Royaume de la plus ancienne a la plus recente.
*/
public protocol RoyaumeProtocolIterator: IteratorProtocol {
  /*
    next : RoyaumeProtocolIterator -> RoyaumeProtocolIterator x CarteProtocol?
    renvoie la prochaine carte dans la collection du Royaume
    Pre :
    Post : retourne la carte suivante dans la collection du Royaume, ou nil si on a atteint le fin de la collection
  */
  public func next() -> CarteProtocol? 
}
