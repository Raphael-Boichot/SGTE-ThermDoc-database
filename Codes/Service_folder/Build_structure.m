function []=Build_structure(input_file)
warning ('off','all');
fid = fopen(input_file,'r');
disp('Scanning database, building structure, please wait...')
counter=0;
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
        if rem(counter,10000)==0
          disp([num2str(counter),' references converted'])
        end
        database(counter).rank=counter;
        database(counter).title=title;
        database(counter).author=author;
        database(counter).reference=reference;
        database(counter).keyword=cle;
        database(counter).date=str2double(date);
    end
end
fclose(fid);
save('./Source_database/Sorted_database.mat','database')
disp([num2str(counter), ' references scanned']);
