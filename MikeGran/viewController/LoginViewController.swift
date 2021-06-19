//
//  HomeViewController.swift
//  Mikegram
//
//  Created by Iranildo Carlos da Silva on 15/03/21.
//  Copyright © 2021 Local Oeste Software House. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class LoginViewController: UIViewController {
    
    @IBOutlet weak var campoEmail: UITextField!
    @IBOutlet weak var campoSenha: UITextField!
    var auth: Auth!
    var firestore : Storage!

    override func viewDidLoad() {
        super.viewDidLoad()

        auth = Auth.auth()
        firestore = Storage.storage()
        
        auth.addStateDidChangeListener { (autenticacao, usuario) in
            if usuario != nil {
               self.performSegue(withIdentifier: "segueLoginAutomatico", sender: nil)
            }else{
                print("Usuário não está logado!")
            }
        }
        
        
        //********* Esconde o teclado após toque na tela  *************
        self.hideKeyboardWhenTappedAround()

            self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard)))
        //*************************************************************
        
        
        
        
    }
    
    //Esconde o teclado após toque na tela
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
        
        do {
            try auth.signOut()
        } catch {
            print("Erro ao deslogar usuário!")
        }
        
    }
    
    @IBAction func logar(_ sender: Any) {
        
        if let email = campoEmail.text {
            if let senha = campoSenha.text {
                
                auth.signIn(withEmail: email, password: senha) { (usuario, erro) in
                    if erro == nil {
                        
                        if usuario == nil{
                             
                             let alerta = UIAlertController(title: "Atenção! ", message: "não existe conta cadastrada com esse mail ou conta foi encerrada", preferredStyle: .alert)
                             
                             let acaoAlerta = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                             alerta.addAction(acaoAlerta)
                             self.present(alerta, animated: true, completion: nil)
                        
                     }
                  }else{
                    
                    if let mensagemErro = erro?.localizedDescription{
                        
                        
                        if mensagemErro.contains("no user record"){
                            
                            
                            let alerta = UIAlertController(title: "Atenção! ", message: "não existe conta cadastrada com esse mail ou conta foi encerrada" , preferredStyle: .alert)
                            
                            let acaoAlerta = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alerta.addAction(acaoAlerta)
                            self.present(alerta, animated: true, completion: nil)
                            
                        }
                        else if(mensagemErro.contains("The password is invalid")){
                            
                            let alerta = UIAlertController(title: "Atenção! ", message: "Erro senha" , preferredStyle: .alert)
                            
                            let acaoAlerta = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alerta.addAction(acaoAlerta)
                            self.present(alerta, animated: true, completion: nil)
                            
                        }
                        
                    }
                
                 }
                    
              }
                
            }else{
                let alerta = UIAlertController(title: "Atenção! ", message: "Preencha e-mail" , preferredStyle: .alert)
                
                let acaoAlerta = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alerta.addAction(acaoAlerta)
                self.present(alerta, animated: true, completion: nil)
            }
        }else{
            let alerta = UIAlertController(title: "Atenção! ", message: "Preencha a senha" , preferredStyle: .alert)
            
            let acaoAlerta = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alerta.addAction(acaoAlerta)
            self.present(alerta, animated: true, completion: nil)
        }
            
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

}
