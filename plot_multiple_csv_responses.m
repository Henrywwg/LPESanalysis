function plot_multiple_csv_responses(file1, file2, file3)
    % This function takes three CSV files, scales each column based on the average
    % of the first 50 points of the first column of each CSV, and plots the
    % responses (all columns) from the three files on the same graph.
    % 
    % INPUTS:
    %   file1 - string, the filename of the first CSV file
    %   file2 - string, the filename of the second CSV file
    %   file3 - string, the filename of the third CSV file

    % Define colors for each file
    colors = {'b', 'r', 'g'};  % Blue for file1, Red for file2, Green for file3

    % Load the three CSV files
    data1 = readtable(file1);
    data2 = readtable(file2);
    data3 = readtable(file3);

    % Convert tables to matrices
    data1 = table2array(data1);
    data2 = table2array(data2);
    data3 = table2array(data3);

    % Create a new figure for the plot
    figure;
    hold on;

    % Plot responses for the first file (data1)
    plot_csv_data(data1, colors{1}, 'File 1');

    % Plot responses for the second file (data2)
    plot_csv_data(data2, colors{2}, 'File 2');

    % Plot responses for the third file (data3)
    plot_csv_data(data3, colors{3}, 'File 3');

    % Add title, labels, and grid
    title('Responses from Multiple CSV Files (Scaled)');
    xlabel('Sample Number');
    ylabel('Scaled Response');
    grid on;

    % Create legend
    legend({'File 1', 'File 2', 'File 3'}, 'Location', 'Best');
    
    hold off;
end

function plot_csv_data(data, color, file_label)
    % This helper function scales the columns of the input data based on the 
    % average of the first 50 points from the first column and plots the results.
    % 
    % INPUTS:
    %   data - matrix, where each column represents a series of data points
    %   color - string, the color for plotting the columns of this CSV file
    %   file_label - string, label for this file in the plot legend

    % Get the number of rows and columns in the data
    [num_rows, num_cols] = size(data);

    % Scale all columns by the average of the first 50 points from the first column
    if num_rows >= 50
        scaling_factor = mean(data(1:50, 1));  % Use the first 50 points from the first column
    else
        scaling_factor = mean(data(:, 1));  % If fewer than 50 points, use all available points
    end

    % Plot each column scaled by the computed scaling factor
    for col = 1:num_cols
        plot(1:num_rows, data(:, col) / scaling_factor, 'Color', color);
    end
end
