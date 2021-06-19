//
//  HomeViewController.swift
//  Mikegram
//
//  Created by Iranildo Carlos da Silva on 15/03/21.
//  Copyright © 2021 Local Oeste Software House. All rights reserved.
//
import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class AbordadosViewController: UIViewController,
                               UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tableViewUsuarios: UITableView!
    @IBOutlet weak var searchBarUsuario: UISearchBar!
    
    
    
    
    var firestore: Firestore!
    var usuarios: [Dictionary<String, Any>] = []
    var idUsuarios: [Dictionary<String, Any>] = []
    var auth: Auth!
    var urlIagem :  String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = Auth.auth()
        firestore = Firestore.firestore()
        self.searchBarUsuario.delegate = self
        
        //Long Press
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 1.0
        self.tableViewUsuarios.addGestureRecognizer(longPressGesture)
        
        
        //********* Esconde o teclado após toque na tela  *************
        self.hideKeyboardWhenTappedAround()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CadastroViewController.dismissKeyboard)))
        //*************************************************************
        
    }
    
    
    
    //Esconde o teclado após toque na tela
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CadastroViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        recuperarAbordadosDia()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            recuperarAbordadosDia()
        }else{
            recuperarAbordados()
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
            
            
            if let documento = item["documento"] as? String {
                if documento.lowercased().contains(texto.lowercased()){
                    self.usuarios.append(item)
                }
            }
        }
        
        
        self.tableViewUsuarios.reloadData()
        
    }
    
    func recuperarAbordados(){
        
        //Limpa listagem de postagens
        self.usuarios.removeAll()
        self.tableViewUsuarios.reloadData()
        
        if let usuarioLogado = self.auth.currentUser{
            
            firestore.collection("abordados").document(usuarioLogado.uid).collection("meus_abordados").getDocuments { (snapshotResultado, erro) in
                
                if let snapshot = snapshotResultado {
                    for document in snapshot.documents {
                        let documentID = ["id": document.documentID]
                        //   var dad = [document.data() , ]
                        var dados =  document.data()
                        dados["id"] = document.documentID
                        self.idUsuarios.append(documentID)
                        self.usuarios.append(dados)
                       
                    }
                    self.tableViewUsuarios.reloadData()
                }
                
            }
            
            
        }
        
    }
    
    func recuperarAbordadosCompartilhados(){
        
        //Limpa listagem de postagens
        self.usuarios.removeAll()
        self.tableViewUsuarios.reloadData()
        
        if let usuarioLogado = self.auth.currentUser{
            
            firestore.collection("abordados").document().collection("meus_abordados").getDocuments { (snapshotResultado, erro) in
                
                if let snapshot = snapshotResultado {
                    for document in snapshot.documents {
                        let documentID = ["id": document.documentID]
                        //   var dad = [document.data() , ]
                        var dados =  document.data()
                        dados["id"] = document.documentID
                        self.idUsuarios.append(documentID)
                        self.usuarios.append(dados)
                       
                        
                    }
                    self.tableViewUsuarios.reloadData()
                }
                
            }
            
            
        }
        
    }

    
    func recuperarAbordadosDia(){
        
        //Data Formatada
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "dd-MM-yyy"
        let formattedDate = format.string(from: date)
        
        //Limpa listagem de postagens
        self.usuarios.removeAll()
        self.tableViewUsuarios.reloadData()
        
        
        
        if let usuarioLogado = self.auth.currentUser{
            
            firestore.collection("abordados").document(usuarioLogado.uid).collection("meus_abordados").getDocuments { (snapshotResultado, erro) in
                
                if let snapshot = snapshotResultado {
                    for document in snapshot.documents {
                        if let dataDaAbordagem = document["dataAbordagem"] as? String{
                            
                            if dataDaAbordagem == formattedDate{
                                
                                let documentID = ["id": document.documentID]
                                var dados =  document.data()
                                dados["id"] = document.documentID
                                self.idUsuarios.append(documentID)
                                self.usuarios.append(dados)
                               
                                
                            }
                            
                        }
                        
                        
                    }
                    self.tableViewUsuarios.reloadData()
                }
                
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
        let indentificador = self.idUsuarios[indice]
        
        
        
        if let nome = usuario["nome"] as? String{
            if let documento = usuario["documento"] as? String{
                if  let dataAbordagem = usuario["dataAbordagem"] as? String{
                    if let artigo = usuario["artigos"] as? String{
                        
                        if let url = usuario["url"] as? String {
                            self.urlIagem = url
                            
                            if url != nil {
                                
                                if let id = indentificador["id"] as? String{
                                    
                                    
                                    
                                    celula.imageView?.isHidden = false
                                    celula.imageView!.sd_setImage(with: URL(string: url), completed: nil)
                                    celula.imageView!.layer.borderWidth = 1
                                    celula.imageView!.layer.masksToBounds = true
                                    celula.imageView!.layer.borderColor = UIColor.black.cgColor
                                    celula.imageView!.layer.cornerRadius = celula.imageView!.frame.height/4
                                    celula.imageView!.clipsToBounds = true
                                    
                                    
                                    celula.textLabel?.text = "\(nome) - crim.: \(artigo) "
                                    celula.detailTextLabel?.text = "Doc.: \(documento) - abordado \(dataAbordagem) - \(id) "
                                    
                                    return celula
                                    self.tableViewUsuarios.reloadData()
                                    
                                }else{
                                    celula.imageView?.isHidden = false
                                    celula.imageView!.sd_setImage(with: URL(string: url), completed: nil)
                                    celula.imageView!.layer.borderWidth = 1
                                    celula.imageView!.layer.masksToBounds = true
                                    celula.imageView!.layer.borderColor = UIColor.black.cgColor
                                    celula.imageView!.layer.cornerRadius = celula.imageView!.frame.height/4
                                    celula.imageView!.clipsToBounds = true
                                    
                                    
                                    celula.textLabel?.text = "\(nome) - crim.: \(artigo) "
                                    celula.detailTextLabel?.text = "Doc.: \(documento) - abordado \(dataAbordagem) "
                                    
                                    return celula
                                    self.tableViewUsuarios.reloadData()
                                    
                                }
                                
                               
                            }else{
                                celula.imageView?.isHidden = true
                            }
                            
                        }else{
                            
                            celula.textLabel?.text = "\(nome) - crim.: \(artigo) "
                            celula.detailTextLabel?.text = "Doc.: \(documento) - abordado \(dataAbordagem)"
                            
                            return celula
                            self.tableViewUsuarios.reloadData()
                        }
                        
                    }
                    
                    
                }
                
            }
            
        }
        
        
        
        return celula
        self.tableViewUsuarios.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableViewUsuarios.deselectRow(at: indexPath, animated: true)
        
        let indice = indexPath.row
        let abordado = self.usuarios[indice]
        let identificador = self.idUsuarios[indice]
        let dados = (abordado,  identificador)
        
       
        
        self.performSegue(withIdentifier: "segueDetalhesAbordado", sender: abordado)
        
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueDetalhesAbordado" {
            let viewDestino = segue.destination as! DetalhesAbordadosViewController
            
            viewDestino.abordado = sender as? Dictionary
          
            
        }
        
    }
    
  
    
    
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.tableViewUsuarios)
        let indexPath = self.tableViewUsuarios.indexPathForRow(at: p)
        if indexPath == nil {
            print("Long press on table view, not row.")
        } else if longPressGesture.state == UIGestureRecognizer.State.began {
            
            let indice = indexPath!.row
            let abordado = self.usuarios[indice]
            let indentificador = self.idUsuarios[indice]
            
            if let nome = abordado["nome"] as? String{
                if let idDeletar = indentificador["id"] as? String{
                    
                    let alerta = UIAlertController(title: "Excluir !", message: "Deseja excluir o registro \(nome)", preferredStyle: .alert)
                    
                    
                    let acaoCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                    
                    let acaoConfirmar = UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
                        print("Excluido registro")
                        self.excluirAbordado(abordado: abordado, idDeletar: idDeletar)
                        
                    })
                    
                    alerta.addAction(acaoConfirmar)
                    alerta.addAction(acaoCancelar)
                    self.present(alerta, animated: true, completion: nil)
                    
                    
                }
            }else{
                let alerta = UIAlertController(title: "Excluir !", message: "Deseja excluir o registro", preferredStyle: .alert)
                //Cria as ações para a caixa de alerta
                let acaoCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                
                let acaoConfirmar = UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
                    print("Excluir registro")
                    if let idDeletar = indentificador["id"] as? String{
                        
                        self.excluirAbordado(abordado: abordado, idDeletar:  idDeletar)
                    }
                })
                
                
                alerta.addAction(acaoCancelar)
                alerta.addAction(acaoConfirmar)
                self.present(alerta, animated: true, completion: nil)
            }
            
            
            
        }
    }
    
    
    
    func excluirAbordado(abordado: [String:Any], idDeletar: String )  {
        
        
        let storage = Storage.storage()
        if let usuarioLogado = self.auth.currentUser{
            
            if let id = idDeletar as? String{
                
                if urlIagem != nil && urlIagem != ""{
                    let storageRef = storage.reference(forURL: urlIagem)
                    //Removes image from storage
                    storageRef.delete { error in
                        if let error = error {
                            print(error)
                        } else {
                            print("Deletado foto com sucesso...")
                        }
                    }
                }
                firestore.collection("abordados").document(usuarioLogado.uid).collection("meus_abordados").document(id).delete(){err in
                    print("entrou no firestore \(err)")
                    self.usuarios.removeAll()
                    self.tableViewUsuarios.reloadData()
                    
                    
                }
                
            }
            
            
            
        }
        
        
        
    }
    
    
    
    
}

