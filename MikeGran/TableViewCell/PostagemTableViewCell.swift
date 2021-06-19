//
//  HomeViewController.swift
//  Mikegram
//
//  // Created by Iranildo Carlos da Silva on 15/03/21.
//  Copyright © 2021 Local Oeste Software House. All rights reserved.
//

import UIKit

class PostagemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nomePostagem: UILabel!
    @IBOutlet weak var fotoPostador: UIImageView!
    @IBOutlet weak var descricaoPostagem: UILabel!
    @IBOutlet weak var fotoPostagem: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
