//
//  SetupViewController.swift
//  MikeGran
//
//  Created by Iranildo Carlos da Silva on 15/03/21.
//  Copyright © 2021 Local Oeste Software House. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class SetupViewController: UIViewController {
    
    @IBOutlet weak var zeroPublicacoes: UILabel!
    @IBOutlet weak var zeroSeguidores: UILabel!
    @IBOutlet weak var zeroSeguindo: UILabel!
    @IBOutlet weak var fotoAtualPerfil: UIImageView!
    
    var idUsuarioLogado : String!
    var firestore : Firestore!
    var autenticacao : Auth!
    
    
    override func viewDidLoad() {
        firestore = Firestore.firestore()
        autenticacao = Auth.auth()
        
        self.fotoAtualPerfil?.isHidden = false
        self.fotoAtualPerfil.layer.borderWidth = 1.0
        self.fotoAtualPerfil.layer.masksToBounds = false
        self.fotoAtualPerfil.layer.borderColor = UIColor.black.cgColor
        self.fotoAtualPerfil.layer.cornerRadius = ((self.fotoAtualPerfil.frame.size.width) / 2)
        self.fotoAtualPerfil.clipsToBounds = true
        
        if let idUsuario = autenticacao.currentUser?.uid {
            self.idUsuarioLogado = idUsuario
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        recuperarPostagens()
        recuperFotoUsuario()
    }
    
    func recuperarPostagens(){
        
        //Limpa listagem de postagens
       
       // self.collectionView.reloadData()
        
        firestore.collection("postagens")
            .getDocuments { (snapshotResultado, erro) in
                var totalPostagens = 0
                if let snapshot = snapshotResultado {
                    for document in snapshot.documents {
                        let dados = document.data()
                        
                        if document["idUsuario"] as? String == self.idUsuarioLogado{
                              totalPostagens+=1
                        }
                           
                    }
                    self.zeroPublicacoes.text = String(totalPostagens)
                    //self.collectionView.reloadData()
                }
                
        }
        
    }
    func recuperFotoUsuario(){
        firestore.collection("usuarios").document(idUsuarioLogado).getDocument { (documentSnapshot, error) in
            if let document  = documentSnapshot, ((documentSnapshot?.exists) != nil){
                
                if let urlImagem = document["urlFotoPerfil"] as? String{
                    self.fotoAtualPerfil.sd_setImage(with: URL(string: urlImagem), completed: nil)
                    
                }
            }
        }
    }
    
    
    
}
