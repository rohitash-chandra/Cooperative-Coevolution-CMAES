

% Cooperative Coevolution with CMAES in Sub-Pops by Dr. Rohitash Chandra (2016)
% c.rohitash@gmail.com .  Note that the function call is in the base class
% EvoAlg() which implemented CMAES. 





%http://stackoverflow.com/questions/13426234/array-of-classes-in-matlab



classdef CooperativeCoevolution   < EvoAlg
    properties
      SP;  % vector of subpopulations from GA
      
      Table; % Table of Best Solutions
     
      CCFitness; % Fitness of Individual 
      CCNumDimen;  % Size of Individual
      DimenIndex;
      CCProblem; % Problem Number (Rosenbrock, Sphere or others)
      
      NumSP;
    
      CCIndividual;
      CCFinalFitness;
      CCFE; % total number of Function Evaluations
      CCDimen;
    end
   
   methods (Static)
       
        function SolVec = GetSolution(ccobj)
         SolVec = ccobj.CCIndividual;
         end
      
        function BestFit = GetFitness(ccobj)
         BestFit = ccobj.CCFinalFitness;
        end
        
        function TotalFE = GetFE(ccobj)
         TotalFE = ccobj.CCFE;
        end
      
        function ccobj = CooperativeCoevolution(PopSize,Dimen, Prob, ProbMax, ProbMin)
            
          ccobj =   ccobj@EvoAlg(PopSize,Dimen(1), Prob, ProbMax, ProbMin); %  this has to be done to inilize the Inheritance - this is not used later as vector(cell) of EA. 
             
            ccobj.CCFE = 0;
           ccobj.CCDimen = Dimen;
           ccobj.CCNumDimen = sum(Dimen); 
           ccobj.CCProblem = Prob;
           ccobj.CCFinalFitness = 1;
              
            ccobj.CCIndividual=   zeros(1,  ccobj.CCNumDimen);
      
           ccobj.NumSP = length(Dimen) ;
           
             ccobj.DimenIndex = Dimen; % eg help in concatenating best solutions from rest of SP
              total =  ccobj.DimenIndex(1);
              for i=2:ccobj.NumSP
                 total = total + Dimen(i);
                 ccobj.DimenIndex(i) = total;
              end
           
               ccobj.DimenIndex  = horzcat([0], ccobj.DimenIndex); 
           %-------------------------------------------------------
            ccobj.SP = cell(10,1); % build a cell vector of Subpopulations of type EvoAlg
            
               for n=1:ccobj.NumSP
                   ccobj.SP{n}=  ccobj@EvoAlg(PopSize,Dimen(n), Prob, ProbMax, ProbMin);
                
               end 
         
           for sp =1:ccobj.NumSP 
            ccobj.Table(sp).SolVec =   ccobj.SP{sp}.Population(1).Individual;  %Individuals for SPs - note in EvoAlg class, PopMat is used as CMAES needs Matrix to work
           end
           
           ccobj.CCIndividual = normrnd(0, 0.01, 1,ccobj.CCNumDimen);
         
         
        end
         
      function PrintCCGA(ccobj) % print to test when needed
   
         for sp = 1:ccobj.NumSP 
           
               ccobj.SP{sp}.Fitness
             
           for i = 1:ccobj.SP{sp}.PopSize
             ccobj.SP{sp}.Population(i).Individual 
            end 
            ccobj.SP{sp}.N
              ccobj.SP{sp}.FinalFitness 
             ccobj.SP{sp}.FinalSolution  
          
           
         end 
      end
      
      function ccobj = GetBestTable(ccobj)
          
          for sp =1:ccobj.NumSP 
            bestIdx =  ccobj.SP{sp}.FinalFitIndex;
          
              ccobj.Table(sp).SolVec =   ccobj.SP{sp}.Population(bestIdx).Individual;  
          
            
          end 
          
      end
      
      function ccobj = Join(ccobj)
          
          BestInd=[];
           
        for sp = 1:ccobj.NumSP   
             BestInd = [BestInd,ccobj.Table(sp).SolVec] ;
        end 
      ccobj.CCIndividual = BestInd; 
      end
      
      
    % We dont cooperatvely evaluate here - we evalue in EvoAlg Class
    
  
       
      
      
      % main evolution
      % -------------------------------------------------------------------------
      function ccobj = CCEvolution(ccobj,   MaxFE,   MinError )
          
          disp('Begin CCGA for Problem: ');
           
          
          disp('Init ------------------------------------------------');
       %   We dont cooperatively evaluate in the begining - we leave it for
       %   evolution to evaluate 
           
       
       
          Cycle = 1;
          DepthSearch = 3;
        while ccobj.CCFE < MaxFE
        
              for sp=1:ccobj.NumSP 
                    
               for depth=1:DepthSearch 
                   
                   
               ccobj = CooperativeCoevolution.GetBestTable(ccobj);
               ccobj = CooperativeCoevolution.Join(ccobj);
               
               ccobj.SP{sp} =     EvoAlg.PureCMAES(ccobj.SP{sp}, DepthSearch ,sp, ccobj.CCIndividual, ccobj.CCDimen, ccobj.DimenIndex  ) ;
                 ccobj.CCFE = ccobj.CCFE + ccobj.SP{sp}.PopSize * DepthSearch; 
               end
               
                  % ccobj.SP{sp}.FinalSolution
               
                  % ccobj.SP{sp}.FinalFitness
              end 
              Cycle= Cycle +1; 
               
         
            ccobj.CCFinalFitness = ccobj.SP{ccobj.NumSP}.FinalFitness;
      
             % if ccobj.CCFinalFitness < MinError(problem)
              %   break     % termination if error 
              %end
         end
               disp('Final Fitness is:');
              disp(ccobj.SP{ccobj.NumSP}.FinalFitness);
            
      end
   end
end
