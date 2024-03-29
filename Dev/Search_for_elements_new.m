function []=Search_for_elements_new(varargin)
warning ('off','all');
order=1:1:nargin;
database_name='Sorted_database.bib';
permutations=perms(order);
fid = fopen(database_name,'r');
identifier=[];
for j=1:1:nargin
    identifier=[identifier,'-',varargin{j}];
    if varargin{j}=='Xx'
        varargin{j}='.*';
    end
end
output_file=['./Search_results/',identifier(2:end),'.txt'];
out = fopen(output_file,'w');
fwrite(out,['************Search results for /',identifier(2:end),'/ system************']);
fwrite(out,char(13));
fwrite(out,newline);
fwrite(out,char(13));
fwrite(out,newline);

disp('Scanning database, please wait...')
counter=0;
match=0;
while ~feof(fid)
    a=fgets(fid);
    if not(isempty(strfind(a,'tit')))
        counter=counter+1;
        title=fgets(fid);
        if length(title)<3
            title=['***************Title is missing***************',char(13),char(10)];
        end
        null=fgets(fid);
        author=fgets(fid);
        null=fgets(fid);
        reference=fgets(fid);
        null=fgets(fid);
        cle=fgets(fid);
        null=fgets(fid);
        date=fgets(fid);
        empty=1;
        
        if length(cle)>3
            separator = '\/';
            splitStr = regexp(cle,separator,'split');
            for m=1:1:length(splitStr)
                for p=1:1:length(permutations)
                    key=[];
                    for j=1:1:nargin
                        key=[key,'-',varargin{permutations(p,j)}];
                    end
                    key=[key(2:end)];
                    startIndex = regexp(splitStr(1,m),key);
                    if not(isempty(startIndex{1}))
                        empty=0;
                    end
                end
            end
        end
        
        if empty==0
            match=match+1;
            fwrite(out,['Rank      : ',num2str(counter)]);
            fwrite(out,char(13));
            fwrite(out,newline);
            fwrite(out,['Title     : ',title]);
            fwrite(out,['Author    : ',author]);
            fwrite(out,['Reference : ',reference]);
            fwrite(out,['Keyword   : ',cle]);
            fwrite(out,['Date      : ',date]);
            fwrite(out,char(13));
            fwrite(out,newline);
        end
    end
end
fclose(fid);
fclose(out);
disp([num2str(counter), ' references scanned, ', num2str(match), ' references found !']);
% msgbox([num2str(counter), ' references scanned, ', num2str(match), ' references found !']);
