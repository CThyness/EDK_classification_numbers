load fisheriris
figure(1);
gscatter(meas(:,1), meas(:,2), species,'rgb','osd');
xlabel('Sepal length');
ylabel('Sepal width');

figure(2);
gscatter(meas(:,1), meas(:,3), species,'rgb','osd');
xlabel('Sepal length');
ylabel('Petal length');

figure(3);
gscatter(meas(:,1), meas(:,4), species,'rgb','osd');
xlabel('Sepal length');
ylabel('Petal width');

figure(4);
gscatter(meas(:,2), meas(:,3), species,'rgb','osd');
xlabel('Sepal width');
ylabel('Petal length');

figure(5);
gscatter(meas(:,2), meas(:,4), species,'rgb','osd');
xlabel('Sepal width');
ylabel('Petal width');

figure(6);
gscatter(meas(:,3), meas(:,4), species,'rgb','osd');
xlabel('Petal length');
ylabel('Petal width');
