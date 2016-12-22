% CCGA by Rohitash Chandra, 2016: c.rohitash(at)gmail.com

% This is based on Canaonical Cooperative Coevolution from  M. A. Potter and K. A. D. Jong, “A cooperative coevolutionary
%approach to function optimization,” in PPSN , 1994, pp. 249–257.
%https://en.wikipedia.org/wiki/Cooperative_coevolution

% The EA employs CMAES: https://en.wikipedia.org/wiki/CMA-ES

% Only two Problems are used for Demo: Sphere and Rosenbrock. 

clear all
clc

out1 = fopen('out1.txt', 'w');
out2 = fopen('out2.txt', 'w');




 MaxFE = 500000  ;
  Dimen = [3, 3, 4, 4]; % this means that  14 dimensions has been decomposed with 4 subpopulations. 
  %If you wish to have no decomposition, i.e. just EA with one population,  you can have Dimen = [14]. You can
  %have any number of subpulation with different sizes to decompose the
  %problem. 
  
  
  D = sum(Dimen);
  
  
 PopSize = 4+floor(3*log(D)) ;

 MinError = [0.0001,0.0001]; %Min Error for each problem
 NumProb = 2;
 
 

ProbMin = [-5, -5   ];


ProbMax = [5, 5   ];
  
 
for Prob = 1:NumProb  
        CCGA = CooperativeCoevolution(PopSize,Dimen, Prob, ProbMax, ProbMin);   
        
        
  for Run=1:5
     CCGA = CooperativeCoevolution.CCEvolution( CCGA, MaxFE,   MinError );
    
 
    Fit(Run) = CooperativeCoevolution.GetFitness(CCGA); 
     FE(Run) = CooperativeCoevolution.GetFE(CCGA) ;
     Solution = CooperativeCoevolution.GetSolution(CCGA)
     
  fprintf(out1, '%d %s', Run, num2str(Solution)); % print to file - best solution with fitnesss
     fprintf(out1, '%s %f \n', '  --->  ', Fit(Run));
    
  end 
 
     fprintf(out1, '\n'); 
     
      MeanFit = mean(Fit)
      SDFit = std(Fit)

      MeanFE = mean(FE)
      SDFE = std(FE)
 
    
   fprintf(out2, '%d %12.8f %12.8f %d %d \n \n', Prob, MeanFit, SDFit,MeanFE, SDFE); % prints stats for n experiments
     
 
end




fclose(out1);
fclose(out2);
