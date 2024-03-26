function []=Search_for_elements(varargin)
warning ('off','all');
nargin;
order=1:1:nargin-1;
database_name=varargin{end};
permutations=perms(order);
s=dir(database_name);
database_size=s.bytes;
fid = fopen(database_name,'r');
output_file=[];
for j=1:1:nargin-1
    output_file=[output_file,'-',varargin{j}];
end
output_file=[output_file(2:end),'_from_',database_name(1:end-4),'.txt'];

out = fopen(output_file,'w');
            fwrite(out,['************Search results for /',output_file(1:end-4),'/ system************']);
            fwrite(out,char(13));
            fwrite(out,char(10));
            fwrite(out,char(13));
            fwrite(out,char(10));

disp(['Scanning database, please wait...'])
counter=0;
match=0;
f = waitbar(0,'1','Name',['Search results for /',output_file(1:end-4)]);

setappdata(f,'canceling',0);
while ~feof(fid)
    position = ftell(fid);
    a=fgets(fid);
    if not(isempty(strfind(a,'tit')))
        if rem(counter,100)==0;
            waitbar(position/database_size,f,[num2str(match), ' references found']);
        end
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
        for i=1:1:length(permutations)
            phrase=[];
            for j=1:1:nargin-1
                phrase=[phrase,'-',varargin{permutations(i,j)}];
            end
            phrase_1=[phrase(2:end),'/'];
            if not(isempty(strfind(cle,phrase_1)))
                if strfind(cle,phrase_1)==1
                    empty=0;
                end
            end
            phrase_2=['/',phrase(2:end),'/'];
            if not(isempty(strfind(cle,phrase_2)))
                empty=0;
            end
        end

        if empty==0
            match=match+1;
            fwrite(out,['Rank      : ',num2str(counter)]);
            fwrite(out,char(13));
            fwrite(out,char(10));
            fwrite(out,['Title     : ',title]);
            fwrite(out,['Author    : ',author]);
            fwrite(out,['Reference : ',reference]);
            fwrite(out,['Keyword   : ',cle]);
            fwrite(out,['Date      : ',date]);
            fwrite(out,char(13));
            fwrite(out,char(10));
        end
    end
end
fclose(fid);
fclose(out);
if i==0
    disp('No reference found')
end
delete(f)
disp([num2str(counter), ' references scanned, ', num2str(match), ' references found !']);
% msgbox([num2str(counter), ' references scanned, ', num2str(match), ' references found !']);
