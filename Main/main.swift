

///////////////////////////////
////// ART OF WAR - MAIN //////
///////////////////////////////


// ===== FONCTIONS DU MAIN ===== //

/*
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
  Demande a l'utilisateur de saisir une expression dans le terminal
  Affiche un message et attend une reponse specifiqie. Continue a demandee tant qu'une reponse
  satisfaisante n'a pas ete saisie
  Parameters :
    - msg   Le message a afficher a l'utilsateur (Une question, une demande de saisie)
    - rep_possibles   Un tableau de String contenant l'ensemble des reponses attendues
  Return : La reponse selectionnee par l'utilisateur
*/
func input(msg : String = "Selectionnez votre reponse", rep_possibles : [String] = ["Y", "N"]) -> String {
  // Formate le message de demande sous la forme : Message (rep_attendue1, rep_attendue2 ...)
  var choix_reponse : String = ""
  var virgule : String = ""
  for rep in rep_possibles {
    choix_reponse += virgule + rep
    virgule = ", "
  }
  let message_a_afficher : String = msg + " (" + choix_reponse + ")"

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
      for rep_attendue in rep_possibles {
        if (reponse.lowercased() == rep_attendue.lowercased()) {
          rep_correcte = true
        }
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



// ===== MAIN ===== //
