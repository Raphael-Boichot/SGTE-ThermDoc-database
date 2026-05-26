function [] = Sort_by_dates_and_fix_syntax(database_in, database_out)
warning('off','all');
% ==== Setup folder and filenames ====
[input_folder,~,~] = fileparts(database_in);
working_copy = fullfile(input_folder, 'working_copy.txt'); % copy of original
temp_file    = fullfile(input_folder, 'temp_unsorted.txt'); % leftovers

% Make a working copy of the precious database
copyfile(database_in, working_copy);

% ==== Open output file ====
out = fopen(database_out,'w');

% ==== Pre-scan to detect unique years ====
fid = fopen(working_copy,'r');
entries = 0;
date_list = [];
history = [];
year = [];
while ~feof(fid)
    a = fgets(fid);
    if ~isempty(strfind(a,'tit'))
        entries = entries + 1;
        title     = fgets(fid);
        null      = fgets(fid);
        author    = fgets(fid);
        null      = fgets(fid);
        reference = fgets(fid);
        null      = fgets(fid);
        cle       = fgets(fid);
        null      = fgets(fid);
        date      = fgets(fid);
        if length(date) >= 4
            date_list(end+1) = str2double(date(1:4));
        end
    end
end
fclose(fid);

date_list = flip(unique(date_list));
disp([num2str(length(date_list)), ' different years detected'])

% ==== Sort references by year ====
ref_entered = 0;
for y = date_list
    fid = fopen(working_copy,'r');
    temp = fopen(temp_file,'w');
    match = 0;
    ill_formated = 0;

    while ~feof(fid)
        a = fgets(fid);
        if ~isempty(strfind(a,'tit'))
            % read full 9-line block
            title     = fgets(fid);
            null1     = fgets(fid);
            author    = fgets(fid);
            null2     = fgets(fid);
            reference = fgets(fid);
            null3     = fgets(fid);
            cle       = fgets(fid);
            null4     = fgets(fid);
            date      = fgets(fid);

            % determine if it matches current year
            if length(date) >= 4 && str2double(date(1:4)) == y
                % ---- MOVE to output directly ----
                match = match + 1;
                ref_entered = ref_entered + 1;

                % fix cle formatting
                if length(cle) > 2
                    if cle(end-2) ~= '/'
                        cle = [cle(1:end-2),'/',cle(end-1:end)];
                        ill_formated = ill_formated + 1;
                    end
                    if cle(1) ~= '/'
                        cle = ['/', cle];
                    end
                end

                % Build exact-format block (squashed)
                block = ['tit', char(13), newline, ...
                    remove_accents_from_string(native2unicode(title,'ISO-8859-1')), ...
                    'aut', char(13), newline, ...
                    remove_accents_from_string(native2unicode(author,'ISO-8859-1')), ...
                    'ref', char(13), newline, ...
                    remove_accents_from_string(native2unicode(reference,'ISO-8859-1')), ...
                    'cle', char(13), newline, ...
                    cle, ...
                    'dat', char(13), newline, ...
                    date, ...
                    '//', char(13), newline];

                fwrite(out, block);
            else
                % ---- KEEP in temp file as one block ----
                temp_block = ['tit', char(13), newline, title, ...
                    'aut', char(13), newline, author, ...
                    'ref', char(13), newline, reference, ...
                    'cle', char(13), newline, cle, ...
                    'dat', char(13), newline, date, ...
                    '//', char(13), newline];
                fwrite(temp, temp_block);
            end
        end
    end
    fclose(fid);
    fclose(temp);

    % rename temp as new working copy
    delete(working_copy);
    movefile(temp_file, working_copy);

    % progress report
    stars = repmat('X',1,ceil(match/40));
    disp(['Year ', num2str(y), ': ', stars, ' ', num2str(match), ' references'])
    history=[history; match];
    year=[year; y];

end

fclose(out);

% cleanup working copy
delete(working_copy);

disp([num2str(entries), ' references in original database'])
disp([num2str(entries - ref_entered), ' references discarded due to date format issue'])

try
    fig = figure('Position',[100 100 1400 1000]);
    year = flip(year);
    history = flip(history);
    yyaxis left
    h1 = plot(year, history, '-bd', 'MarkerFaceColor', 'b', 'LineWidth', 1.5);
    ylabel('References per Year')
    grid on
    yyaxis right
    h2 = plot(year, cumsum(history), '-rd', 'MarkerFaceColor', 'r', 'LineWidth', 1.5);
    ylabel('Cumulative References')
    xlabel('Year')
    set(gca, 'FontSize', 16)
    legend([h1, h2], {'Yearly References', 'Cumulative References'}, 'Location', 'northwest')
    exportgraphics(fig, 'References_and_Cumulative_vs_Year.png', 'Resolution', 300);
    pause(2)
    close all
catch
    disp('Graphical output deactivated with GNU Octave')
end

end
