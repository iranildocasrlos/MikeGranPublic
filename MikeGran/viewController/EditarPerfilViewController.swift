//
//  HomeViewController.swift
//  Mikegram
//
//  Created by Iranildo Carlos da Silva on 15/03/21.
//  Copyright © 2021 Local Oeste Software House. All rights reserved.
//
import Foundation
import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore


class EditarPerfilViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var imagePicker = UIImagePickerController()
    var storage : Storage!
    var firestore: Firestore!
    var auth: Auth!
    var urlIagem :  String!
    
   
    
    @IBOutlet weak var fotoPerfil: UIImageView!
    
    @IBOutlet weak var campoNomePerfil: UITextField!
    
    @IBOutlet weak var campoRePerfil: UITextField!
    

   
 
    override func viewDidLoad() {
        
        auth = Auth.auth()
        firestore = Firestore.firestore()
        storage = Storage.storage()
        imagePicker.delegate = self
        
        self.fotoPerfil?.isHidden = false
        self.fotoPerfil.layer.borderWidth = 1.0
        self.fotoPerfil.layer.masksToBounds = false
        self.fotoPerfil.layer.borderColor = UIColor.black.cgColor
        self.fotoPerfil.layer.cornerRadius = ((self.fotoPerfil.frame.size.width) / 2)
        self.fotoPerfil.clipsToBounds = true
        
        //********* Esconde o teclado após toque na tela  *************
        self.hideKeyboardWhenTappedAround()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CadastroViewController.dismissKeyboard)))
        //*************************************************************
        
        if let id = auth.currentUser?.uid as? String{
            
            pesquisarUsuario(id: id)
        }
        
        
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
    
    
    func pesquisarUsuario(id: String){
        
        firestore.collection("usuarios").document(id).getDocument { (documentSnapshot, error) in
            if let snapshot = documentSnapshot{
                if let documento = snapshot.data(){
                    if let nome = documento["nome"] as? String{
                        self.campoNomePerfil.text = nome
                        if let re = documento["re"] as? String{
                            self.campoRePerfil.text = re
                        }
                        if let urlFoto = documento["urlFotoPerfil"] as? String{
                            
                            if urlFoto != ""{
                                
                              
                                self.fotoPerfil.sd_setImage(with: URL(string: urlFoto), completed: nil)
                                
                            }
                            
                        }
                        
                    }
                }
            }
        }
        
        
    }
    
    
    
    @IBAction func camera(_ sender: Any) {
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imagemRecuperada = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        self.fotoPerfil.image = imagemRecuperada
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
   
    @IBAction func botaoEditarPerfil(_ sender: Any) {
        
        if let usuarioPerfil = auth.currentUser?.uid{
            let imageAmPerfil = storage.reference()
                .child("imagens")
            
            
            let imagemSelecionada = self.fotoPerfil.image
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
                                if let nome = self.campoNomePerfil.text {
                                    if let re = self.campoRePerfil.text {
                                       
                                        self.firestore
                                            .collection("usuarios")
                                        .document(usuarioPerfil)
                                        .updateData([
                                            "nome": nome,
                                            "re": re,
                                            "urlFotoPerfil": urlImagem
                                        ]) { (erro) in
                                            if erro == nil {
                                                self.navigationController?.popViewController(animated: true)
                                            }else{
                                                
                                                
                                            }
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    
}
