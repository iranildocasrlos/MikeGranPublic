//
//  PostagemViewController.swift
//  Mikegram
//
// Created by Iranildo Carlos da Silva on 15/03/21.
//  Copyright © 2021 Local Oeste Software House. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class PostagemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var descricao: UITextField!
    var imagePicker = UIImagePickerController()
    var storage: Storage!
    var auth: Auth!
    var firestore: Firestore!
    var urlFotoPerfil = ""
    var nomePostador = ""
    var idUsuario = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        storage = Storage.storage()
        auth = Auth.auth()
        firestore = Firestore.firestore()
        imagePicker.delegate = self
        
        
        
        if let usuarioLogado = self.auth.currentUser {
            self.idUsuario = usuarioLogado.uid
        
        //Pesquisa a foto do usuario
            self.pesquisarUsuario(id: self.idUsuario)
        }
        
        
        //********* Esconde o teclado após toque na tela  *************
        self.hideKeyboardWhenTappedAround()

            self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PostagemViewController.dismissKeyboard)))
        //*************************************************************
        
    }
    
    @IBAction func selecionarImagem(_ sender: Any) {
        
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imagemRecuperada = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        self.imagem.image = imagemRecuperada
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    
    //Esconde o teclado após toque na tela
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PostagemViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    
    @IBAction func salvarPostagemPublica(_ sender: Any) {
        //Formatando data para salvar
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "dd-MM-yyy HH:mm:ss"
        let formattedDate = format.string(from: date)
        
        let imagens = storage.reference()
        .child("imagens")
        
        let imagemSelecionada = self.imagem.image
        if let imagemUpload = imagemSelecionada?.jpegData(compressionQuality: 0.3) {
            
            let identificadorUnico = UUID().uuidString
            
            let imagemPostagemRef = imagens
            .child("postagens")
            .child("\(identificadorUnico).jpg")
            
            imagemPostagemRef.putData(imagemUpload, metadata: nil) { (metaData, erro) in
                if erro == nil {
                    
                    imagemPostagemRef.downloadURL { (url, erro) in
                        if let urlImagem = url?.absoluteString {
                            if let descricao = self.descricao.text {
                                
                                    self.firestore
                                        .collection("postagens")
                                    
                                    .addDocument(data: [
                                        "descricao" : descricao,
                                        "nomePostador": self.nomePostador,
                                        "url": urlImagem,
                                        "urlFotoPostador": self.urlFotoPerfil,
                                        "data":formattedDate,
                                        "idUsuario": self.idUsuario
                                    ]) { (erro) in
                                        if erro == nil {
                                            self.navigationController?.popViewController(animated: true)
                                        }
                                    }
                            }
                        }
                    }
                    
                    print("sucesso")
                }else{
                    print("Erro ao fazer upload")
                }
            }
            
        }
        
    }
    
    func pesquisarUsuario(id: String){
        
        firestore.collection("usuarios").document(id).getDocument { (documentSnapshot, error) in
            if let snapshot = documentSnapshot{
                if let documento = snapshot.data(){
                    
                        if let urlFoto = documento["urlFotoPerfil"] as? String{
                            
                            if urlFoto != ""{
                                
                                self.urlFotoPerfil = urlFoto
                              
                                
                            }
                            
                        }
                    if let nomePost = documento["nome"] as? String{
                        
                        if nomePost != ""{
                            
                            self.nomePostador = nomePost
                          
                            
                        }
                        
                    }
                        
                    
                }
            }
        }
        
        
    }
    
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
      
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

}
