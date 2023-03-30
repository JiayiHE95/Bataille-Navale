protocol TOcean {

  //init : {(col: Int, lig: Int)} x CodeOcean -> TOcean
  //initialisation d'un océan sans bateaux dont le nombre de cases dépend de CodeOcean
  //positions_ile : coordonnées de l'ile de l'océan (fixée par le joueur) 
  //nom : code de l'océan (o1|o2|o3)
  init(positions_ile:[(Int, Int)], nom:CodeOcean)

  //code_ocean : TOcean -> CodeOcean
  //code_ocean = nom
  //CodeOcean : o1|o2|o3
  var code_ocean : CodeOcean {get}

  //nom_ocean : TOcean -> String 
  //nom des océnans (Pacifique|Atlantique|Indien)
  //code_ocean == o1 <=> nom_ocean == "Océan Atlantique" (cf.o2,o3)
  var nom_ocean : String {get}
  
  //cases : TOcean -> [[String]]
  //correspond aux cases de l'océan 
  //la taille dépend de nom
  var cases :[[String]] {get}

  //ile : TOcean -> {(col :Int, lig : Int)}
  //{(col:Int, lig:Int)}:  coordonnées de l'ile de l'ocean 
  //coordonnées comprises dans la taille de l'océan
  //coordonnées de cases qui se succèdent 
  //fixées dans l'init
  var ile:[(Int, Int)] {get}

  //resultat_tir : (col: Int, lig : Int) x Restir -> TOcean
  //fonction qui modifie les cases de l'ocean de l'adversaire afin d'enregistrer le résultat de tir
  //si ResTir.touche/ResTir.coule, on fait appelle aussi la fonction resultat_tir() de l'adversaire pour marquer le résultat
  mutating func resultat_tir(col :Int, lig: Int, resultat: ResTir)

  //mettre_bateau_dans_case : TBateau x TOcean -> TOcean
  //fonction qui va modifier la valeur d'une case afin de pouvoir sauvegarder le placement d'un bateau
  //bateau : bateau de type TBateau de taille comprise entre 1 et 4
  mutating func mettre_bateau_dans_case(bateau:TBateau)
  
  //afficher graphiquement l'océan dans le terminal, avec les bateaux, l'ile etc..
  func afficher()
}

enum CodeOcean {
  case o1
  case o2
  case o3
}

struct Ocean:TOcean{

  //init : {(col: Int, lig: Int)} x CodeOcean -> TOcean
  //initialisation d'un océan sans bateaux dont le nombre de cases dépend de CodeOcean
  //positions_ile : coordonnées de l'ile de l'océan (fixée par le joueur) 
  //nom : code de l'océan (o1|o2|o3)
  init(positions_ile:[(Int, Int)], nom:CodeOcean){
      self.ile=positions_ile
      self.code_ocean=nom
      switch nom {
          case .o1 : 
              self.cases=[[String]](repeating:[String](repeating: "░", count: 7), count: 6)
          case .o2 : 
              self.cases=[[String]](repeating:[String](repeating:"░", count: 8), count: 7)
          case .o3 : 
              self.cases=[[String]](repeating:[String](repeating:"░", count: 6), count: 5)
      }
      
      var i:Int=0
      while i<positions_ile.count{
          let ile_case:(Int, Int)=positions_ile[i]
          self.cases[ile_case.1][ile_case.0]="⛰"
          i+=1
      }
  }

  //code_ocean : TOcean -> CodeOcean
  //code_ocean = nom
  //CodeOcean : o1|o2|o3
  public private (set) var code_ocean : CodeOcean
  
  //nom_ocean : TOcean -> String 
  //nom des océnans (Pacifique|Atlantique|Indien)
  //code_ocean == o1 <=> nom_ocean == "Océan Atlantique" (cf.o2,o3)
  public var nom_ocean : String {
    switch self.code_ocean {
      case .o1 : 
        return "Océan Atlantique";
      case .o2 : 
        return "Océan Pacifique";
      case .o3 : 
        return "Océan Indien";
    }      
  } 

  //cases : TOcean -> [[String]]
  //correspond aux cases de l'océan 
  //la taille dépend de nom
  public private (set) var cases :[[String]] 

  //ile : TOcean -> {(col :Int, lig : Int)}
  //{(col:Int, lig:Int)}:  coordonnées de l'ile de l'ocean
  //coordonnées comprises dans la taille de l'océan
  //coordonnées de cases qui se succèdent 
  //fixées dans l'init
  public private (set) var ile:[(Int, Int)] 
  
  //resultat_tir : (col: Int, lig : Int) x Restir -> TOcean
  //fonction qui modifie les cases de l'ocean de l'adversaire afin d'enregistrer le résultat de tir
  //si ResTir.touche/ResTir.coule, on fait appelle aussi la fonction resultat_tir() de l'adversaire pour marquer le résultat
  public mutating func resultat_tir(col :Int, lig: Int, resultat: ResTir){
    switch resultat { 
      case .touche:
        self.cases[lig][col]="✘"
      case .en_vue:
        self.cases[lig][col]="👁"
      case .a_leau:
        self.cases[lig][col]="▓"
      case .coule:
        self.cases[lig][col]="☠"
    }
}
  

  //mettre_bateau_dans_case : TBateau x TOcean -> TOcean
  //fonction qui va modifier la valeur d'une case afin de pouvoir sauvegarder le placement d'un bateau
  //bateau : bateau de type TBateau de taille comprise entre 1 et 4
  public mutating func mettre_bateau_dans_case(bateau:TBateau){
    var i:Int=0
    while i < bateau.positions.count {
      let bat_case:(Int,Int)=bateau.positions[i]
      self.cases[bat_case.1][bat_case.0]="⛴"
      //print(self.afficher())
      i+=1
    }
  }

  //afficher graphiquement l'océan dans le terminal, avec les bateaux, l'ile etc..
  public func afficher(){
    var num = "   "
    var ligne_retour = ""
    var ligne: Int = 0
    for i in 0..<self.cases[0].count{
      num += " │ " + String(i)
      ligne += 1
    }
    for _ in 0..<ligne{
      ligne_retour += "────"
    }
    print("    " + ligne_retour + "┐")
    print(num + " │")
    print(ligne_retour + "─────")
    
    for i in 0..<self.cases.count {
      var retour  = ""
      for j in 0..<self.cases[0].count {
        if j==0{
          retour += "│ " + String(i) + " │ "
        }
        retour += self.cases[i][j] + " │ "
      }
      print (retour)
      print(ligne_retour + "────┘")
    }
    print ("\n")
  }
}
