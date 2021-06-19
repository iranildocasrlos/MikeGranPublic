//
//  HomeViewController.swift
//  Mikegram
//
//  Created by Iranildo Carlos da Silva on 15/03/21.
//  Copyright © 2021 Local Oeste Software House. All rights reserved.
//
import UIKit
import Foundation
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class AddAbordadoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageAbordado: UIImageView!
   
    @IBOutlet weak var campoNome: UITextField!
    @IBOutlet weak var campoDocumento: UITextField!
    @IBOutlet weak var campoDataNasc: UITextField!
    @IBOutlet weak var campoMae: UITextField!
    @IBOutlet weak var campoPai: UITextField!
    @IBOutlet weak var campoArtigos: UITextField!
    @IBOutlet weak var botaoGravar: UIButton!
   
    @IBOutlet var progressBar: UIProgressView!
    let progress = Progress(totalUnitCount: 10)
    
    var imagePicker = UIImagePickerController()
    var storage: Storage!
    var auth: Auth!
    var firestore: Firestore!
    var tipoAbordado : String!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        storage = Storage.storage()
        auth = Auth.auth()
        firestore = Firestore.firestore()
        campoArtigos.text = "não Possui"
        tipoAbordado = "RG"
      
        
        
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
    
    
   
    
    @IBAction func imageAbordado(_ sender: Any) {
        
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imagemRecuperada = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        self.imageAbordado.image = imagemRecuperada
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func switchTipo(_ sender: UISwitch) {
        
        if sender.isOn == true {
           
            tipoAbordado = "RG"
            
        }else{
            
            tipoAbordado = "Matricula"
            
        }
        
    }
    
    
    
    @IBAction func salvarAbordado(_ sender: Any) {
       
        self.botaoGravar.isEnabled = false
        
        Timer.scheduledTimer(withTimeInterval: 1,  repeats: true){(timer) in
            guard self.progress.isFinished == false else{
                timer.invalidate()
                return
            }
            self.progressBar.isHidden = false
            self.progress.completedUnitCount +=  1
            let progressFloat = Float(self.progress.fractionCompleted)
           // self.progressBar.setProgress(10, animated: true)
            
        }
        
        
        
        //Formatando data para salvar
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "dd-MM-yyy"
        let formattedDate = format.string(from: date)
        
        
        
        let imageAbordado = storage.reference()
        .child("imagens")
        
        let imagemSelecionada = self.imageAbordado.image
        if let imagemUpload = imagemSelecionada?.jpegData(compressionQuality: 0.3) {
            
            let identificadorUnico = UUID().uuidString
            
            let imagemPostagemRef = imageAbordado
            .child("abordados")
            .child("\(identificadorUnico).jpg")
            
            imagemPostagemRef.putData(imagemUpload, metadata: nil) { (metaData, erro) in
                if erro == nil {
                    
                    imagemPostagemRef.downloadURL { [self] (url, erro) in
                        if let urlImagem = url?.absoluteString {
                            if let descricao = self.campoNome.text {
                                if let documento = self.campoDocumento.text {
                                    if let dataNascimmento = self.campoDataNasc.text {
                                        if let nomeMae = self.campoMae.text {
                                            if var nomePai = self.campoPai.text {
                                                if let artigo = self.campoArtigos.text {
                                if let usuarioLogado = self.auth.currentUser {
                                    
                                    let idUsuario = usuarioLogado.uid
                                    
                                    //Verifica se possui nome do pai registrado
                                    if nomePai == nil {
                                        nomePai = "não Registrado"
                                    }
                                    
                                    self.firestore
                                        .collection("abordados")
                                    .document(idUsuario)
                                    .collection("meus_abordados")
                                    .addDocument(data: [
                                    
                                        "nome" : descricao,
                                        "documento" : documento,
                                        "data_nascimento" : dataNascimmento,
                                        "mae" : nomeMae,
                                        "pai" : nomePai,
                                        "artigos" : artigo,
                                        "dataAbordagem": formattedDate,
                                        "tipoAbordado": self.tipoAbordado!,
                                        "url": urlImagem
                                    ]) { (erro) in
                                        if erro == nil {
                                            self.navigationController?.popViewController(animated: true)
                                        }else{
                                            self.botaoGravar.isEnabled = true
                                            
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
                    
                    print("sucesso")
                }else{
                    print("Erro ao fazer upload")
                }
            }
            
        }
        
    }
    
    
    
    
}
