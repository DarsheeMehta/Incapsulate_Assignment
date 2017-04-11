public class CodingProblem_Controller{

	//Output value
	public String outputValue;
	//Getter method for outputValue
	public String getoutputValue(){
        return outputValue;
    }

	//User Input
	public String userInput{get;set;}

	//To show Error
	public boolean pageMessage;
	//Getter method for pageMessage
	public boolean getpageMessage(){
        return pageMessage;
    }

	//Map to store data for the dishes for each time of the day
	public Map<String, Map<String, String>> mapDishes;

	//Constructor to initialize the map with the data for the dishes for each time of the day
    public CodingProblem_Controller() {
		mapDishes = new Map<String, Map<String, String>>();
		Map<String, String> tempMap = new Map<String, String>();
		
		tempMap.put('1', 'eggs');
		tempMap.put('2', 'toast');
		tempMap.put('3', 'coffee');
		tempMap.put('4', '');
		mapDishes.put('morning', tempMap);

		tempMap = new Map<String, String>();
		tempMap.put('1', 'steak');
		tempMap.put('2', 'potato');
		tempMap.put('3', 'wine');
		tempMap.put('4', 'cake');
		mapDishes.put('night', tempMap);
	}

	//Method to get the output based on the user input which is stored in variable userInput
	public PageReference getFood(){
		List<String> lstData = new List<String>();
		
		//to make input case insensitive and ignore whitespaces
		lstData = userInput.toLowerCase().deleteWhitespace().split(','); 

		String timeOfDay = lstData.remove(0);
		pageMessage = false;

		if(!lstData.isEmpty() && mapDishes.containsKey(timeOfDay)){
			//to get the output in the order: entrée, side, drink, desert
			lstData.sort(); 
			
			Map<String, String> foodMap = new Map<String, String>();
			foodMap = mapDishes.get(timeOfDay);
			system.debug(foodMap);

			Integer counter = 1;
			List<String> outputList = new List<String>();

			for(Integer i = 0; i < lstData.size(); i++){

				//Since there are no values beyond 4 and desert for breakfast is null
				if(foodMap.get(lstData[i]) == '' || !lstData[i].isNumeric() || 
					lstData[i] == '' || lstData[i] == null || Integer.valueOf(lstData[i]) > 4){
					outputList.add('error');
					break;
				}

				//to take into consideration the multiple orders for coffee in the morning 
				//and potatoes at night
				if(i != 0 && lstData[i] == lstData[i-1] && 
					((lstData[i] == '3' && timeOfDay == 'morning') ||
					(lstData[i] == '2' && timeOfDay == 'night'))){
					counter++;
					outputList.remove(outputList.size()-1);
					outputList.add(foodMap.get(lstData[i]) + '(x' + counter + ')');
				}
				//to make sure that only one order of each dish type is placed apart from 
				//coffee in the morning and potatoes at night
				else if(i != 0 && lstData[i] == lstData[i-1]){
					outputList.add('error');
					break;
				}
				else{
					counter = 1;
					outputList.add(foodMap.get(lstData[i]));
				}
			}
			outputValue = outputList.remove(0);
			for(String s: outputList){
				outputValue = outputValue + ', ' + s;
			}
		}
		else{
			pageMessage = true;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error, 'Input not in desired format!'));
		}
		return null;
	}
}