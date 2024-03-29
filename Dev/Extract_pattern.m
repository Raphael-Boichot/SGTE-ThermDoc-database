% Chaîne de caractères
clc
clear
cle = '/Al-H/Al-D/';
        if length(cle)>3
            separator = '\/';
            splitStr = regexp(cle,separator,'split')
            length(splitStr)
            for i=1:1:length(splitStr)
                for i=1:1:length(permutations)
                    key=[];
                    for j=1:1:nargin
                        key=[key,'-',varargin{permutations(i,j)}];
                    end
                    key=[key(2:end)]
                    startIndex = regexp(splitStr(1,i),key)
                    if not(isempty(startIndex{1}))
                        empty=0;
                        disp(prout)
                    end
                end
            end
        end
