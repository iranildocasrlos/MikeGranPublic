//
//  HomeViewController.swift
//  Mikegram
//
//  Created by Iranildo Carlos da Silva on 15/03/21.
//  Copyright © 2021 Local Oeste Software House. All rights reserved.
//
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class CadastroViewController: UIViewController {
    
    @IBOutlet weak var campoNome: UITextField!
    @IBOutlet weak var campoEmail: UITextField!
    @IBOutlet weak var campoSenha: UITextField!
    @IBOutlet weak var campoRE: UITextField!
    @IBOutlet weak var campoPadrinho: UITextField!
    
    
    
    var auth: Auth!
    var firestore: Firestore!
    var storage : Storage!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        auth = Auth.auth()
        firestore = Firestore.firestore()
        storage = Storage.storage()
        
        
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
    
    
    @IBAction func cadastrar(_ sender: Any) {
        
        if let nome = campoNome.text {
            if let email = campoEmail.text {
                if let senha = campoSenha.text {
                    if let re = campoRE.text{
                        if let padrinho = campoPadrinho.text{
                            
                            auth.createUser(withEmail: email, password: senha) { (dadosResultado, erro) in
                                if erro == nil {
                                    
                                    if let idUsuario = dadosResultado?.user.uid {
                                        //salvar dados do usuário
                                        self.firestore.collection("usuarios")
                                        .document( idUsuario )
                                        .setData([
                                            "nome": nome,
                                            "email": email,
                                            "id": idUsuario,
                                            "re": re,
                                            "validado": false,
                                            "padrinho": padrinho,
                                            "urlFotoPerfil": ""
                                        ]){ err in
                                            if let err = err {
                                                print("Error writing document: \(err)")
                                            } else {
                                                print("Document successfully written!")
                                            }
                                    }
                                    
                                    
                                    
                                }else{
                                    print("Erro ao cadastrar usuario")
                                }
                            }
                            
                        }
                            
                        }else{
                            print("Preencha o campo Padrinho")
                        }
                        
                    }else{
                        print("Preencha o RE")
                        
                    }
                    
                }else{
                    print("Preencha a senha")
                }
            }else{
                print("Preencha o email")
            }
        }else{
            print("Preencha o nome")
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func salvarFotoPerfil(){
        if let usuarioPerfil = auth.currentUser?.uid{
            let imageAmPerfil = storage.reference()
                .child("imagens")
            
            
            let imagemSelecionada = UIImage(named: "pessoa")
            
            if let imagemUpload = imagemSelecionada?.jpegData(compressionQuality: 0.3) {
                
               // let identificadorUnico = UUID().uuidString
                let identificadorUnico = usuarioPerfil
                
                let imagemPostagemRef = imageAmPerfil
                .child(usuarioPerfil)
                .child("\(identificadorUnico).jpg")
            
            imagemPostagemRef.putData(imagemUpload, metadata: nil){ (metaData, erro) in
                    if erro == nil {
                        
                        imagemPostagemRef.downloadURL { [self] (url, erro) in
                            if let urlImagem = url?.absoluteString {
                                
                                   
                                          
                                }
                            }
                        }
                    }
                }
            }
            
            
            
    }

}
