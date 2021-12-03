function  showDiceImage(face1, face2, face3, face4, face5, face6, diceValue)



switch diceValue
    
    case 1
   set(face1,'visible','on');
   set(face2,'visible','off');
   set(face3,'visible','off');
   set(face4,'visible','off');
   set(face5,'visible','off');
   set(face6,'visible','off');
   
            
    case 2
        
   set(face1,'visible','off');
   set(face2,'visible','on');
   set(face3,'visible','off');
   set(face4,'visible','off');
   set(face5,'visible','off');
   set(face6,'visible','off');
   
        
    case 3
        
   set(face1,'visible','off');
   set(face2,'visible','off');
   set(face3,'visible','on');
   set(face4,'visible','off');
   set(face5,'visible','off');
   set(face6,'visible','off');
   
        
    case 4
        
   set(face1,'visible','off');
   set(face2,'visible','off');
   set(face3,'visible','off');
   set(face4,'visible','on');
   set(face5,'visible','off');
   set(face6,'visible','off');
        
    case 5
        
   set(face1,'visible','off');
   set(face2,'visible','off');
   set(face3,'visible','off');
   set(face4,'visible','off');
   set(face5,'visible','on');
   set(face6,'visible','off');
        
        
    case 6
        
   set(face1,'visible','off');
   set(face2,'visible','off');
   set(face3,'visible','off');
   set(face4,'visible','off');
   set(face5,'visible','off');
   set(face6,'visible','on');
end
        