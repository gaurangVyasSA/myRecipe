//
//  AddRecipeViewController.swift
//  My Recipes
//
//  Created by Gaurang Vyas on 29/08/19.
//  Copyright © 2019 Gaurang Vyas. All rights reserved.
//

import UIKit
import Moya
import Toaster

class AddRecipeViewController: UITableViewController {
    
    private struct IngredientInfo {
        let ingredient: String
        let recipeId: Int
    }
    
    private struct InstructionInfo {
        let instruction: String
        let recipeId: Int
    }
    
    private enum CellIndex: Int {
        case recipeName = 0
        case recipePhoto
        case duration
        case complexity
        case servers
        case ingredients
        case instuction
    }
    
    @IBOutlet weak var servesStepper: UIStepper!
    @IBOutlet weak var lblServes: UILabel!
    @IBOutlet weak var lblNoOfServes: UILabel!
    var recipeId: Int?
    private var recipeName: String?
    private var duration: String?
    private var complexityIndex: Int = 0
    private var serves: Double = 1
    private var recipePhoto: UIImage?
    private var ingredients: [IngredientInfo] = []
    private var instuction: [InstructionInfo] = []
    private var selectedIndex: CellIndex?
    private var complexityArray = [Strings.easy, Strings.medium, Strings.complex]
    private var indicator: IndicatorView!
    
    private let recipeProvider = MoyaProvider<ReceipesServices>(plugins: [NetworkLoggerPlugin(verbose: true)])

    override func viewDidLoad() {
        super.viewDidLoad()
        title = ViewControllerTitle.addRecipe
        navigationItem.backBarButtonItem = UIBarButtonItem()
        prepareUI()
    }
    
    private func prepareUI(){
        let btnSave = UIBarButtonItem(title: Strings.save, style: .plain, target: self, action: #selector(saveTapped))
        navigationItem.rightBarButtonItem = btnSave
        lblServes.setTextLabelStyle()
        lblServes.text = Strings.serves
        lblNoOfServes.setSmallGrayStyle()
        servesStepperValueChanged()
        indicator = IndicatorView(view: navigationController!.view)
    }
    
}

//MARK: - UITableview dataSource and delegate methods

extension AddRecipeViewController {
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        switch CellIndex(rawValue: indexPath.row) ?? .recipeName {
        case .recipeName:
            cell.textLabel?.text = Strings.recipeName
            if recipeName == nil{
                cell.accessoryType = .disclosureIndicator
            }else{
                let label = UILabel()
                label.setSmallGrayStyle()
                label.text = recipeName
                label.sizeToFit()
                cell.accessoryView = label
            }
            
        case .recipePhoto:
            cell.textLabel?.text = Strings.recipePhoto
            if recipePhoto == nil{
                cell.accessoryType = .disclosureIndicator
            }else{
                let label = UILabel()
                label.setSmallGrayStyle()
                label.text = Strings.selected
                label.sizeToFit()
                cell.accessoryView = label
            }
            
        case .duration:
            cell.textLabel?.text = Strings.duration
            if duration == nil{
                cell.accessoryType = .disclosureIndicator
            }else{
                let label = UILabel()
                label.setSmallGrayStyle()
                label.text = Strings.selected
                label.sizeToFit()
                cell.accessoryView = label
            }
            
        case .complexity:
            cell.textLabel?.text = Strings.complexity
            let segment = UISegmentedControl(items: complexityArray)
            segment.sizeToFit()
            segment.selectedSegmentIndex = complexityIndex
            segment.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
            cell.accessoryView = segment
            
        case .servers:
            break
            
        case .ingredients:
            cell.textLabel?.text = Strings.ingredints
            cell.accessoryType = .disclosureIndicator
            
        case .instuction:
            cell.textLabel?.text = Strings.instruction
            cell.accessoryType = .disclosureIndicator
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let isSaved = recipeId != nil
        
        let index = CellIndex(rawValue: indexPath.row) ?? .recipeName
       
        switch index {
        case .recipeName, .duration, .servers, .complexity:
            return UITableView.automaticDimension
        default:
            return isSaved ? 44 : 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedIndex = CellIndex(rawValue: indexPath.row)
        
        switch selectedIndex ?? .recipeName {
        case .recipeName:
            presentInputAlertView(title: Messages.enterRecipeName) { value in
                self.recipeName = value
                self.tableView.reloadData()
            }
            break
        case .recipePhoto:
            openImageSelection()
            break
        case .duration:
            presentInputAlertView(title: Messages.enterDuration) { value in
                self.duration = value
                self.tableView.reloadData()
            }
            break
        case .complexity:
            break
        case .servers:
            break
        case .ingredients:
            let intance = RecipeIngredientsVC.instance
            intance.recipeId = recipeId
            navigationController?.pushViewController(intance, animated: true)
            break
        case .instuction:
            let intance = RecipeInstructionVC.instance
            intance.recipeId = recipeId
            navigationController?.pushViewController(intance, animated: true)
            break
        }
        
    }
}

// MARK: - Selectors
extension AddRecipeViewController{
    @IBAction func servesStepperValueChanged(){
        let people = Int(servesStepper.value)
        lblNoOfServes.text = "\(people) \(people == 1 ? "People" : "Peoples")"
    }
    
    @objc func segmentValueChanged(_ sender:UISegmentedControl){
        complexityIndex = sender.selectedSegmentIndex
    }
    
    @objc func saveTapped(){
        let params: [String:Any] = [WSParams.name: recipeName ?? "",
                                    WSParams.preparationTime: duration ?? "",
                                    WSParams.serves: Int(serves),
                                    WSParams.complexity: complexityArray[complexityIndex]]
        indicator.startAnimation()
        recipeProvider.request(.add(params: params)) { result in
            self.indicator.stopAnimation()
            switch result{
            case let .success(response):
                do{
                    struct Response: Codable {
                        let msg: String?
                        let id: Int?
                    }
                    let info = try JSONDecoder().decode(Response.self, from: response.data)
                    if let message = info.msg{
                        Toast(text: message).show()
                    }
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                    self.recipeId = info.id
                    print(info)
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                }catch let error{
                    print(error)
                }
                break
            case let .failure(error):
                print("failure",error)
                break
            }
        }
    }
    
    private func setRecipeImage(){
        guard let photo = recipePhoto, let recipeId = recipeId else {
            return
        }
        indicator.startAnimation()
        recipeProvider.request(.addRecipePhoto(recipeId: recipeId, photo: photo)) { result in
            self.indicator.stopAnimation()
            switch result{
            case let .success(response):
                do{
                    struct Response: Codable {
                        let msg,photo: String?
                    }
                    let info = try JSONDecoder().decode(Response.self, from: response.data)
                    if let message = info.msg{
                        Toast(text: message).show()
                    }
                }catch let error{
                    print(error)
                }
                break
            case let .failure(error):
                print("failure",error)
                break
            }
        }
    }
}

extension AddRecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    private func openImageSelection(){
        let alert = UIAlertController(title: Messages.chooseImage, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Strings.camera, style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: Strings.gallery, style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: Strings.cancel, style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func openCamera()
    {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func openGallary()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            recipePhoto = image
            tableView.reloadData()
            setRecipeImage()
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}
