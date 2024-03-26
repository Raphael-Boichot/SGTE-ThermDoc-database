function []=Sort_by_dates(input_file)
warning ('off','all');
output_file='Sorted_database.txt';
out = fopen(output_file,'w');
s=dir(input_file);
database_size=s.bytes;
disp(['Scanning database for unique dates, please wait...'])
fid = fopen(input_file,'r');
counter=0;
match=0;
while ~feof(fid)
    a=fgets(fid);
    if not(isempty(strfind(a,'tit')))
        counter=counter+1;
        title=fgets(fid);
        empty=0;
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
ref_entered=0;

for m=1:1:length(date_list)
    date_ref=date_list(m);
    disp(['Dealing with year ',num2str(date_ref),'********************************'])
    counter=0;
    match=0;
    ill_formated=0;
    fid = fopen(input_file,'r');
    while ~feof(fid)
        a=fgets(fid);
        if not(isempty(strfind(a,'tit')))
            counter=counter+1;
            title=fgets(fid);
            empty=0;
            null=fgets(fid);
            author=fgets(fid);
            null=fgets(fid);
            reference=fgets(fid);
            null=fgets(fid);
            cle=fgets(fid);
            null=fgets(fid);
            date=fgets(fid);
            flag=0;
            if str2num(date)==date_ref
                flag=1;
            end
            if flag==1
                match=match+1;
                ref_entered=ref_entered+1;
                fwrite(out,'tit');
                fwrite(out,char(13));
                fwrite(out,char(10));
                fwrite(out,title);
                fwrite(out,'aut');
                fwrite(out,char(13));
                fwrite(out,char(10));
                fwrite(out,author);
                fwrite(out,'ref');
                fwrite(out,char(13));
                fwrite(out,char(10));
                fwrite(out,reference);
                if length(cle)>2
                    if not(cle(end-2)=='/');
                        cle=[cle(1:end-2),'/',cle(end-1:end)];
                        ill_formated=ill_formated+1;
                    end
                end
                fwrite(out,'cle');
                fwrite(out,char(13));
                fwrite(out,char(10));
                fwrite(out,cle);
                fwrite(out,'dat');
                fwrite(out,char(13));
                fwrite(out,char(10));
                fwrite(out,date);
                fwrite(out,'//');
                fwrite(out,char(13));
                fwrite(out,char(10));
            end
        end
    end
    fclose(fid);
    disp([num2str(ill_formated),' elements list (cle) corrected'])
    disp([num2str(match),' references entered for year ',num2str(date_ref)])
    disp([num2str(ref_entered),' references entered in total'])
end

fclose(out);
disp('***********End of sorting, database ready***************')
% msgbox([num2str(counter), ' references scanned, ', num2str(match), ' references found !']);
