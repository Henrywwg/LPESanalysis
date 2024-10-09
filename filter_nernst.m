function filter_nernst(file_name)
    % Read the CSV file into a table
    
    filtered_datas = [[0 0] [0 0] [0 0]];

    concentrations = [10, 50, 100, 250, 500];

    for i = 1:3
        data_table = readtable(file_name(i));
        
        % Convert the table to an array (numerical matrix)
        data = table2array(data_table);
    
        column_names = data_table.Properties.VariableNames;
            
        %Filter data
        figure

        filtered_data(i, :,i) = moving_average_filter(data, file_name(i), column_names);
        hold off
    end


    for i = 1:3
        figure
        
        hold on
    
        calculate_nernstian_response(filtered_data(i), concentrations);

    end
end

