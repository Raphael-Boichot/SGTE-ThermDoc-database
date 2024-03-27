function []=Sort_by_dates_and_fix_syntax(input_file, output_file)
warning ('off','all');
out = fopen(output_file,'w');
s=dir(input_file);
disp('Scanning database for unique dates, please wait...')
fid = fopen(input_file,'r');
counter=0;
match=0;
entries=0;
while ~feof(fid)
    a=fgets(fid);
    if not(isempty(strfind(a,'tit')))
        entries=entries+1;
        counter=counter+1;
        title=fgets(fid);
        null=fgets(fid);
        author=fgets(fid);
        null=fgets(fid);
        reference=fgets(fid);
        null=fgets(fid);
        cle=fgets(fid);
        null=fgets(fid);
        date=fgets(fid);
        if length(date)>3
            match=match+1;
            date_list(match)=str2num(date);
        end
    end
end
disp('End of pre-scan')
date_list=flip(unique(date_list));
disp([num2str(length(date_list)),' different years of recording detected'])
ref_entered=0;

for m=1:1:length(date_list)
    date_ref=date_list(m);
    disp(['********Extracting, fixing and sorting references from year ',num2str(date_ref)])
    counter=0;
    match=0;
    ill_formated=0;
    fid = fopen(input_file,'r');
    while ~feof(fid)
        a=fgets(fid);
        if not(isempty(strfind(a,'tit')))
            counter=counter+1;
            title=fgets(fid);
            null=fgets(fid);
            author=fgets(fid);
            null=fgets(fid);
            reference=fgets(fid);
            null=fgets(fid);
            cle=fgets(fid);
            null=fgets(fid);
            date=fgets(fid);
            flag=0;
            if str2double(date)==date_ref
                flag=1;
            end
            if flag==1
                match=match+1;
                ref_entered=ref_entered+1;
                fwrite(out,'tit');
                fwrite(out,char(13));
                fwrite(out,newline);
                fwrite(out,upper(title));
                fwrite(out,'aut');
                fwrite(out,char(13));
                fwrite(out,newline);
                fwrite(out,upper(author));
                fwrite(out,'ref');
                fwrite(out,char(13));
                fwrite(out,newline);
                fwrite(out,upper(reference));
                if length(cle)>2
                    if not(cle(end-2)=='/')
                        cle=[cle(1:end-2),'/',cle(end-1:end)];
                        ill_formated=ill_formated+1;
                    end
                end
                fwrite(out,'cle');
                fwrite(out,char(13));
                fwrite(out,newline);
                fwrite(out,cle);
                %fwrite(out,upper(cle));
                fwrite(out,'dat');
                fwrite(out,char(13));
                fwrite(out,newline);
                fwrite(out,date);
                fwrite(out,'//');
                fwrite(out,char(13));
                fwrite(out,newline);
            end
        end
    end
    fclose(fid);
    disp([num2str(match),' references found for year ',num2str(date_ref)])
    disp([num2str(ill_formated),' keywords for elements corrected due to missing /'])
    disp([num2str(ref_entered),' references entered in the working database'])
end
fclose(out);
disp([num2str(entries),' references present in the original database'])
disp([num2str(entries-ref_entered),' references discarded due to date format issue'])
disp('***********End of sorting, database ready !***************')
% msgbox([num2str(counter), ' references scanned, ', num2str(match), ' references found !']);
