function [NoNaNArrayX, NoNaNArrayY] = NoNaN(ArrayX,ArrayY)

    %% This function builds an array out of the inputs where the NaN points have been removed.
    % Whenever a NaN is present on ArrayY, it erases it on
    % both arrays.
    if nargin == 1
        ArrayY = ArrayX;
        ArrayX = 1:length(ArrayY);
    end
  
    NaNPoints = isnan (ArrayY(:));
    NoNaNArrayY = zeros (1,length(ArrayY) - sum(NaNPoints));
    NoNaNArrayX = NoNaNArrayY;
    
    Counter = 0;    
    for I=1:length(ArrayY) 
        if NaNPoints(I) == 0
            Counter = Counter + 1;
            NoNaNArrayY(Counter) = ArrayY(I);
            NoNaNArrayX(Counter) = ArrayX(I);            
        end        
    end
    
    
end