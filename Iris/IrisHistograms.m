% Loading individal classes
classSetosa = load('class_1');  
classVersicolour = load('class_2');  
classVirginica = load('class_3'); 

%Combining all classes to an array
all_data = [classSetosa; classVersicolour; classVirginica];

%Generating bins
sl_bins = min(all_data(:,1)):0.1:max(all_data(:,1)); % sepal length
sw_bins = min(all_data(:,2)):0.1:max(all_data(:,2)); % sepal width
pl_bins = min(all_data(:,3)):0.1:max(all_data(:,3)); % petal length
pw_bins = min(all_data(:,4)):0.1:max(all_data(:,4)); % petal width

%defining bin sizes
bins    = 0:0.2:8;
sl_bins = bins;
sw_bins = bins;
pl_bins = bins;
pw_bins = bins;

figure(1);
clf;
sgtitle('Sepal length for diffent classes');

subplot(411);
hold on;
histogram(classSetosa(:,1), sl_bins);

xlabel('Sepal length [cm] for Setosa');
ylabel('Count');

subplot(412);
hold on;
histogram(classVersicolour(:,1), sl_bins);

xlabel('Sepal length [cm] for Versicolour');
ylabel('Count');

subplot(413);
hold on;
histogram(classVirginica(:,1), sl_bins);

xlabel('Sepal length [cm] for Viriginica');
ylabel('Count');

figure(2);
clf;
sgtitle('Sepal width for different classes');

subplot(411);
hold on;
histogram(classSetosa(:,2), sl_bins);

xlabel('Sepal width [cm] for Setosa');
ylabel('Count');

subplot(412);
hold on;
histogram(classVersicolour(:,2), sl_bins);

xlabel('Sepal width [cm] for Versicolour');
ylabel('Count');

subplot(413);
hold on;
histogram(classVirginica(:,2), sl_bins);

xlabel('Sepal width [cm] for Viriginica');
ylabel('Count');

figure(3);
clf;
sgtitle('Petal length for different classes');

subplot(411);
hold on;
histogram(classSetosa(:,3), sl_bins);

xlabel('Petal length [cm] for Setosa');
ylabel('Count');

subplot(412);
hold on;
histogram(classVersicolour(:,3), sl_bins);

xlabel('Petal length [cm] for Versicolour');
ylabel('Count');

subplot(413);
hold on;
histogram(classVirginica(:,3), sl_bins);

xlabel('Petal length [cm] for Viriginica');
ylabel('Count');

figure(4);
clf;
sgtitle('Petal width for different classes');

subplot(411);
hold on;
histogram(classSetosa(:,4), sl_bins);

xlabel('Petal width [cm] for Setosa');
ylabel('Count');

subplot(412);
hold on;
histogram(classVersicolour(:,4), sl_bins);

xlabel('Petal width [cm] for Versicolour');
ylabel('Count');

subplot(413);
hold on;
histogram(classVirginica(:,4), sl_bins);

xlabel('Petal width [cm] for Viriginica');
ylabel('Count');
