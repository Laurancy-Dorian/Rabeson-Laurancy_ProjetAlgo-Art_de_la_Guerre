///////////////////////////////
////// ART OF WAR - MAIN //////
///////////////////////////////


// ===== FONCTIONS DU MAIN ===== //


// -- Fonctions d'interface -- //

/*
  lire_input :  -> String?
  Lis la ligne courante et la renvoie sous forme de chaine de caractere
  Return : La ligne ecrite si la lecture a fonctionne, nil sinon
*/

func lire_input() -> String? {
    if let input = readLine() {
        return input;
    }
    return nil
}

/*
  input : String x [String] -> String

  Demande a l'utilisateur de saisir une expression dans le terminal
  Affiche un message et attend une reponse specifiqie. Continue a demandee tant qu'une reponse
  satisfaisante n'a pas ete saisie
  Parameters :
    - msg   Le message a afficher a l'utilsateur (Une question, une demande de saisie)
    - rep_possibles   Un tableau de String contenant l'ensemble des reponses attendues
  Return : La reponse selectionnee par l'utilisateur
*/
func input(_ msg: String = "Selectionnez votre reponse", _ rep_possibles: [String] = ["Y", "N"]) -> String {
    // Formate le message de demande sous la forme : Message (rep_attendue1, rep_attendue2 ...)
    let message_a_afficher: String
    var choix_reponse: String = ""
    if (!rep_possibles.isEmpty) {
        var virgule: String = ""

        for rep in rep_possibles {
            choix_reponse += virgule + rep
            virgule = ", "
        }

        message_a_afficher = msg + " (" + choix_reponse + ")"
    } else {
        message_a_afficher = msg
    }

    var reponse: String = ""
    // On recommence la boucle jusqu'a obtenir une reponse satisfaisante
    while (reponse == "") {
        // Affiche le message
        print(message_a_afficher)

        // Lit la reponse
        if let lecture_reponse = lire_input() {
            reponse = lecture_reponse

            // Verifie si la reponse est correcte
            var rep_correcte: Bool = false

            if (!rep_possibles.isEmpty) {
                for rep_attendue in rep_possibles {
                    if (reponse.lowercased() == rep_attendue.lowercased()) {
                        rep_correcte = true
                    }
                }
            } else {
                rep_correcte = true
            }

            // Si la reponse n'est pas correcte, on affiche un message et on reinitialise la
            if (!rep_correcte) {
                print("Erreur dans votre reponse")
                print("Veuillez taper l'une des reponses attendues : " + choix_reponse)
                reponse = ""
            }
        } else {
            // S'il y a eu une erreur lors de la saisie, affiche ce message et redemande de saisir la reponse
            print("Erreur lors de la lecture, veuillez reessayer")
        }
    }

    return reponse;
}

// -- Fonctions d'affichage -- //

/*
    Renvoie les donnees de la carte passee en parametre sous la forme d'une chaine de caracteres
*/
func str_carte_stats(_ c: CarteProtocol) -> String {
    var str: String = "";
    str += c.type_carte();
    str += "\t Attaque : " + c.puissance_attaque()
    if (c.statut() == 1) {
        str += "\t Statut : Offensif"
    } else {
        str += "\t Statut : Defensif"
    }
    str += "\t PV en statut Defensif : " + c.pv_defensif()
    str += "\t PV en statut Offensif : " + c.pv_offensif()

    str += "\t PV restants : " + c.pv_restants()

    return str;
}

/*
    Renvoie les donnes de la carte passee en parametre de facon reduite sous la forme d'une chaine de caracteres
    Forme : Type (Attaque, statut, PV_restants)
*/
func str_carte_red(_ c: CarteProtocol) -> String {
    var str: String = "";
    str += c.type_carte()
    str += " (" + c.puissance_attaque()
    if (c.statut() == 1) {
        str += ", Off"
    } else {
        str += ", Def"
    }
    str += ", " + c.pv_restants() + ")"
    return str;
}


func str_plateau(_ plateau: PlateauProtocol) -> String {
    var str: String = ""
    for i in (0...1) {
        for j in (0...2) {
            str += str_carte_red(plateau.carte_en_position(i, j)) + "\t"
        }
        str+= "\n"
    }
    return str
}

/*
    Renvoie les donnees du champ de bataille sur la forme de chaine de caracteres selon le point de vue du joueur actif
    Ses troupes seront affichees en bas, les troupes enemies en haut
    Parameters :
        - p_joueur_actif    Le plateau du joueur actif
        - p_joueur_inactif  Le plateau du joueur inactif
*/
func str_champ_bataille(_ p_joueur_actif: PlateauProtocol, _ p_joueur_inactif: PlateauProtocol) -> String {
    var str: String = ""
    let empty: String = "VIDE"

    var tab = align_champ_bataille(p_joueur_actif, p_joueur_inactif)

    for ligne in tab.reverse() {
        for carte in ligne {
            str += str_carte_red(carte)
            str += "\t"
        }
        str += "\n"
    }

    return str;
}

/*
    Renvoie les stats de toutes les cartes presentes dans la main du joueur sous la forme de chaine de caractere
    Parameters :
        - main  La main a afficher
*/
func str_main(_ main: MainProtocol) -> String {
    var str: String = ""
    for c in main {
        str += str_carte_stats(c) + "\n"
    }
    return str
}


func str_royaume(_ roy: RoyaumeProtocol) -> String {
    var str: String = ""
    str += "Royaume (Du plus ancien au plus recent) : \n"
    for carte in roy {
        str += str_carte_red(carte) + "\n"
    }
    return str
}


// -- Fonctions de calculs -- //

/*
    Assigne les differentes cartes des plateaux passees en parametre dans un tableau.
    La ligne 0 est l'arriere du plateau du j1
    La ligne 1 est le front du plateau du j1
    La ligne 2 est le front du plateau du j2
    La ligne 3 est l'arriere du plateau du j2

    Les deux plateau etant face a face, on aura donc la case (0,0) du J1 qui fera face a la case (0, 0) du j1, fera face
    a la case (2,0) du J2

    Le tableau[4][3] de Carte resultant sera sous cette forme, ou (x,y) represente la carte aux coordonnees x,y
    3   (2,1)   (1,1)   (0,1)   |   Arriere J2
    2   (2,0)   (1,0)   (0,0)   |   Front J2
    1   (0,0)   (1,0)   (2,0)   |   Front J1
    0   (0,1)   (1,1)   (2,1)   |   Arriere J1
          0       1       2

          ==> par exemple : tab[2][1] renvoie la carte en position (1,0) du plateau du J2
*/
func align_champ_bataille(_ p_joueur_actif: PlateauProtocol, _ p_joueur_inactif: PlateauProtocol) -> [[CarteProtocol]] {
    var tab = [[CartePotocol]]();
    var ligne1 = [CartePotocol]();
    ligne1.insert(p_joueur_actif.carte_en_position(0, 1), at: 0)
    ligne1.insert(p_joueur_actif.carte_en_position(1, 1), at: 1)
    ligne1.insert(p_joueur_actif.carte_en_position(2, 1), at: 2)

    var ligne2 = [CartePotocol]();
    ligne2.insert(p_joueur_actif.carte_en_position(0, 0), at: 0)
    ligne2.insert(p_joueur_actif.carte_en_position(1, 0), at: 1)
    ligne2.insert(p_joueur_actif.carte_en_position(2, 0), at: 2)

    var ligne3 = [CartePotocol]();
    ligne3.insert(p_joueur_inactif.carte_en_position(2, 0), at: 0)
    ligne3.insert(p_joueur_inactif.carte_en_position(1, 0), at: 1)
    ligne3.insert(p_joueur_inactif.carte_en_position(0, 0), at: 2)

    var ligne4 = [CartePotocol]();
    ligne4.insert(p_joueur_inactif.carte_en_position(2, 1), at: 0)
    ligne4.insert(p_joueur_inactif.carte_en_position(1, 1), at: 1)
    ligne4.insert(p_joueur_inactif.carte_en_position(0, 1), at: 2)

    tab.insert(ligne1, at: 0)
    tab.insert(ligne1, at: 1)
    tab.insert(ligne1, at: 2)
    tab.insert(ligne1, at: 3)

    return tab

}

// -- Fonctions d'initialisations -- //

/*
    Initialise une pioches en y ajoutant 9 Cartes de type "soldat", 6 de type "garde" et 5 de type "archer"
    retourne la pioche creee
*/
func init_pioche() -> Pioche {
    var pioche = new Pioche()

    let portee_soldat = [(0, 1)]
    let portee_archers = [(1, 2), (-1, 2), (2, 1), (-2, 1)]

    // Cree les 9 soldats
    for i in (0...8) {
        do {
            try var c = Carte("Soldat", 1, 2, 1, portee_soldat)
        } catch {
            fatalError("Erreur creation cartes soldats")
        }
        pioche.ajouter_pioche(c)
    }

    // Cree les 6 gardes
    for i in (0...5) {
        do {
            try var c = Carte("Garde", 1, 3, 2, portee_soldat)
        } catch {
            fatalError("Erreur creation cartes soldats")
        }
        pioche.ajouter_pioche(c)
    }

    // Cree les 5 archers
    for i in (0...4) {
        do {
            try var c = Carte("Archer", 1, 2, 1, portee_archers)
        } catch {
            fatalError("Erreur creation cartes soldats")
        }
        pioche.ajouter_pioche(c)
    }

    return pioche
}



// ===== MAIN ===== //


// === INITIALISATION DE LA PARTIE ===

// Instanciation des Mains
var main_j1 = Main()
var main_j2 = Main()

// Instanciation des Royaumes
var royaume_j1 = Royaume()
var royaume_j2 = Royaume()

// Instanciation des Plateaux
var plateau_j1 = Plateau()
var plateau_j2 = Plateau()


// -- Remplis les pioches des 2 joueurs de 9 soldats, 6 gardes et 5 archers -- //

// Instanciation des Pioches
var pioche_j1 = init_pioche()
var pioche_j2 = init_pioche()


// --  Met dans les mains des 2 joueurs 1 roi (random) et les 3 premières cartes de la pioche (= piocher 3x) -- //

// Instanciation des Rois
do {
    try var roi1 = Carte("Roi", 1, 4, 4, [(0, 1), (0, 2), (-1, 1), (1, 1)])
    try var roi2 = Carte("Roi", 1, 5, 4, [(0, 1), (-1, 1), (1, 1)])
} catch {
    fatalError("Erreur creation cartes soldats")
}

// Ajout des Rois dans les Mains
main_j1.ajouter_main(roi1)
main_j2.ajouter_main(roi2)

// Piocher + Ajout main
for i in (1...3) {
    main_j1.ajouter_main(pioche_j1.piocher())
}
for i in (1...3) {
    main_j2.ajouter_main(pioche_j2.piocher())
}

// -- Piocher une carte dans la pioche et la placer dans le Royaume (pour les 2 joueurs) -- //



