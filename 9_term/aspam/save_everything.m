function [] = save_everything( filename, comment, precision, Data)
%SAVE_EVERYTHING Summary of this function goes here
%   Detailed explanation goes here
    fileID = fopen(filename,'w');
    format = strcat('(%.', num2str(precision(1)), 'f,%.', num2str(precision(2)),'f)');
    fprintf(fileID,strcat('%% ',comment,'\ncoordinates {\n'));

    fprintf(fileID,format,Data');
    fprintf(fileID,'\n};');

    fprintf(fileID,'\n\n\n %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n\n\n');

    fprintf(fileID,strcat('\t', format,'\n'),Data');
    fprintf(fileID,'};');
    
    fclose(fileID);
end

