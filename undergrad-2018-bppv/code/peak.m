load 'aa.txt'
time = aa(:,1);
coordinate = aa(:,2);


[high_Y,high_X] = findpeaks(coordinate,'MinPeakProminence',3);
[low_Y,low_X] = findpeaks(-coordinate,'MinPeakProminence',3);

figure
hold on

plot(coordinate);
plot(high_X,coordinate(high_X),'rv','MarkerFaceColor','r')
plot(low_X,coordinate(low_X),'rs','MarkerFaceColor','Y')

grid on

%axis([0 2*pi -1.5 1.5])
xlabel('time(d/s)')
ylabel('coordinate')
title('Find All Peaks')
