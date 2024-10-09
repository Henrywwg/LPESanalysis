function slope = calculate_nernstian_response(data, concentrations)
    % This function computes the average of the last 50 data points for each column,
    % plots the averages as single points, fits a logarithmic function to them,
    % and extracts the slope (representing the Nernstian response).
    % INPUT:
    %   data - matrix, where each column represents a series of data points
    %   concentrations - array, concentrations corresponding to each column (e.g., 10ppm, 50ppm, etc.)
    % OUTPUT:
    %   slope - the slope of the ln(concentration) vs average potential plot (Nernstian slope)

    % Number of rows and columns in the data
    [num_rows, num_cols] = size(data);

    % Initialize array to store the averages
    averages = zeros(1, num_cols);

    % Calculate the average of the last 50 data points for each column
    for col = 1:num_cols
        if num_rows >= 50
            last_50_data = data(end-49:end, col); % Get the last 50 data points
        else
            last_50_data = data(:, col); % If fewer than 50 data points, take all
        end
        
        % Calculate the average of the last 50 data points
        averages(col) = mean(last_50_data);
    end

    % Take the log10 of the concentrations
    ln_concentrations = log10(concentrations);

    % Plot the averages against log(concentration)
    figure;
    plot(ln_concentrations, averages, 'bo', 'MarkerSize', 3, 'LineWidth', 3);
    title('Response');
    xlabel('ln(Concentration)');
    ylabel('Average Potential (V)');
    grid on;
    hold on;

    % Fit a linear function (y = mx + b) to the data
    coeffs = polyfit(ln_concentrations, averages, 1);  % coeffs(1) is the slope, coeffs(2) is the intercept
    fitted_values = polyval(coeffs, ln_concentrations);

    % Plot the fitted line
    plot(ln_concentrations, fitted_values, 'r--', 'LineWidth', 1);

    % Display the slope of the fitted line (Nernstian slope)
    slope = coeffs(1);
    fprintf('The slope (Nernstian response) is: %.4f\n', slope);

    % Add legend
    legend('Averages', 'Fitted Line');

    hold off;
end
