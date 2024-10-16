function [slope, R_squared] = analyze_sensor_data(data, concentrations, apply_moving_avg, normalize, window_size, i)
    % This function processes sensor data, applies optional moving average filter,
    % normalizes the data (optional), plots the data, calculates the sensitivity 
    % (Nernstian response) using first and last 50 points, and extracts the slope and R^2.
    % 
    % INPUTS:
    %   data - matrix, where each column represents a series of data points
    %   concentrations - array, concentrations corresponding to each column
    %   apply_moving_avg - boolean, if true applies moving average filter
    %   normalize - boolean, if true normalizes the data by max value
    %   window_size - integer, window size for moving average filter
    % 
    % OUTPUTS:
    %   slope - the slope of the log10(concentration) vs average potential plot (Nernstian slope)
    %   R_squared - the R^2 value for the logarithmic fit

    % Number of rows and columns in the data
    [num_rows, num_cols] = size(data);

    % Optional moving average filtering
    if apply_moving_avg
        for col = 1:num_cols
            data(:, col) = movmean(data(:, col), window_size);
        end
    end

    % Optional normalization of the data
    if normalize
        for col = 1:num_cols
            data(:, col) = data(:, col) / max(data(:, col));
        end
    end

    % Plotting all columns overlaid on each other
    figure;
    hold on;
    for col = 1:num_cols
        plot(1:num_rows, data(:, col), 'DisplayName', concentrations(col) +" ppm");
    end
    title('Sensor Sensitivity');
    xlabel('Sample');
    ylabel('Sensor Output');
    legend show;
    grid on;
    hold off;

    print("sensor_wholistic-"+i, '-dpng');

    % Initialize arrays to store averages of first and last 50 points
    avg_first_50 = zeros(1, num_cols);
    avg_last_50 = zeros(1, num_cols);

    % Calculate averages of the first and last 50 data points for each column
    for col = 1:num_cols
        if num_rows >= 50
            first_50_data = data(1:50, col);   % First 50 points
            last_50_data = data(end-49:end, col); % Last 50 points
        else
            first_50_data = data(1:end, col);  % All points if fewer than 50
            last_50_data = data(1:end, col);   % All points if fewer than 50
        end
        avg_first_50(col) = mean(first_50_data);
        avg_last_50(col) = mean(last_50_data);
    end

    % Take the natural log of the concentrations
    log_concentrations = log10(concentrations);

    % Sensitivity: Use averages of last 50 data points for Nernstian response
    figure;
    plot(log_concentrations, avg_last_50, 'bo', 'MarkerSize', 8, 'LineWidth', 2);
    title('Nernstian Response');
    xlabel('log10(Concentration)');
    ylabel('Average Potential (V)');
    grid on;
    hold on;

    % Fit a linear function (y = mx + b) to the log10(concentration) vs avg_last_50
    coeffs = polyfit(log_concentrations, avg_last_50, 1); % coeffs(1) = slope, coeffs(2) = intercept
    fitted_values = polyval(coeffs, log_concentrations);

    % Plot the fitted line
    plot(log_concentrations, fitted_values, 'r-', 'LineWidth', 2);

    % Calculate the slope (Nernstian slope)
    slope = coeffs(1);

    % Calculate R-squared value to assess fit quality
    residuals = avg_last_50 - fitted_values;
    SS_res = sum(residuals.^2);
    SS_tot = sum((avg_last_50 - mean(avg_last_50)).^2);
    R_squared = 1 - (SS_res / SS_tot);

    % Display the slope and R-squared
    fprintf('The slope (Nernstian response) is: %.4f\n', slope);
    fprintf('The R-squared value is: %.4f\n', R_squared);

    % Add legend
    legend('Data Points', 'Fitted Line');
    
    text(log_concentrations(3), avg_last_50(2),  {"Response: " + coeffs(1), "R2: " + R_squared});

    print("sensor_nernst-"+i, '-dpng');

    hold off;
end
