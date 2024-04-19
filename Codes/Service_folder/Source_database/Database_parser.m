clc
clear
base_1='Matlab_database.bib';
base_2='Octave_database.bib';
tic
disp(num2str(crc32(fileread(base_1))))
disp(num2str(crc32(fileread(base_2))))
toc
a=fileread(base_1);
b=fileread(base_2);
[~,rank,~] = find(a-b)
if not(isempty(rank))
    char(unique(a(rank)))
    char(unique(b(rank)))
else
    disp('Nothing to compare')
end