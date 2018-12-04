import ArtOfWar

///////////////////////////////
////// ART OF WAR - MAIN //////
///////////////////////////////


// ===== FONCTIONS DU MAIN ===== //

/*
  lire_input :  -> String?
  Lis la ligne courante et la renvoie sous forme de chaine de caractere
  Return : La ligne ecrite si la lecture a fonctionne, nil sinon
*/
func lire_input() -> String? {
  if let input = readLine() {
    return input
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
func input(_ msg : String = "Selectionnez votre reponse", _ rep_possibles : [String] = ["Y", "N"]) -> String {
  // Formate le message de demande sous la forme : Message (rep_attendue1, rep_attendue2 ...)
  let message_a_afficher : String
  var choix_reponse : String = ""
  if (!rep_possibles.isEmpty) {
    var virgule : String = ""

    for rep in rep_possibles {
      choix_reponse += virgule + rep
      virgule = ", "
    }

    message_a_afficher = msg + " (" + choix_reponse + ")"
  }
  else {
    message_a_afficher = msg
  }

  var reponse : String = ""
  // On recommence la boucle jusqu'a obtenir une reponse satisfaisante
	while (reponse == "") {
    // Affiche le message
    print (message_a_afficher)

    // Lit la reponse
    if let lecture_reponse = lire_input() {
      reponse = lecture_reponse

      // Verifie si la reponse est correcte
      var rep_correcte : Bool = false

      if (!rep_possibles.isEmpty) {
        for rep_attendue in rep_possibles {
          if (reponse.lowercased() == rep_attendue.lowercased()) {
            rep_correcte = true
          }
        }
      }
      else {
        rep_correcte = true
      }

      // Si la reponse n'est pas correcte, on affiche un message et on reinitialise la
      if (!rep_correcte) {
        print ("Erreur dans votre reponse")
        print ("Veuillez taper l'une des reponses attendues : " + choix_reponse)
        reponse = ""
      }
    } else {
      // S'il y a eu une erreur lors de la saisie, affiche ce message et redemande de saisir la reponse
      print ("Erreur lors de la lecture, veuillez reessayer")
    }
  }

  return reponse;
}

func str_carte_stats (_ c : CarteProtocol) -> String{
  var str : String = "";
  str += c.type_carte();
  str += "\n Attaque : " + c.puissance_attaque()
  if (c.statut() == 1) {
    str += "\n Statut : Offensif"
  } else {
    str += "\n Statut : Defensif"
  }
  str += "\n PV en statut Defensif : " + c.pv_defensif()
  str += "\n PV en statut Offensif : " + c.pv_offensif()

  str += "\n PV restants : " + c.pv_restants()
  return str;
}

func str_plateau (_ p : PlateauProtocol) {

}

func str_champ_bataille (_ p1 : PlateauProtocol, _ p2 : PlateauProtocol)


// ===== MAIN ===== //
