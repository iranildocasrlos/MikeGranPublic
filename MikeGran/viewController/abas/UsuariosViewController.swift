//
//  UsuariosViewController.swift
//  Mikegram
//
// Created by Iranildo Carlos da Silva on 15/03/21.
//  Copyright © 2021 Local Oeste Software House. All rights reserved.
//

import UIKit
import FirebaseFirestore

class UsuariosViewController: UIViewController,
    UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableViewUsuarios: UITableView!
    @IBOutlet weak var searchBarUsuario: UISearchBar!
    var firestore: Firestore!
    var usuarios: [Dictionary<String, Any>] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firestore = Firestore.firestore()
        self.searchBarUsuario.delegate = self
        
        //********* Esconde o teclado após toque na tela  *************
        self.hideKeyboardWhenTappedAround()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CadastroViewController.dismissKeyboard)))
        //*************************************************************
        
        
        
    }
    
    //Esconde o teclado após toque na tela
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetalhesAbordadosViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        recuperarUsuarios()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            recuperarUsuarios()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let textoPesquisa = searchBar.text {
            if textoPesquisa != "" {
                pesquisarUsuarios(texto: textoPesquisa)
            }
        }
        
    }
    
    func pesquisarUsuarios(texto: String){
        
        let listaFiltro: [Dictionary<String, Any>] = self.usuarios
        self.usuarios.removeAll()
        
        for item in listaFiltro {
            if let nome = item["nome"] as? String {
                if nome.lowercased().contains(texto.lowercased()){
                    self.usuarios.append(item)
                }
            }
        }
        
        self.tableViewUsuarios.reloadData()
        
    }
    
    func recuperarUsuarios(){
        
        //Limpa listagem de postagens
        self.usuarios.removeAll()
        self.tableViewUsuarios.reloadData()
        
        firestore.collection("usuarios").getDocuments { (snapshotResultado, erro) in
            
            if let snapshot = snapshotResultado {
                for document in snapshot.documents {
                    let dados = document.data()
                    self.usuarios.append(dados)
                }
                self.tableViewUsuarios.reloadData()
            }
            
        }
        
        
    }
    
    /*Métodos para listagem na tabela*/
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "celulaUsuario", for: indexPath)
        
        let indice = indexPath.row
        let usuario = self.usuarios[indice]
        
        let nome = usuario["nome"] as? String
        let email = usuario["email"] as? String
        
        celula.textLabel?.text = nome
        celula.detailTextLabel?.text = email
        
        return celula
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableViewUsuarios.deselectRow(at: indexPath, animated: true)
        
        let indice = indexPath.row
        let usuario = self.usuarios[indice]
        
        self.performSegue(withIdentifier: "segueGaleria", sender: usuario)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueGaleria" {
            let viewDestino = segue.destination as! GaleriaCollectionViewController
            
            viewDestino.usuario = sender as? Dictionary
            
        }
        
    }
    
    
}
