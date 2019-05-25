//
//  FormPesquisaViewController.swift
//  fip
//
//  Created by IOS SENAC on 25/05/19.
//  Copyright © 2019 IOS SENAC. All rights reserved.
//

import UIKit

class FormPesquisaViewController: UIViewController {
    
    var veiculo: Veiculos = .carros
    
    @IBOutlet weak var lblTipoVeiculo: UILabel!
    
    var veiculos: [Veiculo] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNewVeiculo()
        
        //MainViewController.pre
        self.lblTipoVeiculo.text = veiculo.rawValue
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Funcao que configura web service
    func loadNewVeiculo()
    {
        // Criando configuracao da sessao
        let configuration = URLSessionConfiguration.default
        
        //Alterando propriedades da configuracao
        configuration.waitsForConnectivity = true
        //Criando sessao de configuracao
        let session = URLSession(configuration: configuration)
        let url = URL(string: "http://fipeapi.appspot.com/api/1/\(veiculo.rawValue)")!
        let task = session.dataTask(with: url)
        {(data, response, error) in
            
            //Quando terminar de executar o request cai aqui
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
                else{
                    return
            }
            
            guard let data = data
                else {
                    return
            }
            
            if let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
            {
                print(result)
            }
            do
            {
                let decoder = JSONDecoder()
                let veiculos = try decoder.decode([Veiculo].self, from: data)
                DispatchQueue.main.async{
                    self.veiculos = veiculos
                }
            }catch{
                print("Error\(error)")
            }
            
            
        }
        task.resume()
    }
    
    
    
    
}


struct Veiculo: Codable {
    let nome: String
    let fipeNome: String?
    let id: Int
    
    
    private enum CodingKeys : String, CodingKey
    {
        case nome = "name", fipeNome = "fipe_name", id
    }
}






