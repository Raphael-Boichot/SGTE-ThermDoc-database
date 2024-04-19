% The source database was encoded in Windows-1252 characters, which is a superset 
% of ISO 8859-1, also known as ISO Latin-1. ISO 8859-1 contains all
% European accents, which are easily substituable with a table but Windows-1252 
% also contains characters like Œ or ™ which are not always substituable with a 
% single character. These latter will be removed from source database as they 
% can be not displayed/discarded properly depending on the OS the service 
% script is running on

function []=Extract_Windows_1252_characters(input_file)
warning ('off','all');
output_file='Error_outputs/Ref_with_Windows_1252_characters.txt';
out = fopen(output_file,'w');
fid = fopen(input_file,'r');
%fid = fopen(input_file,'r','n','windows-1252');
%disp('Scanning database, please wait...')
counter=0;
match=0;
while ~feof(fid)
    a=fgets(fid);
    if not(isempty(strfind(a,'tit')))
        counter=counter+1;
        empty=0;
        title=fgets(fid);
        if max(double(title))>255
            empty=1;
        end
        null=fgets(fid);
        author=fgets(fid);
        if max(double(author))>255
            empty=1;
        end
        null=fgets(fid);
        reference=fgets(fid);
        if max(double(reference))>255
            empty=1;
        end
        null=fgets(fid);
        cle=fgets(fid);
        null=fgets(fid);
        date=fgets(fid);

        if empty==1
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

fid = fopen(input_file,'r');
%disp('Scanning database, please wait...')
list=[];
while ~feof(fid)
    a=fgets(fid);
    if not(isempty(strfind(a,'tit')))
        title=fgets(fid);
        if max(double(title))>255
            for i=1:1:length(title)
                if title(i)>255
                    list=[list,title(i)];
                end
            end
        end
        null=fgets(fid);
        author=fgets(fid);
        if max(double(author))>255
            for i=1:1:length(author)
                if author(i)>255
                    list=[list,author(i)];
                end
            end
        end
        null=fgets(fid);
        reference=fgets(fid);
        if max(double(reference))>255
            for i=1:1:length(reference)
                if reference(i)>255
                    list=[list,reference(i)];
                end
            end
        end
        null=fgets(fid);
        cle=fgets(fid);
        null=fgets(fid);
        date=fgets(fid);
    end
end
list=unique(list);
fclose(fid);

if i==0
    disp('No reference found')
end
disp([num2str(counter), ' references scanned, ', num2str(match), ' entries with Windows-1252 characters found !']);
disp(['List of Windows-1252 characters found: ',char(list)])
% msgbox([num2str(counter), ' references scanned, ', num2str(match), ' references found !']);
