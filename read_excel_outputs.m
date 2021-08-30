clear all
close all
clc

cd('color_data')

files=dir;
files=files(3:end);

color_names ={'DarkSkin',
    'LightSkin',
    'BlueSky',
    'Foliage',
    'BlueFlower',
    'BluishGreen',
    'Orange',
    'PurplishBlue',
    'ModerateRed',
    'Purple',
    'YellowGreen',
    'OrangeYellow',
    'Blue',
    'Green',
    'Red',
    'Yellow',
    'Magenta',
    'Cyan',
    'White-9-5',
    'Neutral-8',
    'Neutral-6-5',
    'Neutral-5',
    'Neutral-3-5',
    'Black-2'
    };
methods ={'D1','D2','G1','G2'};

samples_all=struct([]);

idx=1;
for i=1:length(files)
    FileName=strsplit(files(i).name,'_');
    FileContents=readtable(files(i).name);
    try
        if table2array(FileContents(1,3))==1
        samples_all(idx).ColorName=string(cell2mat(FileName(1)));  
        samples_all(idx).Method=string(cell2mat(FileName(2))); 

        samples_all(idx).Efficiency=table2array(FileContents(3,2));
        samples_all(idx).Efficiency_CM=table2array(FileContents(3,7)); % current-matched efficiency

        samples_all(idx).dE=table2array(FileContents(3,3));
        samples_all(idx).FileName=files(i).name;
        idx=idx+1;
        end
    end
end
cd('..')
save('samples_all.mat','samples_all')
%%
samples_max=struct([]);
dE_threshold = 25;
idx=1;
for i=1:length(color_names)
%     for k=1:length(methods)
        samples_max(idx).ColorName=cell2mat(color_names(i));
%         samples_max(idx).Method=cell2mat(methods(k));
        samples_max(idx).MaxEfficiency_CM=0; 

        for j=1:length(samples_all)
            if string(cell2mat(samples_all(j).ColorName))==string(cell2mat(color_names(i))) % && cell2mat(samples_all(j).Method)==string(cell2mat(methods(k)))
                if samples_all(j).Efficiency_CM > samples_max(idx).MaxEfficiency_CM && samples_all(j).dE < dE_threshold
                    samples_max(idx).MaxEfficiency=samples_all(j).Efficiency;
                    samples_max(idx).MaxEfficiency_CM=samples_all(j).Efficiency_CM;
                    samples_max(idx).Method=string(cell2mat(samples_all(j).Method));
                    samples_max(idx).dE=samples_all(j).dE;
                    samples_max(idx).FileName=samples_all(j).FileName;                           
                end
            end
        end
        
        idx=idx+1;
        
%     end
end

for i=1:length(samples_max) % saving excel sheets and plots in a separate folder
    try
        copyfile(["color_data\"+string(samples_max(i).FileName)],'color_data_and_plots_max')
        file_name=strsplit(samples_max(i).FileName(1:end-4),'_');
        png_name="plots\"+file_name(1)+"_"+lower(file_name(2))+"__"+file_name(4)+"_"+file_name(5)+"png";
        copyfile(png_name,'color_data_and_plots_max')              
    end
end
struct2table(samples_max)

