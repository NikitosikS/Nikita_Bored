// Name: Nikita Sushko
// ID: 105075196

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lblOutput: UILabel!
    
    @IBOutlet weak var anotherActivityBtn: UIButton!
    
    @IBOutlet weak var addFavoriteBtn: UIButton!
    
    @IBOutlet weak var allFavoriteBtn: UIButton!
    
    var output = ""
    let url = "https://www.boredapi.com/api/activity"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var models = [ActivityItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        anotherActivityBtn.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        anotherActivityBtn.layer.cornerRadius = 15.0
        anotherActivityBtn.tintColor = UIColor.white
        
        addFavoriteBtn.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        addFavoriteBtn.layer.cornerRadius = 15.0
        addFavoriteBtn.tintColor = UIColor.white
        
        allFavoriteBtn.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        allFavoriteBtn.layer.cornerRadius = 15.0
        allFavoriteBtn.tintColor = UIColor.white
        
        getData(from: url)
    }

    @IBAction func anotherActivityClick(_ sender: Any) {
        getData(from: url)
    }
    @IBAction func addActivityClick(_ sender: Any) {
        self.createItem(saveActivity: lblOutput.text!)
    }
    @IBAction func changeView(_ sender: Any) {
        self.getAllItems()
        let vc = storyboard?.instantiateViewController(identifier: "table_vc") as! TableViewController
        present(vc, animated: true)
    }
    
    private func getData(from url: String) {
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
            
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            
            //have data
            var result: Response?
            do {
                result = try JSONDecoder().decode(Response.self, from: data)
            }
            catch {
                print("failed to convert \(error.localizedDescription)")
            }
            
            guard let json = result else {
                return
            }
            
            self.output = json.activity
            
            DispatchQueue.main.async {
                self.lblOutput.text = self.output
            }
        })
        task.resume()
    }
    
    
    
    
    // Core Data
    func createItem(saveActivity: String){
        let newItem = ActivityItem(context: context)
        newItem.activity = saveActivity
        newItem.createdAt = Date()
        
        do {
            try context.save()
            getAllItems()
            print("Successfully Saved")
        }
        catch {
            
        }
    }
    
    // Core Data
    func getAllItems(){
        do {
            models = try context.fetch(ActivityItem.fetchRequest())
        }
        catch {
            // error
        }
    }
    
    func deleteItem(item: ActivityItem) {
        context.delete(item)
        
        do {
            try context.save()
        }
        catch {
            
        }
    }
}
struct Response: Codable {
    public let activity: String!
}


/*
 {
   "activity": "Take a bubble bath",
   "type": "relaxation",
   "participants": 1,
   "price": 0.15,
   "link": "",
   "key": "2581372",
   "accessibility": 0.1
 }
*/
