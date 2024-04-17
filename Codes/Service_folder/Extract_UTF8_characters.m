function []=Extract_UTF8_characters(input_file)
warning ('off','all');
output_file='Error_outputs/Ref_with_UTF8_characters.txt';
out = fopen(output_file,'w');
fid = fopen(input_file,'r');
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
if i==0
    disp('No reference found')
end
disp([num2str(counter), ' references scanned, ', num2str(match), ' UTF8 characters found !']);
% msgbox([num2str(counter), ' references scanned, ', num2str(match), ' references found !']);
