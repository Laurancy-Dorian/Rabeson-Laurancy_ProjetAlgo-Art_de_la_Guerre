import artofwar

// === Tests Unitaires d'une Carte ===

// Le test passe si init n'est pas nil.
// Renvoie 1 si le test passe, 0 sinon
func test_init() -> Int {
  print ("== Test de l'init() ==");

  var c1 : CarteProtocol = Carte();
  if let c = c1 {
    print ("Test init() ok");
  } else {
    print ("Test init() pas ok : la carte n'a pas ete initialise");
    return 0;
  }
  print ("== Fin test init() ==");
  return 1;

}

func test_init2() {

  print ("== Test de l'init(String x Int x Int x Int x (Int,Int)[]) ==");
  var portee : [(Int,Int)] = [(1,2), (0,1)];
  var porteeVide = [];

  // Carte valide
  do {
    try var c1 : CarteProtocol = Carte("Soldat", 3, 4, 3, portee);
    print ("Test Carte valide Ok")
  } catch {
    print ("Erreur d'init : Une carte valide a renvoye une exception");
    return 0;
  }


  // Cartes non valides
  do {
    try var c2 : CarteProtocol = Carte("", 3, 4, 3, portee);
    print ("Erreur d'init : Une carte ne peut pas avoir de chaine vide en type_carte");
    return 0;
  } catch {
    print ("Test carte chaine vide en type_carte ok")
  }

  do {
    try var c3 : CarteProtocol = Carte("Soldat", -1, 4, 3, portee);
    print ("Erreur d'init : Une carte ne peut pas avoir de valeur negative pour puissance_attaque");
    return 0;
  } catch {
    print ("Test carte puissance_attaque negative ok")
  }

  do {
    try var c4 : CarteProtocol = Carte("Soldat", 3, -1, -1, portee);
    print ("Erreur d'init : Une carte ne peut pas avoir de valeur negative pour les pv");
    return 0;
  } catch {
    print ("Test carte pv negatifs ok")
  }

  do {
    // Pv def < pf off ==> Carte non valide
    try var c5 : CarteProtocol = Carte("Soldat", 3, 1, 3, portee);
    print ("Erreur d'init : Une carte ne peut pas avoir pv_defensif < pv_offensif");
    return 0;
  } catch {
    print ("Test carte pv_defensif< pv_offensif ok")
  }

  do {
    try var c6 : CarteProtocol = Carte("Soldat", 3, 4, 3, nil);
    print ("Erreur d'init : Une carte ne peut pas avoir nil en portee");
    return 0;
  } catch {
    print ("Test carte portee nil ok")
  }

  do {
    try var c7 : CarteProtocol = Carte("Soldat", 3, 4, 3, porteeVide);
    print ("Erreur d'init : Une carte ne peut pas avoir un tableau vide en portee");
    return 0;
  } catch {
    print ("Test carte portee tableau vide ok")
  }

  print ("== Fin test init(String x Int x Int x Int x (Int,Int)[]) ==");
  return 1
}

func test_puissance_attaque() {
  print ("== Test de puissance_attaque() ==");

  var portee : [(Int,Int)] = [(1,2), (0,1)];
  // Carte valide
  do {
    try var c1 : CarteProtocol = Carte("Soldat", 3, 4, 3, portee);
    if (c1.puissance_attaque() != 3) {
      print ("Test ko : la puissance d'attaque ne renvoie pas la bonne valeur")
      return 0;
    }
    else {
      print ("Test ok : puissance attaque correcte")
    }
  } catch {
    print ("Erreur d'init : Une carte valide a renvoye une exception");
    return 0;
  }

  do {
    try var c2 : CarteProtocol = Carte("Soldat", -1, 4, 3, portee);
    print ("Test ko : La puissance d'attaque ne peut pas etre negative");
    return 0;
  } catch {
    print ("Test ok : valeur negative puissance attaque");
  }

  print ("== Fin test puissance_attaque() ==");
  return 1;
}

func test_pv_defensif() {
  print ("== Test de pv_defensif() ==");

  var portee : [(Int,Int)] = [(1,2), (0,1)];
  // Carte valide
  do {
    try var c1 : CarteProtocol = Carte("Soldat", 3, 4, 3, portee);
    if (c1.pv_defensif() != 4) {
      print ("Test ko : pv_defensif ne renvoie pas la bonne valeur")
      return 0;
    }
    else {
      print ("Test ok : puissance attaque correcte")
    }
  } catch {
    print ("Erreur d'init : Une carte valide a renvoye une exception");
    return 0;
  }

  do {
    try var c2 : CarteProtocol = Carte("Soldat", 4, -1, 3, portee);
    print ("Test ko : Les pv_defensif ne peuvent pas etre negatifs");
    return 0;
  } catch {
    print ("Test ok : valeur negative pv_defensif");
  }

  do {
    try var c3 : CarteProtocol = Carte("Soldat", 4, 0, 3, portee);
    print ("Test ko : Les pv_defensif ne peuvent pas etre nuls");
    return 0;
  } catch {
    print ("Test ok : valeur nulle pv_defensif");
  }

  do {
    try var c4 : CarteProtocol = Carte("Soldat", 4, 3, 5, portee);
    print ("Test ko : Les pv_defensif ne peuvent pas etre etre inferieurs aux pv offensifs");
    return 0;
  } catch {
    print ("Test ok : pv_defensif < pv_offensif");
  }

  print ("== Fin test pv_defensif() ==");
  return 1;
}



func test_pv_offensif() {
  print ("== Test de pv_offensif() ==");

  var portee : [(Int,Int)] = [(1,2), (0,1)];
  // Carte valide
  do {
    try var c1 : CarteProtocol = Carte("Soldat", 3, 4, 3, portee);
    if (c1.pv_offensif() != 3) {
      print ("Test ko : pv_offensif ne renvoie pas la bonne valeur")
      return 0;
    }
    else {
      print ("Test ok : puissance attaque correcte")
    }
  } catch {
    print ("Erreur d'init : Une carte valide a renvoye une exception");
    return 0;
  }

  do {
    try var c2 : CarteProtocol = Carte("Soldat", 4, 3, -1, portee);
    print ("Test ko : Les pv_offensif ne peuvent pas etre negatifs");
    return 0;
  } catch {
    print ("Test ok : valeur negative pv_offensif");
  }

  do {
    try var c3 : CarteProtocol = Carte("Soldat", 4, 2, 0, portee);
    print ("Test ko : Les pv_offensif ne peuvent pas etre nuls");
    return 0;
  } catch {
    print ("Test ok : valeur nulle pv_offensif");
  }

  print ("== Fin test pv_offensif() ==");
  return 1;
}

// ==== Tests ====
var nb_test_ok : Int = 0;
var nb_test_tot: Int = 0;

nb_test_tot += 1;
nb_test_ok += test_init();

nb_test_tot += 1;
nb_test_ok += test_init2();

nb_test_tot += 1;
nb_test_ok += test_puissance_attaque();

nb_test_tot += 1;
nb_test_ok += test_pv_defensif();
