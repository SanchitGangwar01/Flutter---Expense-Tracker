import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
 import 'package:expense_tracker/models/expense.dart';  



final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget{
const NewExpense({super.key,required this.onAddExpense});

final void Function(Expense expense) onAddExpense; //making function as value



@override
State<NewExpense> createState() {
  return _NewExpenseState();

}
}
 
class _NewExpenseState extends State<NewExpense>{
final _titleController = TextEditingController();
final _amountController = TextEditingController();
DateTime?_selectedDate ;
Category _selectedCategory = Category.leisure;

void _presentDatePicker() async {
final now = DateTime.now();
final finalDate = DateTime(now.year-1,now.month,now.day);

 final pickedDate= await showDatePicker(
  context: context, initialDate:now , firstDate: finalDate, lastDate: now,
  );


setState(() {
  _selectedDate = pickedDate;
});
}

 
 void _submitExpenseData(){
  final enteredAmount = double.tryParse(_amountController.text);
  final amountISInvalid = enteredAmount==null || enteredAmount<=0 ;



  if (_titleController.text.trim().isEmpty || amountISInvalid || _selectedDate==null){
    //show error message  
    showDialog(context: context, builder:(ctx)=> AlertDialog(
      title: const Text('invalid input'),
      content: const Text('Please make sure a valid data should be entered'),
      actions: [
        TextButton(
          onPressed:(){  
          Navigator.pop(ctx);

          }, child: const Text('okay'),
          ),
           ],
          ),
          );
          return;
        }
      widget.onAddExpense(Expense(title: _titleController.text, amount:enteredAmount , date: _selectedDate!, category:_selectedCategory));
     Navigator.pop(context);
 
 }


@override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }
 

@override
Widget build(BuildContext context){
 final keyobardSpace = MediaQuery.of(context).viewInsets.bottom;
   return LayoutBuilder(builder: (ctx,Constraints){
    final width = Constraints.maxWidth;
    
     return SizedBox(
    height: double.infinity,
    child: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16,16,16,keyobardSpace+16),
        child:Column(
          children:[
           if (width>=600)
           Row(
            crossAxisAlignment:CrossAxisAlignment.start ,
            children: [
            Expanded(
              child: TextField(
              controller:_titleController, // save the data in the controller for the new data you have to create a new controller
                maxLength: 50,
              decoration: const InputDecoration(
                label:Text('title'),
                ),
                    
              ),
            ),
            const SizedBox(width:24) ,
             Expanded(
              child: TextField(
            controller:_amountController, 
            keyboardType: TextInputType.number ,
              maxLength: 50,
            decoration: const InputDecoration(
              prefixText: '\$ ' ,
              label:Text('Amount'),
              ),
           ),
            ),            
           ],) 
           else

            TextField(
            controller:_titleController, // save the data in the controller for the new data you have to create a new controller
              maxLength: 50,
            decoration: const InputDecoration(
              label:Text('title'),
              ),
      
            ),
           if (width>=600)
           Row(children: [
                       DropdownButton(
            value: _selectedCategory,
            items:Category.values.map(
            (Category) => DropdownMenuItem(    
              value: Category  ,
              child: Text(
                Category.name.toUpperCase() ,
            ),
            ),
            ).toList(), 
            onChanged: (value){
              if (value == null){
               return ;
             
                     }
      
            setState(() {
               _selectedCategory= value;
      
             });
      
      
              },
              ),
              const SizedBox(width:24),
              Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
             children: [
              Text(_selectedDate == null ? 'No Date Selected':formatter.format(_selectedDate!),  ) ,
              IconButton(onPressed:_presentDatePicker, 
              icon: const Icon(
                Icons.calendar_month,),
              ),
            ],
      
            ),
           ),
           ],)
           
           
           else
          Row(children: [
            Expanded(
              child: TextField(
            controller:_amountController, 
            keyboardType: TextInputType.number ,
              maxLength: 50,
            decoration: const InputDecoration(
              prefixText: '\$ ' ,
              label:Text('Amount'),
              ),
           ),
            ),
      
           const SizedBox(width: 16),
      
           Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
             children: [
              Text(_selectedDate == null ? 'No Date Selected':formatter.format(_selectedDate!),  ) ,
              IconButton(onPressed:_presentDatePicker, 
              icon: const Icon(
                Icons.calendar_month,),
              ),
            ],
      
            ),
           ),
         
         
          ],
        ),
           const SizedBox(height: 16),
          if(width>=600)
          Row(children: [
            const Spacer(),
             TextButton(onPressed: (){
              Navigator.pop(context);
             }, 
             child:const  Text('Cancel'),
             ),
      
            ElevatedButton (
              onPressed:_submitExpenseData,  
            child: const Text('Save Expense'),
            ),

          ],)
          else
         Row(
          children: [ 
           DropdownButton(
            value: _selectedCategory,
            items:Category.values.map(
            (Category) => DropdownMenuItem(    
              value: Category  ,
              child: Text(
                Category.name.toUpperCase() ,
            ),
            ),
            ).toList(), 
            onChanged: (value){
              if (value == null){
               return ;
             
                     }
      
            setState(() {
               _selectedCategory= value;
      
             });
      
      
              },
              ),
             const Spacer(),
             TextButton(onPressed: (){
              Navigator.pop(context);
             }, 
             child:const  Text('Cancel'),
             ),
      
            ElevatedButton (
              onPressed:_submitExpenseData,  
            child: const Text('Save Expense'),
            ),
           
          ],
         ), 
        ],
        ) ,
         ),
    ),
  );
   }
   );


}


} 
