//
//  HomeViewController.swift
//  Mikegram
//
//  Created by Iranildo Carlos da Silva on 15/03/21.
//  Copyright © 2021 Local Oeste Software House. All rights reserved.
//
import Foundation
import UIKit
import FirebaseFirestore
import FirebaseUI
import FirebaseAuth


class DetalhesAbordadosViewController: UIViewController{
    
    
    @IBOutlet weak var imagemPesquisado: UIImageView!
    
 
    
    @IBOutlet weak var campoDocumento: UITextField!
    
    @IBOutlet weak var campoDataNasc: UITextField!
    
    @IBOutlet weak var campoNomeMae: UITextField!
    
    @IBOutlet weak var campoNomePai: UITextField!
    
    @IBOutlet weak var campoArtigos: UITextField!
    
    
    @IBOutlet weak var tipoDocumento: UILabel!
    
    
    
    var abordado: Dictionary<String, Any>!
    var dados: [Dictionary<String, Any>]=[]
    var indentificador: Dictionary<String, Any>!
    var firestore: Firestore!
    var auth: Auth!
    var postagens: [Dictionary<String, Any>] = []
    var idUsuarioSelecionado: String!
//    var id = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        firestore = Firestore.firestore()
        
        auth = Auth.auth()
        
        if let id = abordado["id"] as? String {
            idUsuarioSelecionado = id
        }
        
        if let nome  = abordado["nome"] as? String{
            self.navigationItem.title = nome
            
            
        }
        
        
        if let documento = abordado["documento"] as? String {
            campoDocumento.text = documento
        }
        
        if let nascimento = abordado["data_nascimento"] as? String {
            campoDataNasc.text = nascimento
        }
        
        if let nomeMae = abordado["mae"] as? String {
            campoNomeMae.text = nomeMae
        }
        
        if let pai = abordado["pai"] as? String {
            campoNomePai.text = pai
        }
        if let artigo = abordado["artigos"] as? String {
            campoArtigos.text = artigo
        }
        if let url = abordado["url"] as? String {
            imagemPesquisado!.sd_setImage(with: URL(string: url), completed: nil)
            imagemPesquisado!.contentMode = .scaleAspectFit
        }
        if let textoTipoDocumento = abordado["tipoAbordado"] as? String {
            tipoDocumento.text = textoTipoDocumento
        }
//        if let idAbordado = indentificador["id"] as? String{
//            id = idAbordado
//        }
        
        
        
  //      ********* Esconde o teclado após toque na tela  *************
        self.hideKeyboardWhenTappedAround()

            self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(DetalhesAbordadosViewController.dismissKeyboard)))
//        *************************************************************
        
        
}
    
    
    
  
    @IBAction func botoEditar(_ sender: Any) {
        if let nome =  abordado["nome"] as? String {
            
            
       
        if let documento = self.campoDocumento.text {
            if let dataNascimmento = self.campoDataNasc.text {
                if let nomeMae = self.campoNomeMae.text {
                    if let nomePai = self.campoNomePai.text {
                        if let artigo = self.campoArtigos.text {
        
        if let usuarioLogado = self.auth.currentUser{
            firestore.collection("abordados").document(usuarioLogado.uid).collection("meus_abordados").document(idUsuarioSelecionado).updateData(
                ["nome" : nome,                                                                                                              "documento" : documento,
                       "data_nascimento" : dataNascimmento,
                       "mae" : nomeMae,
                       "pai" : nomePai,
                       "artigos" : artigo])
            
            {err in


                            }
            
            let alerta = UIAlertController(title: "Editar !", message: "Alteração efetuadda com Sucesso \(nome)", preferredStyle: .alert)
            
            let acaoConfirmar = UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
                print("Excluido registro")
                
                
            })
            
            alerta.addAction(acaoConfirmar)
            
            self.present(alerta, animated: true, completion: nil)

                          }
                            
                            
                        }
                    }
                }
            }
        }
        }
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
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    
    
    
}


