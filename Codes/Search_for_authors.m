function []=Search_for_authors(varargin)
warning ('off','all');
database_name='./Service_folder/Source_database/Sorted_database.bib';
s=dir(database_name);
database_size=s.bytes;
fid = fopen(database_name,'r');
identifier=[];
for j=1:1:nargin
    identifier=[identifier,'-',varargin{j}];
end
output_file=['./Search_results/',identifier(2:end),'.txt'];
out = fopen(output_file,'w');
fwrite(out,['************Search results for authors: ',identifier(2:end),'************']);
fwrite(out,char(13));
fwrite(out,newline);
fwrite(out,char(13));
fwrite(out,newline);

disp(['Scanning database, please wait...'])
counter=0;
match=0;
while ~feof(fid)
    a=fgets(fid);
    if not(isempty(strfind(a,'tit')))
        counter=counter+1;
        title=fgets(fid);
        if length(title)<3
            title=['***************Title is missing***************',char(13),newline];
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

        for j=1:1:nargin
            phrase=upper(varargin{j});
            if not(isempty(strfind(author,phrase)))
                empty=0;
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
