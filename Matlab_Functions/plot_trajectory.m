function plot_trajectory( GPSData)

figure
plot(GPSData(:,3),GPSData(:,4),'m')
xlabel('lat'); ylabel('long');
axis equal
