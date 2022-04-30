load fisheriris
figure(1);
gscatter(meas(:,1), meas(:,2), species,'rgb','osd');
xlabel('Sepal length');
ylabel('Sepal width');

figure(2);
gscatter(meas(:,1), meas(:,3), species,'rgb','osd');
xlabel('Sepal length');
ylabel('Pedal length');

figure(3);
gscatter(meas(:,1), meas(:,4), species,'rgb','osd');
xlabel('Sepal length');
ylabel('Pedal width');

figure(4);
gscatter(meas(:,2), meas(:,3), species,'rgb','osd');
xlabel('Sepal width');
ylabel('Pedal length');

figure(5);
gscatter(meas(:,2), meas(:,4), species,'rgb','osd');
xlabel('Sepal width');
ylabel('Pedal width');

figure(6);
gscatter(meas(:,3), meas(:,4), species,'rgb','osd');
xlabel('Pedal length');
ylabel('Pedal width');
