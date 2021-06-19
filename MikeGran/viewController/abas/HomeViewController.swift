//
//  HomeViewController.swift
//  Mikegram
//
//  Created by Iranildo Carlos da Silva on 15/03/21.
//  Copyright © 2021 Local Oeste Software House. All rights reserved.
//
import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseUI

class HomeViewController: UIViewController,
    UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewPostagens: UITableView!
    var firestore: Firestore!
    var auth: Auth!
    var postagens: [Dictionary<String, Any>] = []
    var idUsuarioLogado: String!
    var idPostador: String!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewPostagens.separatorStyle = .none
        
        firestore = Firestore.firestore()
        auth = Auth.auth()
        
        if let idUsuario = auth.currentUser?.uid {
            self.idUsuarioLogado = idUsuario
        }
        
//        if let  postador =  self.recuperaDadosUsuarioPostador(){
//            idPostador = postador
//        }
        
        //********* Esconde o teclado após toque na tela  *************
        self.hideKeyboardWhenTappedAround()

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HomeViewController.dismissKeyboard)))
        //*************************************************************
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        recuperarPostagens()
    }
    
    
    //Esconde o teclado após toque na tela
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    
    
    func recuperarPostagens(){
        
        //Limpa listagem de postagens
        self.postagens.removeAll()
        self.tableViewPostagens.reloadData()
        
        firestore.collection("postagens").order(by: "data", descending: true)
       
            .getDocuments { (snapshotResultado, erro) in
                
                if let snapshot = snapshotResultado {
                    for document in snapshot.documents {
                        let dados = document.data()
                        
                        self.postagens.append(dados)
                        
                    }
                    self.tableViewPostagens.reloadData()
                }
                
        }
        
    }
    
    /*Métodos para listagem na tabela*/
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postagens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "celulaPostagens", for: indexPath) as! PostagemTableViewCell
        
        let indice = indexPath.row
        let postagem = self.postagens[indice]
        
        celula.fotoPostador?.isHidden = false
        celula.fotoPostador.layer.borderWidth = 1
        celula.fotoPostador.layer.masksToBounds = false
        celula.fotoPostador.layer.borderColor = UIColor.black.cgColor
        celula.fotoPostador.layer.cornerRadius = ((celula.fotoPostador.frame.width)/2)
        celula.fotoPostador.clipsToBounds = true
        
        
        let descricao = postagem["descricao"] as? String
        
        if let url = postagem["url"] as? String {
            celula.fotoPostagem.sd_setImage(with: URL(string: url), completed: nil)
        }
        if let foto = postagem["urlFotoPostador"] as? String{
            celula.fotoPostador.sd_setImage(with: URL(string: foto), completed: nil)
        }else{
            celula.fotoPostador.sd_setImage(with: URL(string: ""), completed: nil)
        }
        if let nomePost = postagem["nomePostador"] as? String{
            celula.nomePostagem.text = nomePost
        }
        
        celula.descricaoPostagem.text = descricao
        //celula.fotoPostagem.image =
        
        return celula
        
    }
    
    

}

