function  [dice2Roll]= dice2Image(rollScore)

dice2Roll= rollScore(2);

switch dice2Roll
    
    case 1
   set(app.dice2face1,'visible','on');
   set(app.dice2face2,'visible','off');
   set(app.dice2face3,'visible','off');
   set(app.dice2face4,'visible','off');
   set(app.dice2face5,'visible','off');
   set(app.dice2face6,'visible','off');
   
            
    case 2
        
   set(app.dice2face1,'visible','off');
   set(app.dice2face2,'visible','on');
   set(app.dice2face3,'visible','off');
   set(app.dice2face4,'visible','off');
   set(app.dice2face5,'visible','off');
   set(app.dice2face6,'visible','off');
   
        
    case 3
        
   set(app.dice2face1,'visible','off');
   set(app.dice2face2,'visible','off');
   set(app.dice2face3,'visible','on');
   set(app.dice2face4,'visible','off');
   set(app.dice2face5,'visible','off');
   set(app.dice2face6,'visible','off');
   
        
    case 4
        
   set(app.dice2face1,'visible','off');
   set(app.dice2face2,'visible','off');
   set(app.dice2face3,'visible','off');
   set(app.dice2face4,'visible','on');
   set(app.dice2face5,'visible','off');
   set(app.dice2face6,'visible','off');
        
    case 5
        
   set(app.dice2face1,'visible','off');
   set(app.dice2face2,'visible','off');
   set(app.dice2face3,'visible','off');
   set(app.dice2face4,'visible','off');
   set(app.dice2face5,'visible','on');
   set(app.dice2face6,'visible','off');
        
        
    case 6
        
   set(app.dice2face1,'visible','off');
   set(app.dice2face2,'visible','off');
   set(app.dice2face3,'visible','off');
   set(app.dice2face4,'visible','off');
   set(app.dice2face5,'visible','off');
   set(app.dice2face6,'visible','on');
end
        