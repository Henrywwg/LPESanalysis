function filtered_data = moving_average_filter(data, graph_title, column_names)
    % This function applies a moving average filter with a window of 5
    % to each column of the input data, overlays the plots on one graph,
    % and sets a title for the graph.
    % INPUT:
    %   data - matrix, where each column represents a series of data points
    %   graph_title - string, title of the entire graph

    % Define the window size for the moving average
    window_size = 3;
    
    % Create a figure for plotting
    figure;

    % Hold the plot to overlay all columns on the same graph
    hold on;

    % Loop through each column and apply the moving average filter
    [num_rows, num_cols] = size(data);
    for col = 1:num_cols
        % Apply the moving average filter
        filtered_data(:,col) = movmean(data(:, col), window_size);

        % Plot the filtered data, using the column name as the title for each line
        plot(1:num_rows, filtered_data(:,col), 'DisplayName', column_names{col});
    end

    concentrations = [10, 50, 100, 250, 500];

    %calculate_nernstian_response(filtered_data, concentrations);


    % Set the title for the graph
    title(graph_title);

    % Add labels to the axes
    xlabel('Sample');
    ylabel('Value');

    % Add a legend to identify each column
    legend show;

    % Release the hold on the plot
    %hold off


end