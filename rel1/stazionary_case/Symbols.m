classdef symbols
    %SYMBLOS Summary of this class goes here
    %   Detailed explanation goes here
    enumeration 
        Rock, Paper, Scissors, Spock, Lizard
    end
end

function s = getSymbol(b)
  switch b
      case 1
          s = symbols.Rock;
      case 2
          s = symbols.Paper;
      case 3
          s = symbols.Scissors;
      case 4
          s = symbols.Spock;
      case 5
          s = symbols.Lizard;
  end
end
