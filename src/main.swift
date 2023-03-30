//-----------------------------Mode de l'environnement----------------------------------
import Foundation
let mode = ProcessInfo.processInfo.environment["MODE"]
//export MODE=scenario

//-------------------------------------fonctions pour vérifier les saisis ------------------------------------

//inputNom : String -> String 
//fonction qui vérifie les saisies des noms des joueurs
func inputNom(message: String) -> String{
    var reponse : String? = nil
    var rep : String? = nil
    print("")
    print(message)
    
    repeat{
        repeat{
          reponse = readLine()
        } while (reponse == nil) || reponse!.hasPrefix("#")
        if let reponse = reponse{
            if mode == "scenario" {print(reponse)}
            rep = String(reponse)
        }
    } while (reponse == nil) || (reponse!.count==0) || (rep == nil)
    return rep!
}

//inputIle : String x CodeOcean -> {(col: Int, lig: Int)}
//fonction qui convertie les positions de l'ile saisies en entrée dans le bon format (tableau de positions)
//Pre : ocean = o1|o2|o3
//Post : {(col: Int, lig: Int)} : positions de l'ile qui a été vérifiée 
func inputIle(message: String, ocean:CodeOcean) -> [(Int,Int)]{
  var reponse : String? = nil
  var rep : [(Int,Int)]? = nil
    print(message)
    print("\nPar exemple : 0,0,0,1,0,2,0,3")
    print("Les deux premiers chiffres correspondent à ligne et colonne de case1 (resp. case2, case3, case4)")
    print("Coordonnées séparées par des virgules, sans espace, la case n+1 doit être verticalement ou horizontalement liée à la case n)")
  repeat{
    reponse = readLine()
    if let reponse = reponse{
        if mode == "scenario" {print(reponse)}
        rep = checkInput_ile(ocean:ocean, positions:reponse)     
    }
  }while (reponse == nil) || (rep == nil) 
  return rep!
}

//checkInput_ile : CodeOcean x String => {(col: Int, lig: Int)|Vide}
//fonction qui vérifie si les coordonnées saisies par le joueur sont valides
//Pre : ocean = o1|o2|o3
//Pre : positions = exemple : 0,0,0,1,0,2,0,3
//Post : {(col: Int, lig: Int)|Vide} : les coordonnées de l'ile si elle sont valides, Vide sinon
func checkInput_ile(ocean:CodeOcean, positions:String) -> [(Int,Int)]?{
  let positions = positions.split(separator: ",")
  //si les coordonnées sont impairs
  if positions.count%2==1 {
    print("Il manque des coordonnées")
    return nil
  }
  //si le nombre de couple (col, lig) est inférieur à 4
  else if positions.count/2<4 {
    print("L'île doit occuper au moins 4 cases")
    return nil 
  }

  //Verifier si les positions ne contiennent que des int
  var posInt:Bool=true
  var i:Int=0
  while i < positions.count && posInt{
    if Int(positions[i]) == nil {
      posInt=false
    }
    i+=1
  }
  if !posInt {
    print("Veuillez entrer uniquement des chiffres, séparés par des virgules")
    return nil
  }

  //mise en forme des positions de l'île en format [(Int,Int)]
  var coordonnes:[(Int,Int)]=[(Int,Int)](repeating:(0,0), count:positions.count/2) 
  var ic:Int=0
  var ip:Int=0
  while ic<positions.count/2 {
    coordonnes[ic]=(Int(positions[ip+1])!,Int(positions[ip])! )
    ic+=1
    ip+=2
  }
  
  //Verifie si toutes les cases de l'ile sont comprises dans celles de l'océan
  var outofrange:Bool=false
  var quatreCasesDifferentes:Bool=true
  for co in coordonnes{
    if !checkpos_outofrange (ocean:ocean, col: co.0, lig: co.1){
      outofrange=true
    }
    //Verifie si le joueur a saisi plusieurs fois une même case ou plus 
    var nbCaseIdentique:Int=0
    for c in coordonnes{
      if co == c{
        nbCaseIdentique+=1
      }
      if coordonnes.count-(nbCaseIdentique-1)<4{
        quatreCasesDifferentes=false
      }
    }
  }

  if outofrange{
    print("Au moins un emplacement de l'île dépasse de l'ocean")
    return nil
  }
  if !quatreCasesDifferentes{
    print("L'île doit occuper au moins 4 cases différentes")
    return nil
  }

  //verifie pour chaque case de l'ile si elle est contigue avec au moins une autre case de l'ile
  var estContigue:Bool=true
  i=0
  while i<coordonnes.count && estContigue {
    var nb_positions_contigues:Int=0
    for co in coordonnes{
      if abs(co.0 - coordonnes[i].0)+abs(co.1 - coordonnes[i].1) == 1{
        nb_positions_contigues+=1
      }
    }
    if nb_positions_contigues == 0 {
      estContigue = false
    }
    i+=1
  }
  if !estContigue {
    print("Les positions de l'île doivent être contigues, veuillez resaisir")
    return nil
  }
  return coordonnes
}


//checkpos_outofrange : CodeOcean x (col :Int, lig : Int) -> Bool
//vérifie si la position à laquelle le joueur souhaite tiré fait bien partie de l'espace limitée 
//Pre : ocean: o1 | o2 | o3 
//Pre : (col :Int, lig : Int) : correspond à la case où le joueur veut tirer 
//Post : Bool : True => la position est comprise dans l'océan
func checkpos_outofrange (ocean:CodeOcean, col: Int, lig: Int) -> Bool {
  if (col < 0 || lig < 0) {
      return false
  }
  else {
    switch ocean {
      case .o1  :
        return (col < 7 && lig < 6)
      case .o2 : 
        return (col < 8 && lig < 7)
      case .o3 :
        return (col < 6 && lig < 5)
    }
  }
}


//inputBateau : String x Int x {{(col :Int, lig : Int)}} x {TBateau} -> (CodeOcean,Direction,{(col :Int, lig : Int)})
//fonction qui convertie les saisies en entrée dans le bon format 
//Pre : 0<taille<=5
//Pre : message : exemple = o1,0,1,S
//Pre : bateaux : tableau de TBateau 
//Pre : iles : tableau de tableaux de positions des iles 
func inputBateau(message: String, taille: Int, iles:[[(Int,Int)]], bateaux:[TBateau]) -> (CodeOcean,Direction,[(Int,Int)]){
  var reponse : String? = nil
  var rep : (CodeOcean,Direction,[(Int,Int)])? = nil
  print("")
  print(message, ", taille ",taille)
  print("Par exemple : o1,0,1,S (ocean, ligne, colonne, direction), coordonnées séparées par des virgules, sans espace")
  repeat{
    reponse = readLine()
    if let reponse = reponse{
        if mode == "scenario" {print(reponse)}
        rep = checkInput_bateau(positions:reponse, taille:taille, iles:iles, bateaux:bateaux)     
    }
  }while (reponse == nil) || (rep == nil) 
  return rep!
}


//checkInput_bateau : String x Int x {{(col :Int, lig : Int)}} x {TBateau} -> (CodeOcean,Direction,{(col :Int, lig : Int)})|Vide
//fonction qui vérifie si les coordonnées d'un bateau saisies par le joueur sont valides
//Post : renvoi le code de l'océan, la direction du bateau et le tableau de positions d'un bateau si les saisies sont valides
//Vide sinon
func checkInput_bateau(positions:String, taille:Int, iles:[[(Int,Int)]], bateaux:[TBateau]) -> (CodeOcean,Direction,[(Int,Int)])?{
  let positions = positions.split(separator: ",")
  //si le nombre d'info n'est pas exactement egale à 4
  if positions.count != 4 {
    print("Il faut que le nombre d'entrées soit exactement 4, (String,Int,Int,String) souhaité")
    return nil
  }
  //verifier si (col,lig) est de type (Int,Int)
  else if (Int(positions[1]) == nil) || (Int(positions[2]) == nil) {
      print("Le format des entrées saisies n'est pas valide, (String,Int,Int,String) souhaité")
      return nil
  }

  //separe la saisi de joueur (positions)
  let ocean:String=String(positions[0])
  let col:Int=Int(positions[2])!
  let lig:Int=Int(positions[1])!
  let direction:String = String(positions[3])

  //verifie si les valeurs de col et lig de la première case de bateau sont positifs 
  if col<0 || lig<0 {
    print("Les coordonnées concernant la colonne et la ligne doivent être supérieures ou égales à 0")
    return nil
  }
  
  //verifie si la direction saisie est valide et donne la dernière case du bateau selon la direction
  var d:Direction=Direction.N
  switch direction {
    case "S":
      d=Direction.S
    case "N":
      d=Direction.N
    case "O":
      d=Direction.O
    case "E":
      d=Direction.E
    default:
      print("Direction non valide, veuillez saisir S/N/O/E")
      return nil
  }

  //verifier si l'ocean saisi est valide
  var o:CodeOcean=CodeOcean.o1
  var position_ile:[(Int,Int)]=iles[0]
  switch ocean {
    case "o1"  :
      o=CodeOcean.o1
      position_ile = iles[0]
    case "o2" : 
      o=CodeOcean.o2
      position_ile = iles[1]
    case "o3" :
      o=CodeOcean.o3
      position_ile = iles[2]
    default:
      print("Veuillez saisir o1, o2 ou o3")
      return nil
  }

  //verifie si la première case du bateau (col,lig) depasse l'ocean sur lequel il sera placé
  var positions_bateau=[(Int,Int)](repeating:(0,0),count:taille)
  positions_bateau[0] = (col,lig)
  if !checkpos_outofrange(ocean:o, col: col, lig: lig) {
      print("Au moins une position du bateau dépasse de l'ocean, veuillez ressaisir")
      return nil
  }

  //verifie les autres cases du bateau (col,lig) en fonction de la direction saisie 
  var outofrange:Bool=false
  for i in 1..<taille{
    switch d {
      case Direction.N :
        positions_bateau[i] = (col,lig-i)
      case Direction.S :
        positions_bateau[i] = (col,lig+i)
      case Direction.O :
        positions_bateau[i] = (col-i,lig)
      case Direction.E :
        positions_bateau[i] = (col+i,lig)
    }
    if !checkpos_outofrange(ocean:o, col: positions_bateau[i].0, lig: positions_bateau[i].1) {
      outofrange=true
    }
  }
  if outofrange {
    print("Au moins un emplacement du bateau dépasse de l'océan, veuillez ressaisir")
    return nil
  }

  //Vérifier si le bateau sur sur la même position que l'ile
  var position_deja_prise:Bool=false
  for pos in position_ile {
    for bat in positions_bateau{
      if pos == bat{
        position_deja_prise=true
      }
    }
  }
  if position_deja_prise {
    print("Vous ne pouvez pas placer un bateau sur une ile, veuillez saisir une position valide")
    return nil
  }
  
  //Vérifie si le bateau est sur la même position que les bateaux créées antérieurement sur le même océan
  position_deja_prise=false
  if bateaux.count != 0{
    for bat in bateaux {
      if bat.ocean == o {
        for pos in bat.positions {
          for p in positions_bateau {
            if pos == p {
              position_deja_prise=true
            }
          }
        }
      } 
    }
  }
  if position_deja_prise {
    print ("Il y a déjà un bateau de positionné à cet emplacement, vous ne pouvez pas superposer des bateaux")
    return nil
  }

  return (o,d,positions_bateau)  
}


//inputModeJeu : String -> Int x String
//fonction qui prends le mode saisi au clavier pour le traduire en nombre de tour du jeu et le mode du jeu
//- Facile : nombre de tirs illimité.
//- Normal : nombre de tirs limité à 65.
//- Difficile : nombre de tirs limité à 50.
//- Extrême : nombre de tirs limités à 40
func inputModeJeu(message:String) -> (Int,String){
  var reponse : String? = nil
  var rep:String="mode inconnu"
  var nb_tour : Int = 0
  
  print("")
  print(message)
  repeat{
      reponse = readLine()
      if let reponse = reponse{
          if mode == "scenario" {print(reponse)}
          switch reponse.uppercased(){
            case "FACILE":
              nb_tour = 1
              rep = "FACILE"
            case "NORMAL":
              nb_tour = 65
              rep = "NORMAL"
            case "DIFFICILE":
              nb_tour = 50
              rep = "DIFFICILE"
            case "EXTREME":
              nb_tour = 40
              rep = "EXTREME"
            default:
              print("Ce mode de jeu n'existe pas.")
          }     
      }
  } while (rep == "mode inconnu") || (nb_tour == 0)
  
  return (nb_tour,rep)
}


//inputTir : String x {{(col: Int, lig: Int)}} -> (CodeOcean x (col: Int, lig: Int))
//fonction qui prend les coordonnées de tir et l'ocean saisis au clavier et les traduit en retournant les coordonnée et l'ocean en bon format
func inputTir(message:String, iles:[[(Int,Int)]]) -> (CodeOcean,Int,Int){
  var reponse : String? = nil
  var rep : (CodeOcean,Int,Int)? = nil
  print("")
  print(message)
  print("Par exemple : o1,0,1 (ocean, ligne, colonne), coordonnées séparées par des virgules, sans espace")
  repeat{
    reponse = readLine() 
    if let reponse = reponse{
        if mode == "scenario" {print(reponse)}
        rep = checkInput_tir(positions:reponse, iles:iles)     
    }
  }while (reponse == nil) || (rep == nil) 
  print("Vous venez de tirer sur ", rep!.0, ", ligne ", rep!.1, " colonne ", rep!.2)
  return rep!
}


//checkInput_tir : String x {{(col: Int, lig: Int)}} -> (CodeOcean x (col: Int, lig: Int))|Vide
//fonction qui vérifie si les coordonnées saisies par le joueur sont valides
//Post : renvoi (CodeOcean x (col: Int, lig: Int) si les coordonnées sont valides, vide sinon 
func checkInput_tir(positions:String, iles:[[(Int,Int)]])->(CodeOcean,Int,Int)?{
  let positions = positions.split(separator: ",")
  
  //Verifie si le nombre des coordonnées saisie est impair
  if (positions.count%3 != 0) || (positions.count/3 != 1) {
    print("Il faut que le nombre d'entrées saisies soit exactement 3")
    return nil
  }
  
  //Vérifie si les coordonnes (col,lig) sont des Int
  else if (Int(positions[1]) == nil) || (Int(positions[2]) == nil) {
    print("Le format des entrées saisies n'est pas valide, (String,Int,Int) souhaité")
    return nil
  }
  
  let ocean:String=String(positions[0])
  var o:CodeOcean=CodeOcean.o1
  var indiceI:Int=0
  let col:Int=Int(positions[2])!
  let lig:Int=Int(positions[1])!

  //verifie si l'ocean saisi par joueur existe (o1|o2|o3)
  switch ocean {
    case "o1"  :
      o=CodeOcean.o1
      indiceI=0
    case "o2" : 
      o=CodeOcean.o2
      indiceI=1
    case "o3" :
      o=CodeOcean.o3
      indiceI=2
    default:
      print("Veuillez saisir o1, o2 ou o3")
      return nil
  }

  //verifie si les coordonnées de tir sont bien sur l'ocean sur lequel le joueur veut tirer
  if !checkpos_outofrange(ocean:o, col: col, lig: lig) {
    print("La position sur laquelle vous souhaitez tirer est en dehors de l'océan, veuillez retirer")
    return nil
  }

  var tirSurIle:Bool=false 
  for case_ile in iles[indiceI]{
    if (case_ile.0==col)&&(case_ile.1==lig){
      tirSurIle=true
    }
  }
  if tirSurIle {
    print("Vous avez tiré sur une île, veuillez retirer")
    return nil
  }

  return (o,Int(positions[1])!, Int(positions[2])!)  
}



//-----------------------------Initialisation des noms de joueur----------------------------------
var pseudo1:String = ""
var pseudo2:String = ""
repeat{
  pseudo1 = inputNom(message: "Donnez un pseudo pour joueur 1 :")
  pseudo2 = inputNom(message: "Donnez un pseudo pour joueur 2, le pseudo doit être différent que \(pseudo1) :")
} while (pseudo1 == pseudo2)



//-----------------------------Initialisation du nombre de tour selon le mode de jeu----------------------------------

let modeJeu:(Int,String) = inputModeJeu(message:"Choisissez un mode de jeu (Facile, Normal, Diffile ou Extrême) : ") 
var jeu_iteration:Int=0


//-----------------------------Initialisation des iles----------------------------------

var ile1:[(Int,Int)] = inputIle(message: "Donnez les coordonnées de l'île pour Océan Atlantique(o1) :", ocean:CodeOcean.o1)
var ile2:[(Int,Int)] = inputIle(message: "Donnez les coordonnées de l'île pour Océan Pacifique(o2) :", ocean:CodeOcean.o2)
var ile3:[(Int,Int)] = inputIle(message: "Donnez les coordonnées de l'île pour Océan Indien(o3) :", ocean:CodeOcean.o3)

let iles:[[(Int,Int)]]=[ile1,ile2,ile3]


//-----------------------------Initialisation des oceans pour joueur 1----------------------------------

var o1_j1_joueur:TOcean = Ocean.init(positions_ile:ile1, nom:CodeOcean.o1) 
var o1_j1_adversaire:TOcean = Ocean.init(positions_ile:ile1, nom:CodeOcean.o1)
var o2_j1_joueur:TOcean = Ocean.init(positions_ile:ile2, nom:CodeOcean.o2)
var o2_j1_adversaire:TOcean = Ocean.init(positions_ile:ile2, nom:CodeOcean.o2)
var o3_j1_joueur:TOcean = Ocean.init(positions_ile:ile3, nom:CodeOcean.o3) 
var o3_j1_adversaire:TOcean = Ocean.init(positions_ile:ile3, nom:CodeOcean.o3)


//-----------------------------Initialisation des oceans pour joueur 2----------------------------------

var o1_j2_joueur:TOcean = Ocean.init(positions_ile:ile1, nom:CodeOcean.o1) 
var o1_j2_adversaire:TOcean = Ocean.init(positions_ile:ile1, nom:CodeOcean.o1)

var o2_j2_joueur:TOcean = Ocean.init(positions_ile:ile2, nom:CodeOcean.o2)
var o2_j2_adversaire:TOcean = Ocean.init(positions_ile:ile2, nom:CodeOcean.o2)

var o3_j2_joueur:TOcean = Ocean.init(positions_ile:ile3, nom:CodeOcean.o3) 
var o3_j2_adversaire:TOcean = Ocean.init(positions_ile:ile3, nom:CodeOcean.o3)


//-----------------------------Initialisation des bateaux pour joueur 1----------------------------------

//Toutes les tailles de bateaux, tailles.count==nombre de bateaux(5)
let tailles:[Int]=[1,2,3,3,4]

var bateaux_j1:[TBateau]=[]
var i:Int=0

repeat {
  //demande au joueur de saisir les coordonnées de bateau pour créer ensuite le bateau
  let pos_bat_j1:(CodeOcean,Direction,[(Int,Int)]) = inputBateau(message: "Donnez les coordonnées du bateau pour \(pseudo1) :", taille:tailles[i], iles:iles, bateaux:bateaux_j1)
  let bat_j1:TBateau = Bateau.init(positions_init:pos_bat_j1.2, taille_init : tailles[i], direction: pos_bat_j1.1, o:pos_bat_j1.0)
  bateaux_j1.append(bat_j1) 
  i+=1
} while (i<tailles.count)


//-----------------------------Initialisation des bateaux pour joueur 2----------------------------------

var bateaux_j2:[TBateau]=[]
var j:Int=0

repeat {
  let pos_bat_j2:(CodeOcean,Direction,[(Int,Int)]) = inputBateau(message: "Donnez les coordonnées du bateau pour \(pseudo2) :", taille:tailles[j], iles:iles, bateaux:bateaux_j2)
  let bat_j2:TBateau = Bateau.init(positions_init:pos_bat_j2.2, taille_init : tailles[j], direction: pos_bat_j2.1, o:pos_bat_j2.0)
  bateaux_j2.append(bat_j2)
  j+=1
} while (j<tailles.count)


//-----------------------------Initialisation des joueurs----------------------------------

var j1:TJoueur = Joueur.init(bateaux_adversaire:bateaux_j2, nom_joueur: pseudo1, oceans_joueur : [o1_j1_joueur, o2_j1_joueur, o3_j1_joueur], oceans_adversaire: [o1_j1_adversaire, o2_j1_adversaire, o3_j1_adversaire])
var j2:TJoueur = Joueur.init(bateaux_adversaire:bateaux_j1, nom_joueur: pseudo2, oceans_joueur : [o1_j2_joueur, o2_j2_joueur, o3_j2_joueur], oceans_adversaire: [o1_j2_adversaire, o2_j2_adversaire, o3_j2_adversaire])

//marquer les bateaux de joueur dans son list_ocean_joueur
j1.gestion_affichage_bateaux(bat_joueur:bateaux_j1)
j2.gestion_affichage_bateaux(bat_joueur:bateaux_j2)



//******************************************************************************************************************


//----------------------------------------Debut du jeu---------------------------------------------

while (!j1.est_gagne) && (!j2.est_gagne) && (modeJeu.0>jeu_iteration){
  
    //----------------------------A joueur 1 de jouer------------------------------

    //j1 saisi les coordonnées de tir
    let pos_tir_j1:(CodeOcean,Int,Int) = inputTir(message:"\(pseudo1) tire :", iles:iles)
    let resultat_j1:ResTir = j1.tirer(o:pos_tir_j1.0, col:pos_tir_j1.2, lig:pos_tir_j1.1)
  
    //marquer le résultat de tir sur list_ocean_adversaire de joueur
    j1.gestion_affichage_resTir(ocean:pos_tir_j1.0, col:pos_tir_j1.2, lig:pos_tir_j1.1, res:resultat_j1, joueurEnCours:j1)
    //marquer le résultat de tir sur list_ocean_joueur de l'adversaire (si resTir == Touche/Coule)
    j2.gestion_affichage_resTir(ocean:pos_tir_j1.0, col:pos_tir_j1.2, lig:pos_tir_j1.1, res:resultat_j1, joueurEnCours:j1)

    if j1.est_gagne {
      print("Bravo ! \(pseudo1) gagne le jeu (pour l'instant)!")
      print("On attend que \(pseudo2) finisse son dernier tour pour annoncer le résultat final")
    }
  
    //afficher les océans de joueur lui-même
    var ocean_ite_j1:Int=0
    while ocean_ite_j1<j1.list_ocean_joueur.count{
        print(j1.list_ocean_joueur[ocean_ite_j1].nom_ocean, "de \(pseudo1)")
        j1.list_ocean_joueur[ocean_ite_j1].afficher()
        ocean_ite_j1+=1
    }
    //afficher les océans de son adversaire avec le résultat de tir
    ocean_ite_j1=0
    while ocean_ite_j1<j1.list_ocean_joueur.count{
        print(j1.list_ocean_joueur[ocean_ite_j1].nom_ocean, "de \(pseudo2)")
        j1.list_ocean_adversaire[ocean_ite_j1].afficher()
        ocean_ite_j1+=1
    }


    //----------------------------A joueur 2 de jouer------------------------------
    let pos_tir_j2:(CodeOcean,Int,Int) = inputTir(message:"\(pseudo2) tire :", iles:iles)
    let resultat_j2:ResTir = j2.tirer(o:pos_tir_j2.0, col:pos_tir_j2.2, lig:pos_tir_j2.1)

    j2.gestion_affichage_resTir(ocean:pos_tir_j2.0, col:pos_tir_j2.2, lig:pos_tir_j2.1, res:resultat_j2, joueurEnCours:j2)
    j1.gestion_affichage_resTir(ocean:pos_tir_j2.0, col:pos_tir_j2.2, lig:pos_tir_j2.1, res:resultat_j2, joueurEnCours:j2)
  
    var ocean_ite_j2:Int=0
    while ocean_ite_j2<j2.list_ocean_joueur.count{
        print(j2.list_ocean_joueur[ocean_ite_j2].nom_ocean, "de \(pseudo2)")
        j2.list_ocean_joueur[ocean_ite_j2].afficher()
        ocean_ite_j2+=1
    }
    ocean_ite_j2=0
    while ocean_ite_j2<j2.list_ocean_joueur.count{
        print(j2.list_ocean_joueur[ocean_ite_j2].nom_ocean, "de \(pseudo1)")
        j2.list_ocean_adversaire[ocean_ite_j2].afficher()
        ocean_ite_j2+=1
    }
    //--------------------------------Fin d'un tour----------------------------------
     if modeJeu.1 != "FACILE"{
      jeu_iteration+=1
    }
}

//-----------------------------Affichage résulat jeu----------------------------------
if j1.est_gagne && j2.est_gagne{
    print("Félicitations à \(pseudo1)et \(pseudo2), vous avez coulé tous les navires de votre adversaire en même temps!")
}
else if j1.est_gagne{
    print("Félicitations ! \(pseudo1) gagne !")
}
else if j2.est_gagne{
    print("Félicitations ! \(pseudo2) gagne !")
}
else if jeu_iteration==modeJeu.0 {
    print("Dommage... Personne n'a gagné, vous avez atteint le nombre de tours max autorisé")
}

//-----------------------------Fin du jeu----------------------------------
