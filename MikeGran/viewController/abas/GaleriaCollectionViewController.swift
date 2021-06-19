//
//  HomeViewController.swift
//  Mikegram
//
//  Created by Iranildo Carlos da Silva on 15/03/21.
//  Copyright © 2021 Local Oeste Software House. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseUI


class GaleriaCollectionViewController: UICollectionViewController{
    
    var usuario: Dictionary<String, Any>!
    var firestore: Firestore!
    var postagens: [Dictionary<String, Any>] = []
    var idUsuarioSelecionado: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        firestore = Firestore.firestore()
        
        if let id = usuario["id"] as? String {
            idUsuarioSelecionado = id
        }
        
        if let nome = usuario["nome"] as? String {
            self.navigationItem.title = nome
        }
        
        //********* Esconde o teclado após toque na tela  *************
//        self.hideKeyboardWhenTappedAround()
//
//            self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(GaleriaCollectionViewController.dismissKeyboard)))
        //*************************************************************
        
        
    }
    
    
//    //Esconde o teclado após toque na tela
//    func hideKeyboardWhenTappedAround() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GaleriaCollectionViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        recuperarPostagens()
    }
    
    func recuperarPostagens(){
        
        //Limpa listagem de postagens
        self.postagens.removeAll()
        self.collectionView.reloadData()
        
        firestore.collection("postagens")
        .document( idUsuarioSelecionado )
        .collection("postagens_usuario")
            .getDocuments { (snapshotResultado, erro) in
                
                if let snapshot = snapshotResultado {
                    for document in snapshot.documents {
                        let dados = document.data()
                        self.postagens.append(dados)
                    }
                    self.collectionView.reloadData()
                }
                
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.postagens.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let celula = collectionView.dequeueReusableCell(withReuseIdentifier: "celulaGaleria", for: indexPath) as! GaleriaCollectionViewCell
        
        let indice = indexPath.row
        let postagem = self.postagens[indice]
        
        let descricao = postagem["descricao"] as? String
        if let url = postagem["url"] as? String {
            celula.foto.sd_setImage(with: URL(string: url), completed: nil)
        }
        
        //celula.foto.image = UIImage(named: "padrao")
        celula.descricao.text = descricao
        
        return celula
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

}
