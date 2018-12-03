import artofwar

// === Tests Unitaires d'une Carte ===

// Le test passe si init n'est pas nil.
// Renvoie 1 si le test passe, 0 sinon
func test_init() -> Int {
  print ("== Test de l'init() ==");

  var c1 : CarteProtocol = Carte();
  if let c = c1 {
    print ("Test init() ok");
    nb_test_ok += 1;
  } else {
    print ("Erreur : la carte n'a pas ete initialise");
  }
  print ("== Fin test init() ==")
  return
}


var nb_test_ok : Int = 0;
var nb_test_tot: Int = 0;

  nb_test_tot += 1;


print ("== Test de l'init(String x Int x Int x Int x (Int,Int)[] ) ==");
var portee = [(1,2), (0,0)];

var c1 : CarteProtocol = Carte();
if let c = c1 {
  print ("Test init() ok");
  nb_test_ok += 1;
} else {
  print ("Erreur : la carte n'a pas ete initialise");
}
print ("== Fin test String x Int x Int x Int x (Int,Int)[]) ==")
