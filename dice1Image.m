function  [dice1Roll]= dice1Image(rollScore)

dice1Roll= rollScore(1);

switch dice1Roll
    
    case 1
   set(app.dice1face1,'visible','on');
   set(app.dice1face2,'visible','off');
   set(app.dice1face3,'visible','off');
   set(app.dice1face4,'visible','off');
   set(app.dice1face5,'visible','off');
   set(app.dice1face6,'visible','off');
   
            
    case 2
        
   set(app.dice1face1,'visible','off');
   set(app.dice1face2,'visible','on');
   set(app.dice1face3,'visible','off');
   set(app.dice1face4,'visible','off');
   set(app.dice1face5,'visible','off');
   set(app.dice1face6,'visible','off');
   
        
    case 3
        
   set(app.dice1face1,'visible','off');
   set(app.dice1face2,'visible','off');
   set(app.dice1face3,'visible','on');
   set(app.dice1face4,'visible','off');
   set(app.dice1face5,'visible','off');
   set(app.dice1face6,'visible','off');
   
        
    case 4
        
   set(app.dice1face1,'visible','off');
   set(app.dice1face2,'visible','off');
   set(app.dice1face3,'visible','off');
   set(app.dice1face4,'visible','on');
   set(app.dice1face5,'visible','off');
   set(app.dice1face6,'visible','off');
        
    case 5
        
   set(app.dice1face1,'visible','off');
   set(app.dice1face2,'visible','off');
   set(app.dice1face3,'visible','off');
   set(app.dice1face4,'visible','off');
   set(app.dice1face5,'visible','on');
   set(app.dice1face6,'visible','off');
        
        
    case 6
        
   set(app.dice1face1,'visible','off');
   set(app.dice1face2,'visible','off');
   set(app.dice1face3,'visible','off');
   set(app.dice1face4,'visible','off');
   set(app.dice1face5,'visible','off');
   set(app.dice1face6,'visible','on');
end
        