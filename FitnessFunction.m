
function Fit = FitnessFunction(X,Problem) % just an external function, not part of class
Fit = 0;

Dimen = length(X);

if Problem == 1  %sphere 
    
  for i=1:Dimen
            Fit = Fit + (X(i)*X(i)) ;
  end
    
end
 
if Problem == 2 %rosen
      
 
for j = 1:Dimen-1;
    Fit = Fit+100*(X(j)^2-X(j+1))^2+(X(j)-1)^2;
end
     
end


end
    




















 