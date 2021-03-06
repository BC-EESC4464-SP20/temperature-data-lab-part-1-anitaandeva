%% Anita Gee and Eva Lin 

% Instructions: Follow through this code step by step, while also referring
% to the overall instructions and questions from the lab assignment sheet.
% Everywhere you see "% -->" is a place where you will need to write in
% your own line of code to accomplish the next task.

%% 1a. Read in the file for your station as a data table
addpath('ObsData')
filename = '471590.csv'; %change this to select a different station
stationdata = readtable(filename);

%% 1b-c. Investigate the data you are working with
%Click in the workspace to open up the new table named stationdata. You
%should be able to see headers for each column in the table.

%Open up the original csv file (Excel is a good way to do this) to see how
%the imported headers match those in the original file.

%You should also be able to see the latitude and longitude of the original
%station in the csv file. Add these below:

stationlat = 35.1; %uncomment to run this line of code after adding the station latitude
stationlon = 129.03; %uncomment to run this line of code after adding the station longitude

%% 2. Plot the data from a single month
% Make a plot for all data from January with year on the x-axis and
% temperature on the y-axis. You will want this plot to have individual
% point markers rather than a line connecting each data point.
yr = stationdata{:,3};
Jan_Temp = stationdata{:,4};
plot(yr,Jan_Temp)


% Calculate the monthly mean, minimum, maximum, and standard deviation
% note: some of these values will come out as NaN is you use the regular
% mean and std functions --> can you tell why? use the functions nanmean
% and nanstd to avoid this issue.

monthMean = nanmean(Jan_Temp)
monthStd = nanstd(Jan_Temp)
monthMin = min(Jan_Temp)
monthMax = max(Jan_Temp)

%% 3. Calculate the annual climatology
% Extract the monthly temperature data from the table and store it in an
% array, using the function table2array
tempData = table2array(stationdata(:,4:15));

%Calculate the mean, standard deviation, minimum, and maximum temperature
%for every month. This will be similar to what you did above for a single
%month, but now applied over all months simultaneously.
x = 1:12;
    y = tempData(:,x);
    tempMean = nanmean(y)
    tempStd = nanstd(y)
    tempMin = min(y)
    tempMax = max(y)
%Use the plotting function "errorbar" to plot the monthly climatology with
%error bars representing the standard deviation. Add a title and axis
%labels. Use the commands "axis", "xlim", and/or "ylim" if you want to
%change from the automatic x or y axis limits.    
    figure(1); clf
    month=1:12;
    errorbar(month,tempMean,tempStd);
    title("Climatological monthly mean temperature");
    xlabel("month");
    ylabel("temperature in degree Celsius");
   
% --> (note that this may take multiple lines of code)

%% 4. Fill missing values with the monthly climatological value
% Find all values of NaN in tempData and replace them with the
% corresponding climatological mean value calculated above.

% We can do this by looping over each month in the year:
for i = 1:12
    %use the find and isnan functions to find the index location in the
    %array of data points with NaN values
    indnan = find(isnan(tempData(:,i)) == 1);%check to make sure you understand what is happening in this line
    tempData(indnan) = tempMean(:,i);
    tempData(isnan(tempData)) = tempMean(:,i)
    %tempData(indnan,i)=tempMean(i)
    %now fill the corresponding values with the climatological mean
    % --> 
end

%% 5a. Calculate the annual mean temperature for each year
% --> annmean=mean(tempData')% annmean=mean(tempData,2)
annmean=mean(tempData')
%% 5b-c. Calculate the temperature anomaly for each year, compared to the 1981-2000 mean
% The anomaly is the difference from the mean over some baseline period. In
% this case, we will pick the baseline period as 1981-2000 for consistency
% across each station (though note that this is a choice we are making, and
% that different temperature analyses often pick different baselines!)

%Calculate the annual mean temperature over the period from 1981-2000
  %Use the find function to find rows contain data where stationdata.Year is between 1981 and 2000

base_begin=find(yr == 1981)
base_end=find(yr == 2000)
  %Now calculate the mean over the full time period from 1981-2000
baseline_mean=mean(annmean(78:97))

%Calculate the annual mean temperature anomaly as the annual mean
%temperature for each year minus the baseline mean temperature
anomly=annmean-baseline_mean

%% 6a. Plot the annual temperature anomaly over the full observational record
figure(2); clf
%Make a scatter plot with year on the x axis and the annual mean
%temperature anomaly on the y axis
% -->  
plot(yr,anomly,'.')
%% 6b. Smooth the data by taking a 5-year running mean of the data to plot
%This will even out some of the variability you observe in the scatter
%plot. There are many methods for filtering data, but this is one of the
%most straightforward - use the function movmean for this. For information
%about how to use this function, type "help movmean" in the command window.
% --> 
hold on
movemean=movmean(anomly,5)
plot(yr,movemean)
%Now add a line with this smoothed data to the scatter plot


%% 7. Add and plot linear trends for whole time period, and for 1960 to today
%Here we will use the function polyfit to calculate a linear fit to the data
%For more information, type "help polyfit" in the command window and/or
%read the documentation at https://www.mathworks.com/help/matlab/data_analysis/linear-regression.html
    %use polyfit to calculate the slope and intercept of a best fit line
    %over the entire observational period
s=1:108;
polyfit(s,anomly,1)

    %also calculate the slope and intercept of a best fit line just from
    %1960 to the end of the observational period
    % Hint: start by finding the index for where 1960 is in the list of
    % years
A=find(yr == 1960)
B=find(yr == 2011)
polyfit(s(57:108),anomly(57:108),1)


%Add lines for each of these linear trends on the annual temperature
%anomaly plot (you can do this either directly using the slope and intercept
%values calculated with polyfit, or using the polyval function).
%Plot each new line in a different color.
y = 0.018*s -1.2305;
plot(yr,y)
y1 = -0.0100*s(57:108)+0.4892
plot(yr(57:108),y1,'g')
legend('Data Points for Temperature Anomaly','Time Series Using Five Year Running Mean','Best fit line for Entire Observational Period','Best fit line from just 1960-2011','Location','Southwest')
title('Scatter Plot of Anomaly with Baseline (1981-2000) vs. Year')
xlabel('Year')
ylabel('Temperature Anomaly degrees Celsius')
% Add a legend, axis labels, and a title to your temperature anomaly plot
% --> 
